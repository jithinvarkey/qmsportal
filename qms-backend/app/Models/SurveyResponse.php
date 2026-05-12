<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;




// ============================================================
// SurveyResponse
// ============================================================
class SurveyResponse extends Model
{
    protected $table    = 'survey_responses';
    protected $fillable = [
        'survey_id', 'user_id', 'department_id',
        'client_id', 'token_id',
        'respondent_name', 'respondent_email',
        'answers', 'overall_score', 'comments', 'ip_address', 'submitted_at',
    ];

    protected $casts = [
        'answers'       => 'array',
        'overall_score' => 'float',
        'submitted_at'  => 'datetime',
    ];

    public function survey(): BelongsTo
    {
        return $this->belongsTo(Survey::class);
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function client(): BelongsTo
    {
        return $this->belongsTo(Client::class);
    }

    public function token(): BelongsTo
    {
        return $this->belongsTo(SurveyToken::class, 'token_id');
    }

    /** Calculate overall score from answers array */
    public function calculateScore(): float
    {
        $scores = collect($this->answers)
            ->filter(fn ($a) => isset($a['score']) && is_numeric($a['score']))
            ->pluck('score');

        return $scores->isEmpty() ? 0.0 : round((float) $scores->avg(), 2);
    }
}
