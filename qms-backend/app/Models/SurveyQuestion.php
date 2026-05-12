<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * SurveyQuestion Model
 *
 * FIX: options column must always return an array, never null.
 * When stored as NULL in DB, the API was returning null to Angular.
 * Angular's *ngFor on null throws a silent error → options don't render.
 *
 * Solution: override options getter to always return array.
 */
class SurveyQuestion extends Model
{
    protected $table    = 'survey_questions';
    protected $fillable = [
        'survey_id', 'question', 'type', 'options',
        'scale_max', 'is_required', 'sort_order',
    ];

    protected $casts = [
        'options'     => 'array',
        'is_required' => 'boolean',
        'scale_max'   => 'integer',
        'sort_order'  => 'integer',
    ];

    /**
     * Always return an array for options, even when DB stores NULL.
     * This prevents *ngFor from receiving null and silently failing.
     *
     * @return array<string>
     */
    public function getOptionsAttribute(mixed $value): array
    {
        if (is_null($value)) {
            return [];
        }

        if (is_string($value)) {
            $decoded = json_decode($value, true);
            return is_array($decoded) ? $decoded : [];
        }

        return is_array($value) ? $value : [];
    }

    public function survey(): BelongsTo
    {
        return $this->belongsTo(Survey::class);
    }
}
