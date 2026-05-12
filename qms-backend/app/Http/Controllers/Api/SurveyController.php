<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Models\Survey;
use App\Models\SurveyQuestion;
use App\Models\SurveyToken;
use App\Models\SurveyResponse;
use App\Models\Client;
use App\Models\User;
use App\Models\Department;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Mail;

/**
 * SurveyController
 *
 * Handles all Survey / CSAT Management endpoints.
 *
 * Two modes:
 *   INTERNAL  — surveys sent to departments/staff (requires auth)
 *   CUSTOMER  — surveys sent to clients via unique token links (public, no auth)
 *
 * Route map:
 *   Authenticated (auth:sanctum):
 *     GET    /surveys                    → index
 *     POST   /surveys                    → store
 *     GET    /surveys/stats              → stats
 *     GET    /surveys/users              → users
 *     GET    /surveys/clients            → clients
 *     GET    /surveys/departments        → departments
 *     GET    /surveys/{id}              → show
 *     PUT    /surveys/{id}              → update
 *     DELETE /surveys/{id}              → destroy
 *     POST   /surveys/{id}/activate     → activate
 *     POST   /surveys/{id}/pause        → pause
 *     POST   /surveys/{id}/close        → close
 *     GET    /surveys/{id}/responses    → responses
 *     GET    /surveys/{id}/analytics    → analytics
 *     GET    /surveys/{id}/questions    → questions
 *     POST   /surveys/{id}/questions    → addQuestion
 *     PUT    /surveys/{id}/questions/{qid}    → updateQuestion
 *     DELETE /surveys/{id}/questions/{qid}    → deleteQuestion
 *     POST   /surveys/{id}/send-to-customers  → sendToCustomers   ← NEW
 *     GET    /surveys/{id}/tokens             → tokens            ← NEW
 *
 *   Public (no auth):
 *     GET    /survey-public/{token}           → publicShow        ← NEW
 *     POST   /survey-public/{token}/submit    → publicSubmit      ← NEW
 */
class SurveyController extends BaseController {

    // =========================================================================
    // SURVEY CRUD
    // =========================================================================

    public function index(Request $request): JsonResponse {
        $query = Survey::with(['department', 'client', 'createdBy'])
                ->when($request->status, fn($q) => $q->where('status', $request->status))
                ->when($request->audience_type, fn($q) => $q->where('audience_type', $request->audience_type))
                ->when($request->type, fn($q) => $q->where('type', $request->type))
                ->when($request->client_id, fn($q) => $q->where('client_id', $request->client_id))
                ->when($request->department_id, fn($q) => $q->where('department_id', $request->department_id))
                ->when($request->search, fn($q) => $q->where('title', 'like', "%{$request->search}%"))
                ->orderBy('created_at', 'desc');

        return $this->paginated($query);
    }

    public function store(Request $request): JsonResponse {
        $request->validate([
            'title' => 'required|string|max:255',
            'description' => 'nullable|string',
            'audience_type' => 'required|in:internal,customer',
            'type' => 'required|in:csat,nps,general,post_visit,post_service',
            'department_id' => 'required_if:audience_type,internal|nullable|exists:departments,id',
            'client_id' => 'nullable|exists:clients,id',
            'client_ids' => 'nullable|array',
            'client_ids.*' => 'exists:clients,id',
            'visit_id' => 'nullable|exists:visits,id',
            'start_date' => 'nullable|date',
            'end_date' => 'nullable|date|after_or_equal:start_date',
            'allow_anonymous' => 'boolean',
            'send_reminder' => 'boolean',
            'reminder_days' => 'nullable|integer|min:1|max:30',
            'thank_you_message' => 'nullable|string|max:500',
            'questions' => 'nullable|array',
            'questions.*.question' => 'required_with:questions|string',
            'questions.*.type' => 'required_with:questions|in:rating,nps,text,single_choice,multi_choice,yes_no',
            'questions.*.options' => 'nullable|array',
            'questions.*.scale_max' => 'nullable|integer|min:2|max:10',
            'questions.*.is_required' => 'boolean',
        ]);

        // Resolve which clients were selected from the multi-select
        $clientIds = $request->input('client_ids', []);
        if ($request->client_id && !in_array((int) $request->client_id, array_map('intval', $clientIds))) {
            $clientIds[] = (int) $request->client_id;
        }

        DB::transaction(function () use ($request, $clientIds, &$survey) {

            $survey = Survey::create(array_merge(
                                    $request->except(['questions', 'client_ids']),
                                    [
                                        'reference_no' => Survey::nextReferenceNo(),
                                        'created_by_id' => auth()->id(),
                                        // Save client_ids as JSON array directly on the survey record
                                        'client_ids' => !empty($clientIds) ? $clientIds : null,
                                        // Keep single client_id FK for backward compatibility
                                        'client_id' => count($clientIds) === 1 ? $clientIds[0] : null,
                                    ]
            ));

            // Seed questions
            if ($request->questions) {
                foreach ($request->questions as $index => $q) {
                    $survey->questions()->create(array_merge($q, ['sort_order' => $index]));
                }
            } else {
                $this->seedDefaultQuestions($survey);
            }

            // Pre-generate survey_tokens for each selected client
            if ($survey->audience_type === 'customer' && !empty($clientIds)) {
                $clients = Client::whereIn('id', $clientIds)
                        ->where('status', 'active')
                        ->get(['id', 'name', 'contact_email', 'contact_name']);

                foreach ($clients as $client) {
                    SurveyToken::create([
                        'survey_id' => $survey->id,
                        'client_id' => $client->id,
                        'token' => SurveyToken::generateToken(),
                        'recipient_email' => $client->contact_email,
                        'recipient_name' => $client->contact_name ?? $client->name,
                        'sent_at' => null,
                        'expires_at' => $survey->end_date ? \Carbon\Carbon::parse($survey->end_date)->endOfDay() : null,
                    ]);
                }
            }


            if ($survey->audience_type === 'internal' && $survey->department_id) {

                $users = User::where('department_id', $survey->department_id)
                        ->where('is_active', 1)
                        ->get();

                foreach ($users as $user) {

                    SurveyToken::create([
                        'survey_id' => $survey->id,
                        // add this column in table
                        'user_id' => $user->id,
                        'token' => SurveyToken::generateToken(),
                        'recipient_email' => $user->email,
                        'recipient_name' => $user->name,
                        'sent_at' => null,
                        'expires_at' => $survey->end_date ? \Carbon\Carbon::parse($survey->end_date)->endOfDay() : null,
                    ]);
                }

                $survey->update([
                    'total_sent' => count($users)
                ]);
            }
        });
        return $this->success(
                        $survey->load(['questions', 'department', 'client', 'createdBy']),
                        'Survey created',
                        201
        );
    }

    public function show(string $id): JsonResponse {
        $survey = Survey::with(['questions', 'department', 'client', 'visit', 'createdBy'])
                ->findOrFail((int) $id);

        return $this->success($survey);
    }

    public function update(Request $request, string $id): JsonResponse {
        $survey = Survey::findOrFail((int) $id);

        $request->validate([
            'title' => 'sometimes|required|string|max:255',
            'description' => 'nullable|string',
            'audience_type' => 'sometimes|in:internal,customer',
            'type' => 'sometimes|in:csat,nps,general,post_visit,post_service',
            'department_id' => 'nullable|exists:departments,id',
            'client_id' => 'nullable|exists:clients,id',
            'client_ids' => 'nullable|array',
            'client_ids.*' => 'exists:clients,id',
            'start_date' => 'nullable|date',
            'end_date' => 'nullable|date',
            'status' => 'nullable|in:draft,active,paused,closed',
            'thank_you_message' => 'nullable|string|max:500',
        ]);

        // Resolve client_ids from multi-select
        $clientIds = $request->input('client_ids', null);

        DB::transaction(function () use ($request, $clientIds, $survey) {

            // Save client_ids JSON array directly on the survey record
            $survey->update(array_merge(
                            $request->except(['client_ids', 'questions']),
                            [
                                // Store client_ids as JSON
                                'client_ids' => $clientIds !== null ? (!empty($clientIds) ? $clientIds : null) : $survey->client_ids, // keep existing if not sent
                                // Keep single client_id FK in sync
                                'client_id' => $clientIds !== null ? (count($clientIds) === 1 ? $clientIds[0] : null) : $survey->client_id,
                            ]
            ));

            // Sync survey_tokens when client_ids are explicitly updated
            if ($clientIds !== null && $survey->audience_type === 'customer') {

                $existingClientIds = $survey->tokens()->pluck('client_id')->toArray();
                $newIds = array_map('intval', $clientIds);

                // Add tokens for newly added clients
                $toAdd = array_diff($newIds, $existingClientIds);
                if (!empty($toAdd)) {
                    $clients = Client::whereIn('id', $toAdd)
                            ->where('status', 'active')
                            ->get(['id', 'name', 'contact_email', 'contact_name']);

                    foreach ($clients as $client) {
                        SurveyToken::create([
                            'survey_id' => $survey->id,
                            'client_id' => $client->id,
                            'token' => SurveyToken::generateToken(),
                            'recipient_email' => $client->contact_email,
                            'recipient_name' => $client->contact_name ?? $client->name,
                            'sent_at' => null,
                            'expires_at' => $survey->end_date ? \Carbon\Carbon::parse($survey->end_date)->endOfDay() : null,
                        ]);
                    }
                }

                // Remove tokens for de-selected clients (only if not yet sent/emailed)
                $toRemove = array_diff($existingClientIds, $newIds);
                if (!empty($toRemove)) {
                    $survey->tokens()
                            ->whereIn('client_id', $toRemove)
                            ->whereNull('sent_at')
                            ->delete();
                }
            }

            if ($survey->audience_type === 'internal' && $survey->department_id) {

                // Existing internal user tokens
                $existingUserIds = $survey->tokens()
                        ->whereNotNull('user_id')
                        ->pluck('user_id')
                        ->map(fn($id) => (int) $id)
                        ->toArray();

                // Current department active users
                $departmentUserIds = User::where('department_id', $survey->department_id)
                        ->where('status', 'active')
                        ->pluck('id')
                        ->map(fn($id) => (int) $id)
                        ->toArray();

                // Users to add
                $toAdd = array_diff($departmentUserIds, $existingUserIds);

                if (!empty($toAdd)) {

                    $users = User::whereIn('id', $toAdd)->get();

                    foreach ($users as $user) {

                        SurveyToken::create([
                            'survey_id' => $survey->id,
                            'user_id' => $user->id,
                            'token' => SurveyToken::generateToken(),
                            'recipient_email' => $user->email,
                            'recipient_name' => $user->name,
                            'sent_at' => null,
                            'expires_at' => $survey->end_date ? \Carbon\Carbon::parse($survey->end_date)->endOfDay() : null,
                        ]);
                    }
                }
                
                  // Remove tokens for users no longer in department
                $toRemove = array_diff($existingUserIds, $departmentUserIds);

                if (!empty($toRemove)) {

                    $survey->tokens()
                            ->whereIn('user_id', $toRemove)
                            ->whereNull('sent_at')
                            ->delete();
                }
                
                // Update total_sent
                $survey->update([
                    'total_sent' => count($departmentUserIds)
                ]);
            }


            // Sync questions if provided
            if ($request->has('questions')) {
                $incoming = collect($request->questions ?? []);

                // Delete questions not in the incoming list
                $incomingIds = $incoming->pluck('id')->filter()->values()->toArray();
                $survey->questions()->when(!empty($incomingIds),
                        fn($q) => $q->whereNotIn('id', $incomingIds)
                )->delete();

                // Update existing or create new questions
                foreach ($incoming as $index => $qData) {
                    $options = isset($qData['options']) && is_array($qData['options']) ? array_filter($qData['options'], fn($o) => trim((string) $o) !== '') : null;

                    if (!empty($qData['id'])) {
                        // Update existing question
                        $survey->questions()->where('id', $qData['id'])->update([
                            'question' => $qData['question'] ?? '',
                            'type' => $qData['type'] ?? 'rating',
                            'options' => !empty($options) ? array_values($options) : null,
                            'scale_max' => $qData['scale_max'] ?? 5,
                            'is_required' => $qData['is_required'] ?? true,
                            'sort_order' => $index,
                        ]);
                    } else {
                        // Create new question
                        $survey->questions()->create([
                            'question' => $qData['question'] ?? '',
                            'type' => $qData['type'] ?? 'rating',
                            'options' => !empty($options) ? array_values($options) : null,
                            'scale_max' => $qData['scale_max'] ?? 5,
                            'is_required' => $qData['is_required'] ?? true,
                            'sort_order' => $index,
                        ]);
                    }
                }

                
                
            }
        });

        return $this->success($survey->fresh()->load(['questions', 'department', 'client']), 'Survey updated');
    }

    public function destroy(string $id): JsonResponse {
        $survey = Survey::findOrFail((int) $id);

        if ($survey->status === 'active') {
            return $this->error('Cannot delete an active survey. Close it first.', 422);
        }

        $survey->delete();

        return $this->success(null, 'Survey deleted');
    }

    // =========================================================================
    // LIFECYCLE
    // =========================================================================

    public function activate(string $id): JsonResponse {
        $survey = Survey::findOrFail((int) $id);

        if ($survey->questions()->count() === 0) {
            return $this->error('Cannot activate a survey with no questions.', 422);
        }

        $survey->update(['status' => 'active', 'start_date' => $survey->start_date ?? now()->toDateString()]);
        $this->logActivity('surveys', 'activated', $survey);

        return $this->success($survey->fresh(), 'Survey activated');
    }

    public function pause(string $id): JsonResponse {
        $survey = Survey::findOrFail((int) $id);
        $survey->update(['status' => 'paused']);
        $this->logActivity('surveys', 'paused', $survey);

        return $this->success($survey->fresh(), 'Survey paused');
    }

    public function close(string $id): JsonResponse {
        $survey = Survey::findOrFail((int) $id);
        $survey->update(['status' => 'closed', 'end_date' => now()->toDateString()]);
        $this->logActivity('surveys', 'closed', $survey);

        return $this->success($survey->fresh(), 'Survey closed');
    }

    // =========================================================================
    // QUESTIONS
    // =========================================================================

    public function questions(string $id): JsonResponse {
        $survey = Survey::findOrFail((int) $id);
        $questions = $survey->questions()->orderBy('sort_order')->get();

        return $this->success($questions);
    }

    public function addQuestion(Request $request, string $id): JsonResponse {
        $validated = $request->validate([
            'question' => 'required|string|max:1000',
            'type' => 'required|in:rating,nps,text,single_choice,multi_choice,yes_no',
            'options' => 'nullable|array',
            'scale_max' => 'nullable|integer|min:2|max:10',
            'is_required' => 'boolean',
            'sort_order' => 'nullable|integer',
        ]);

        $survey = Survey::findOrFail((int) $id);
        $question = $survey->questions()->create(array_merge(
                        $validated,
                        ['sort_order' => $request->sort_order ?? $survey->questions()->max('sort_order') + 1]
        ));

        return $this->success($question, 'Question added', 201);
    }

    public function updateQuestion(Request $request, string $id, string $qid): JsonResponse {
        $survey = Survey::findOrFail((int) $id);
        $question = $survey->questions()->findOrFail((int) $qid);

        $validated = $request->validate([
            'question' => 'sometimes|string|max:1000',
            'type' => 'sometimes|in:rating,nps,text,single_choice,multi_choice,yes_no',
            'options' => 'nullable|array',
            'scale_max' => 'nullable|integer|min:2|max:10',
            'is_required' => 'boolean',
            'sort_order' => 'nullable|integer',
        ]);

        $question->update($validated);

        return $this->success($question->fresh(), 'Question updated');
    }

    public function deleteQuestion(string $id, string $qid): JsonResponse {
        $survey = Survey::findOrFail((int) $id);
        $question = $survey->questions()->findOrFail((int) $qid);
        $question->delete();

        return $this->success(null, 'Question deleted');
    }

    // =========================================================================
    // CUSTOMER SURVEY — SEND TOKENS
    // =========================================================================

    /**
     * Send survey to customers (generate tokens + email links).
     * Route: POST /api/surveys/{id}/send-to-customers
     *
     * Body:
     *   client_ids: array of client IDs (or empty = send to ALL active clients)
     *   send_email: boolean — whether to email the link or just generate tokens
     */
    public function sendToCustomers(Request $request, string $id): JsonResponse {
        $request->validate([
            'client_ids' => 'nullable|array',
            'client_ids.*' => 'exists:clients,id',
            'send_email' => 'boolean',
        ]);

        $survey = Survey::findOrFail((int) $id);

        if ($survey->audience_type !== 'customer') {
            return $this->error('This survey is not configured for customers. Change audience_type to "customer" first.', 422);
        }

        if ($survey->status !== 'active') {
            return $this->error('Survey must be active before sending to customers.', 422);
        }

        // Determine which clients to send to
        $clientQuery = Client::where('status', 'active');
        if ($request->client_ids) {
            $clientQuery->whereIn('id', $request->client_ids);
        } elseif ($survey->client_id) {
            $clientQuery->where('id', $survey->client_id);
        }

        $clients = $clientQuery->get(['id', 'name', 'contact_email', 'contact_name']);

        if ($clients->isEmpty()) {
            return $this->error('No active clients found to send the survey to.', 422);
        }

        $sent = 0;
        $skipped = 0;

        DB::transaction(function () use ($survey, $clients, $request, &$sent, &$skipped) {
            foreach ($clients as $client) {
                // Skip if already sent to this client for this survey
                $existing = SurveyToken::where('survey_id', $survey->id)
                        ->where('client_id', $client->id)
                        ->first();

                if ($existing) {
                    $skipped++;
                    continue;
                }

                $token = SurveyToken::create([
                            'survey_id' => $survey->id,
                            'client_id' => $client->id,
                            'token' => SurveyToken::generateToken(),
                            'recipient_email' => $client->contact_email,
                            'recipient_name' => $client->contact_name ?? $client->name,
                            'sent_at' => now(),
                            'expires_at' => $survey->end_date ? \Carbon\Carbon::parse($survey->end_date)->endOfDay() : null,
                ]);

                // Send email if requested and client has email
                if ($request->boolean('send_email', true) && $client->contact_email) {
                    try {
                        Mail::send('emails.survey-invitation', [
                            'survey' => $survey,
                            'client' => $client,
                            'surveyUrl' => config('app.frontend_url') . '/survey/' . $token->token,
                                ], function ($mail) use ($client, $survey) {
                                    $mail->to('j.mani@dbroker.com.sa', $client->contact_name ?? $client->name)
                                            ->subject('Your feedback matters — ' . $survey->title);
                                });
                    } catch (\Exception $e) {
                        // Log but don't fail — token still created
                        \Log::warning('Survey email failed for client ' . $client->id . ': ' . $e->getMessage());
                    }
                }

                $sent++;
            }

            // Update total_sent counter
            $survey->increment('total_sent', $sent);
        });

        return $this->success([
                    'sent' => $sent,
                    'skipped' => $skipped,
                    'message' => "{$sent} token(s) generated. {$skipped} already sent.",
        ]);
    }

    /**
     * List all tokens for a survey (shows which clients received it and their status).
     * Route: GET /api/surveys/{id}/tokens
     */
    public function tokens(string $id): JsonResponse {
        $survey = Survey::findOrFail((int) $id);
        $tokens = $survey->tokens()->with('client')
                ->orderBy('sent_at', 'desc')
                ->get();

        return $this->success($tokens->map(fn($t) => [
                            'id' => $t->id,
                            'client' => $t->client ? ['id' => $t->client->id, 'name' => $t->client->name] : null,
                            'recipient_name' => $t->recipient_name,
                            'recipient_email' => $t->recipient_email,
                            'is_completed' => $t->is_completed,
                            'sent_at' => $t->sent_at,
                            'completed_at' => $t->completed_at,
                            'expires_at' => $t->expires_at,
                            'survey_link' => config('app.frontend_url') . '/survey/' . $t->token,
        ]));
    }

    // =========================================================================
    // PUBLIC ENDPOINTS — No authentication required
    // =========================================================================

    /**
     * Show survey form for a customer (via token link).
     * Route: GET /api/survey-public/{token}
     */
    public function publicShow(string $token): JsonResponse {
        $surveyToken = SurveyToken::with(['survey.questions', 'client'])
                ->where('token', $token)
                ->first();

        if (!$surveyToken) {
            return $this->error('Invalid survey link.', 404);
        }

        if (!$surveyToken->isValid()) {
            if ($surveyToken->is_completed) {
                return $this->error('You have already submitted this survey. Thank you for your feedback!', 410);
            }
            return $this->error('This survey link has expired.', 410);
        }

        $survey = $surveyToken->survey;

        if ($survey->status !== 'active') {
            return $this->error('This survey is no longer accepting responses.', 410);
        }

        return $this->success([
                    'survey' => [
                        'id' => $survey->id,
                        'title' => $survey->title,
                        'description' => $survey->description,
                        'type' => $survey->type,
                        'questions' => $survey->questions->map(fn($q) => [
                            'id' => $q->id,
                            'question' => $q->question,
                            'type' => $q->type,
                            'options' => $q->options,
                            'scale_max' => $q->scale_max,
                            'is_required' => $q->is_required,
                            'sort_order' => $q->sort_order,
                                ]),
                    ],
                    'recipient_name' => $surveyToken->recipient_name,
                    'recipient_email' => $surveyToken->recipient_email,
                    'client_name' => $surveyToken->client?->name,
        ]);
    }

    /**
     * Submit a customer survey response (via token).
     * Route: POST /api/survey-public/{token}/submit
     */
    public function publicSubmit(Request $request, string $token): JsonResponse {
        $surveyToken = SurveyToken::with('survey.questions')
                ->where('token', $token)
                ->first();

        if (!$surveyToken) {
            return $this->error('Invalid survey link.', 404);
        }

        if (!$surveyToken->isValid()) {
            return $this->error('This survey link has already been used or has expired.', 410);
        }

        $request->validate([
            'answers' => 'required|array|min:1',
            'answers.*.question_id' => 'required|integer',
            'answers.*.answer' => 'required',
            'answers.*.score' => 'nullable|numeric',
            'respondent_name' => 'nullable|string|max:200',
            'respondent_email' => 'nullable|email|max:200',
            'comments' => 'nullable|string|max:2000',
        ]);

        $survey = $surveyToken->survey;

        // Validate required questions are answered
        $requiredQuestionIds = $survey->questions->where('is_required', true)->pluck('id')->toArray();
        $answeredIds = collect($request->answers)->pluck('question_id')->toArray();
        $missing = array_diff($requiredQuestionIds, $answeredIds);

        if (!empty($missing)) {
            return $this->error('Please answer all required questions.', 422);
        }

        DB::transaction(function () use ($request, $survey, $surveyToken) {
            // Calculate overall score from rated answers
            $scores = collect($request->answers)
                    ->filter(fn($a) => isset($a['score']) && is_numeric($a['score']))
                    ->pluck('score');

            $overallScore = $scores->isEmpty() ? null : round((float) $scores->avg(), 2);

            // Create the response
            SurveyResponse::create([
                'survey_id' => $survey->id,
                'client_id' => $surveyToken->client_id,
                'token_id' => $surveyToken->id,
                'respondent_name' => $request->respondent_name ?? $surveyToken->recipient_name,
                'respondent_email' => $request->respondent_email ?? $surveyToken->recipient_email,
                'answers' => $request->answers,
                'overall_score' => $overallScore,
                'comments' => $request->comments,
                'ip_address' => $request->ip(),
                'submitted_at' => now(),
            ]);

            // Mark token as completed
            $surveyToken->update([
                'is_completed' => true,
                'completed_at' => now(),
            ]);

            // Update survey aggregate stats
            $survey->increment('total_responses');
            $allScores = $survey->responses()->whereNotNull('overall_score')->pluck('overall_score');
            if ($allScores->isNotEmpty()) {
                $survey->update(['average_score' => round((float) $allScores->avg(), 2)]);
            }
        });

        return $this->success(null, 'Thank you for your feedback! Your response has been recorded.');
    }

    // =========================================================================
    // INTERNAL RESPONSE SUBMISSION (authenticated users / departments)
    // =========================================================================

    /**
     * Submit a response for an internal survey.
     * Route: POST /api/surveys/{id}/responses
     */
    public function submitResponse(Request $request, string $id): JsonResponse {
        $survey = Survey::with('questions')->findOrFail((int) $id);

        if ($survey->audience_type !== 'internal') {
            return $this->error('This survey is for customers. Use the public survey link instead.', 422);
        }

        if ($survey->status !== 'active') {
            return $this->error('This survey is not currently accepting responses.', 422);
        }

        $request->validate([
            'answers' => 'required|array|min:1',
            'answers.*.question_id' => 'required|integer',
            'answers.*.answer' => 'required',
            'answers.*.score' => 'nullable|numeric',
            'comments' => 'nullable|string|max:2000',
        ]);

        // Prevent duplicate response from same user
        $alreadyResponded = SurveyResponse::where('survey_id', $survey->id)
                ->where('user_id', auth()->id())
                ->exists();

        if ($alreadyResponded) {
            return $this->error('You have already submitted a response for this survey.', 422);
        }

        $scores = collect($request->answers)
                ->filter(fn($a) => isset($a['score']) && is_numeric($a['score']))
                ->pluck('score');

        $overallScore = $scores->isEmpty() ? null : round((float) $scores->avg(), 2);

        SurveyResponse::create([
            'survey_id' => $survey->id,
            'user_id' => auth()->id(),
            'department_id' => auth()->user()->department_id ?? null,
            'answers' => $request->answers,
            'overall_score' => $overallScore,
            'comments' => $request->comments,
            'ip_address' => $request->ip(),
            'submitted_at' => now(),
        ]);

        $survey->increment('total_responses');
        $allScores = $survey->responses()->whereNotNull('overall_score')->pluck('overall_score');
        if ($allScores->isNotEmpty()) {
            $survey->update(['average_score' => round((float) $allScores->avg(), 2)]);
        }

        return $this->success(null, 'Response submitted. Thank you!', 201);
    }

    // =========================================================================
    // ANALYTICS & RESPONSES
    // =========================================================================

    public function responses(string $id): JsonResponse {
        $survey = Survey::findOrFail((int) $id);
        $responses = $survey->responses()
                ->with(['user', 'client'])
                ->orderBy('submitted_at', 'desc')
                ->get();

        return $this->success($responses);
    }

    public function analytics(string $id): JsonResponse {
        $survey = Survey::with('questions')->findOrFail((int) $id);
        $responses = $survey->responses()->get();

        if ($responses->isEmpty()) {
            return $this->success([
                        'total_sent' => $survey->total_sent,
                        'total_responses' => 0,
                        'response_rate' => 0,
                        'average_score' => null,
                        'nps_score' => null,
                        'by_question' => [],
                        'by_client' => [],
                        'trend' => [],
            ]);
        }

        // Per-question analytics
        $byQuestion = $survey->questions->map(function ($q) use ($responses) {
            $answers = collect();
            foreach ($responses as $r) {
                $answer = collect($r->answers)->firstWhere('question_id', $q->id);
                if ($answer)
                    $answers->push($answer);
            }

            $data = ['question_id' => $q->id, 'question' => $q->question, 'type' => $q->type, 'total_answers' => $answers->count()];

            if (in_array($q->type, ['rating', 'nps'])) {
                $scores = $answers->filter(fn($a) => isset($a['score']))->pluck('score');
                $data['average_score'] = $scores->isEmpty() ? null : round((float) $scores->avg(), 2);
                $data['distribution'] = $scores->countBy()->sortKeys()->toArray();
            } elseif ($q->type === 'yes_no') {
                $data['yes_count'] = $answers->filter(fn($a) => $a['answer'] === 'yes')->count();
                $data['no_count'] = $answers->filter(fn($a) => $a['answer'] === 'no')->count();
            } elseif (in_array($q->type, ['single_choice', 'multi_choice'])) {
                $data['distribution'] = $answers->flatMap(fn($a) => (array) $a['answer'])->countBy()->toArray();
            }

            return $data;
        });

        // NPS calculation (if any NPS question exists)
        $npsQuestion = $survey->questions->firstWhere('type', 'nps');
        $npsScore = null;
        if ($npsQuestion) {
            $npsAnswers = $responses->flatMap(fn($r) => collect($r->answers)->where('question_id', $npsQuestion->id));
            $scores = $npsAnswers->pluck('score')->filter()->values();
            if ($scores->isNotEmpty()) {
                $promoters = $scores->filter(fn($s) => $s >= 9)->count();
                $detractors = $scores->filter(fn($s) => $s <= 6)->count();
                $total = $scores->count();
                $npsScore = $total > 0 ? round((($promoters - $detractors) / $total) * 100, 1) : 0;
            }
        }

        // Response trend (last 30 days)
        $trend = $responses
                ->groupBy(fn($r) => $r->submitted_at->toDateString())
                ->map(fn($g, $date) => ['date' => $date, 'count' => $g->count()])
                ->values();

        // By client (for customer surveys)
        $byClient = [];
        if ($survey->audience_type === 'customer') {
            $byClient = $responses->groupBy('client_id')->map(function ($group, $clientId) {
                        $first = $group->first();
                        return [
                    'client_id' => $clientId,
                    'client_name' => $first->client?->name ?? 'Anonymous',
                    'responses' => $group->count(),
                    'average_score' => round((float) $group->avg('overall_score'), 2),
                        ];
                    })->values();
        }

        return $this->success([
                    'total_sent' => $survey->total_sent,
                    'total_responses' => $responses->count(),
                    'response_rate' => $survey->total_sent > 0 ? round(($responses->count() / $survey->total_sent) * 100, 1) : 0,
                    'average_score' => $survey->average_score,
                    'nps_score' => $npsScore,
                    'by_question' => $byQuestion,
                    'by_client' => $byClient,
                    'trend' => $trend,
        ]);
    }

    // =========================================================================
    // DROPDOWN HELPERS
    // =========================================================================

    public function stats(): JsonResponse {
        return $this->success([
                    'total' => Survey::count(),
                    'active' => Survey::where('status', 'active')->count(),
                    'draft' => Survey::where('status', 'draft')->count(),
                    'closed' => Survey::where('status', 'closed')->count(),
                    'internal' => Survey::where('audience_type', 'internal')->count(),
                    'customer' => Survey::where('audience_type', 'customer')->count(),
                    'total_responses' => SurveyResponse::count(),
                    'average_score' => round((float) Survey::where('status', 'active')->avg('average_score'), 2),
        ]);
    }

    public function users(): JsonResponse {
        return $this->success(\App\Models\User::where('is_active', true)->orderBy('name')->get(['id', 'name', 'email']));
    }

    public function clients(): JsonResponse {
        return $this->success(Client::where('status', 'active')->orderBy('name')->get(['id', 'name', 'contact_email', 'contact_name']));
    }

    public function departments(): JsonResponse {
        return $this->success(Department::orderBy('name')->get(['id', 'name']));
    }

    // =========================================================================
    // PRIVATE HELPERS
    // =========================================================================

    /**
     * Seed default questions based on survey type.
     */
    private function seedDefaultQuestions(Survey $survey): void {
        $defaults = match ($survey->type) {
            'csat' => [
                ['question' => 'Overall, how satisfied are you with our service?', 'type' => 'rating', 'scale_max' => 5],
                ['question' => 'How would you rate the quality of our work?', 'type' => 'rating', 'scale_max' => 5],
                ['question' => 'How responsive was our team to your needs?', 'type' => 'rating', 'scale_max' => 5],
                ['question' => 'How likely are you to recommend us to others?', 'type' => 'nps', 'scale_max' => 10],
                ['question' => 'What could we do better?', 'type' => 'text', 'is_required' => false],
            ],
            'nps' => [
                ['question' => 'On a scale of 0–10, how likely are you to recommend Diamond Insurance Brokers to a colleague or friend?', 'type' => 'nps', 'scale_max' => 10],
                ['question' => 'What is the main reason for your score?', 'type' => 'text', 'is_required' => false],
            ],
            'post_visit' => [
                ['question' => 'How would you rate the overall meeting?', 'type' => 'rating', 'scale_max' => 5],
                ['question' => 'Were the meeting objectives clearly communicated?', 'type' => 'yes_no'],
                ['question' => 'How satisfied were you with the outcomes?', 'type' => 'rating', 'scale_max' => 5],
                ['question' => 'Additional comments or suggestions', 'type' => 'text', 'is_required' => false],
            ],
            default => [
                ['question' => 'How would you rate our overall performance?', 'type' => 'rating', 'scale_max' => 5],
                ['question' => 'Please share any additional feedback', 'type' => 'text', 'is_required' => false],
            ],
        };

        foreach ($defaults as $index => $q) {
            $survey->questions()->create(array_merge([
                'scale_max' => 5,
                'is_required' => true,
                'sort_order' => $index,
                            ], $q));
        }
    }
}
