<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Str;




// ============================================================
// SurveyToken
// ============================================================
/**
 * SurveyToken
 *
 * One row per client per survey.
 * The token is used in the public survey URL:
 *   /survey/{token}   (no authentication required)
 */
class SurveyToken extends Model
{
    protected $table    = 'survey_tokens';
    protected $fillable = [
        'survey_id', 'client_id', 'token','user_id',
        'recipient_email', 'recipient_name',
        'is_completed', 'sent_at', 'completed_at', 'expires_at',
    ];

    protected $casts = [
        'is_completed' => 'boolean',
        'sent_at'      => 'datetime',
        'completed_at' => 'datetime',
        'expires_at'   => 'datetime',
    ];

    public function survey(): BelongsTo
    {
        return $this->belongsTo(Survey::class);
    }

    public function client(): BelongsTo
    {
        return $this->belongsTo(Client::class);
    }
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /** Generate a cryptographically secure token */
    public static function generateToken(): string
    {
        return Str::random(48);
    }

    /** Check if this token is still usable */
    public function isValid(): bool
    {
        if ($this->is_completed) return false;
        if ($this->expires_at && $this->expires_at->isPast()) return false;
        return true;
    }
}