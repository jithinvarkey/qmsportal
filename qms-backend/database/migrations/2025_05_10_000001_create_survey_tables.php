<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * CreateSurveyTables
 *
 * Creates the full survey/CSAT schema supporting both:
 *   - internal  → sent to departments/users
 *   - customer  → sent to clients via public token link
 */
return new class extends Migration
{
    public function up(): void
    {
        // ── surveys ──────────────────────────────────────────────────────────
        Schema::create('surveys', function (Blueprint $table) {
            $table->id();
            $table->string('reference_no', 50)->unique();
            $table->string('title', 255);
            $table->text('description')->nullable();

            // Audience type — determines who receives this survey
            $table->enum('audience_type', ['internal', 'customer'])
                  ->default('internal')
                  ->comment('internal = departments/users, customer = clients via token');

            $table->enum('status', ['draft', 'active', 'paused', 'closed'])->default('draft');
            $table->enum('type', ['csat', 'nps', 'general', 'post_visit', 'post_service'])->default('csat');

            // Internal survey fields
            $table->unsignedBigInteger('department_id')->nullable();
            $table->foreign('department_id')->references('id')->on('departments')->nullOnDelete();

            // Customer survey fields
            $table->unsignedBigInteger('client_id')->nullable()
                  ->comment('Specific client — null means sent to all active clients');
            $table->foreign('client_id')->references('id')->on('clients')->nullOnDelete();

            // Optional: link to a visit or complaint that triggered this survey
            $table->unsignedBigInteger('visit_id')->nullable();
            $table->foreign('visit_id')->references('id')->on('visits')->nullOnDelete();

            // Scheduling
            $table->date('start_date')->nullable();
            $table->date('end_date')->nullable();
            $table->boolean('allow_anonymous')->default(false);
            $table->boolean('send_reminder')->default(false);
            $table->integer('reminder_days')->nullable()->comment('Days before end_date to send reminder');

            // Meta
            $table->unsignedBigInteger('created_by_id')->nullable();
            $table->foreign('created_by_id')->references('id')->on('users')->nullOnDelete();
            $table->integer('total_sent')->default(0);
            $table->integer('total_responses')->default(0);
            $table->decimal('average_score', 4, 2)->nullable();

            $table->timestamps();
        });

        // ── survey_questions ─────────────────────────────────────────────────
        Schema::create('survey_questions', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('survey_id');
            $table->foreign('survey_id')->references('id')->on('surveys')->cascadeOnDelete();

            $table->text('question');
            $table->enum('type', [
                'rating',        // 1–5 or 1–10 star/scale
                'nps',           // 0–10 Net Promoter Score
                'text',          // open text
                'single_choice', // radio buttons
                'multi_choice',  // checkboxes
                'yes_no',        // boolean
            ])->default('rating');

            $table->json('options')->nullable()->comment('For single/multi choice questions');
            $table->integer('scale_max')->default(5)->comment('Max for rating/nps questions');
            $table->boolean('is_required')->default(true);
            $table->integer('sort_order')->default(0);
            $table->timestamps();
        });

        // ── survey_tokens ─────────────────────────────────────────────────────
        // One token per client per survey — enables public (no-login) submission
        Schema::create('survey_tokens', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('survey_id');
            $table->foreign('survey_id')->references('id')->on('surveys')->cascadeOnDelete();

            $table->unsignedBigInteger('client_id')->nullable();
            $table->foreign('client_id')->references('id')->on('clients')->nullOnDelete();

            $table->string('token', 64)->unique()->comment('Unique token for the survey link');
            $table->string('recipient_email', 200)->nullable();
            $table->string('recipient_name', 200)->nullable();

            $table->boolean('is_completed')->default(false);
            $table->timestamp('sent_at')->nullable();
            $table->timestamp('completed_at')->nullable();
            $table->timestamp('expires_at')->nullable();

            $table->timestamps();
        });

        // ── survey_responses ──────────────────────────────────────────────────
        Schema::create('survey_responses', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('survey_id');
            $table->foreign('survey_id')->references('id')->on('surveys')->cascadeOnDelete();

            // For internal responses
            $table->unsignedBigInteger('user_id')->nullable();
            $table->foreign('user_id')->references('id')->on('users')->nullOnDelete();
            $table->unsignedBigInteger('department_id')->nullable();
            $table->foreign('department_id')->references('id')->on('departments')->nullOnDelete();

            // For customer responses
            $table->unsignedBigInteger('client_id')->nullable();
            $table->foreign('client_id')->references('id')->on('clients')->nullOnDelete();
            $table->unsignedBigInteger('token_id')->nullable();
            $table->foreign('token_id')->references('id')->on('survey_tokens')->nullOnDelete();

            // Respondent info (captured for anonymous/customer)
            $table->string('respondent_name', 200)->nullable();
            $table->string('respondent_email', 200)->nullable();

            $table->json('answers')->comment('Array of {question_id, answer, score}');
            $table->decimal('overall_score', 4, 2)->nullable();
            $table->text('comments')->nullable();
            $table->string('ip_address', 45)->nullable();
            $table->timestamp('submitted_at')->useCurrent();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('survey_responses');
        Schema::dropIfExists('survey_tokens');
        Schema::dropIfExists('survey_questions');
        Schema::dropIfExists('surveys');
    }
};
