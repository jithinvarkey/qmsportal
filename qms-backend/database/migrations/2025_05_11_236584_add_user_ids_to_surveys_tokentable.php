<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * AddClientIdsToSurveysTable
 *
 * Adds a JSON column `client_ids` to the surveys table to store
 * the array of selected client IDs directly on the survey record.
 *
 * This removes the need to query survey_tokens to know which clients
 * were targeted when the survey was created or edited.
 *
 * Examples:
 *   NULL           → no specific clients chosen (send to ALL active clients)
 *   [10, 25, 38]   → these three clients are targeted
 *   [42]           → single client targeted
 */
return new class extends Migration
{
    public function up(): void
    {
     
Schema::table('survey_tokens', function (Blueprint $table) {

    $table->foreignId('user_id')
        ->nullable()
        ->after('client_id')
        ->constrained()
        ->nullOnDelete();
});


    }

    public function down(): void
    {
      Schema::table('survey_tokens', function (Blueprint $table) {
            $table->dropColumn('user_id');
        }); 
    }
};
