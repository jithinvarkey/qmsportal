<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * AddBrandingToSurveysTable
 *
 * Adds branding columns to the surveys table:
 *   logo_url          — URL to uploaded logo image
 *   background_color  — CSS hex color for page background e.g. #0f172a
 *   background_image  — URL to background image
 *   primary_color     — Accent/button color e.g. #0ea5e9
 *   font_family       — Font choice: 'system', 'serif', 'mono'
 *   header_text_color — Header text color
 *   card_color        — Survey card background color
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('surveys', function (Blueprint $table) {
            $table->string('logo_url', 500)->nullable()->after('reminder_days');
            $table->string('background_color', 20)->nullable()->default('#0f172a')->after('logo_url');
            $table->string('background_image', 500)->nullable()->after('background_color');
            $table->string('primary_color', 20)->nullable()->default('#0ea5e9')->after('background_image');
            $table->string('header_text_color', 20)->nullable()->default('#f1f5f9')->after('primary_color');
            $table->string('card_color', 20)->nullable()->default('#1e293b')->after('header_text_color');
            $table->enum('font_family', ['system', 'serif', 'mono'])->default('system')->after('card_color');
        });
    }

    public function down(): void
    {
        Schema::table('surveys', function (Blueprint $table) {
            $table->dropColumn([
                'logo_url', 'background_color', 'background_image',
                'primary_color', 'header_text_color', 'card_color', 'font_family',
            ]);
        });
    }
};
