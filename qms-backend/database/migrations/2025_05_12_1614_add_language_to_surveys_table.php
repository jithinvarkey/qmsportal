<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * AddLanguageToSurveysTable
 *
 * Adds language column — controls survey direction:
 *   'en' → Left-to-Right (default)
 *   'ar' → Right-to-Left (Arabic)
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('surveys', function (Blueprint $table) {
            $table->enum('language', ['en', 'ar'])
                  ->default('en')
                  ->after('font_family')
                  ->comment('Survey language: en = LTR, ar = RTL Arabic');
        });
    }

    public function down(): void
    {
        Schema::table('surveys', function (Blueprint $table) {
            $table->dropColumn('language');
        });
    }
};
