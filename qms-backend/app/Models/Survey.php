<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * Survey Model
 *
 * @property int|null    $client_id      Single client FK (null when multiple selected)
 * @property array|null  $client_ids     Array of selected client IDs stored as JSON
 *                                       NULL = send to ALL active clients
 *                                       [10, 25] = only these clients targeted
 */
class Survey extends Model
{
    protected $table    = 'surveys';

    protected $fillable = [
        'reference_no',
        'title',
        'description',
        'audience_type',
        'status',
        'type',
        'department_id',
        'client_id',
        'client_ids',        // ← JSON column for multiple client IDs
        'visit_id',
        'start_date',
        'end_date',
        'allow_anonymous',
        'send_reminder',
        'reminder_days',
        'created_by_id',
        'total_sent',
        'total_responses',
        'average_score',
        // Branding
        'logo_url',
        'background_color',
        'background_image',
        'primary_color',
        'header_text_color',
        'card_color',
        'font_family',
        'language',
    ];

    protected $casts = [
        'start_date'      => 'date',
        'end_date'        => 'date',
        'allow_anonymous' => 'boolean',
        'send_reminder'   => 'boolean',
        'average_score'   => 'float',
        'client_ids'      => 'array',   // ← auto cast JSON ↔ PHP array
    ];

    // ── Relationships ──────────────────────────────────────────────────────

    public function department(): BelongsTo
    {
        return $this->belongsTo(Department::class);
    }

    public function client(): BelongsTo
    {
        return $this->belongsTo(Client::class);
    }

    public function visit(): BelongsTo
    {
        return $this->belongsTo(Visit::class);
    }

    public function createdBy(): BelongsTo
    {
        return $this->belongsTo(User::class, 'created_by_id');
    }

    public function questions(): HasMany
    {
        return $this->hasMany(SurveyQuestion::class)->orderBy('sort_order');
    }

    public function tokens(): HasMany
    {
        return $this->hasMany(SurveyToken::class);
    }

    public function responses(): HasMany
    {
        return $this->hasMany(SurveyResponse::class);
    }

    // ── Helpers ────────────────────────────────────────────────────────────

    /**
     * Returns the resolved list of client IDs for this survey.
     * If client_ids is set, returns those.
     * If only client_id is set (legacy), wraps it in an array.
     * If neither is set, returns empty array (means ALL clients).
     *
     * @return array<int>
     */
    public function resolvedClientIds(): array
    {
        if (! empty($this->client_ids)) {
            return array_map('intval', $this->client_ids);
        }

        if ($this->client_id) {
            return [(int) $this->client_id];
        }

        return [];
    }

    /** @return bool Whether this survey targets specific clients */
    public function hasSpecificClients(): bool
    {
        return ! empty($this->resolvedClientIds());
    }

    /** Generate next reference number e.g. SRV-2026-0001 */
    public static function nextReferenceNo(): string
    {
        $year  = date('Y');
        $count = self::whereYear('created_at', $year)->count() + 1;
        return 'SRV-' . $year . '-' . str_pad((string) $count, 4, '0', STR_PAD_LEFT);
    }
}
