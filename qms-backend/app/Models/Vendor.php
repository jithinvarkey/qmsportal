<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * Vendor Model
 *
 * @property int         $id
 * @property string      $name
 * @property string|null $code
 * @property int|null    $category_id
 * @property string      $type
 * @property string|null $registration_no
 * @property string|null $tax_no
 * @property string|null $contact_name
 * @property string|null $contact_email
 * @property string|null $contact_phone
 * @property string|null $address
 * @property string|null $country
 * @property string|null $website
 * @property int|null    $account_manager_id
 * @property string      $status
 * @property string      $risk_level
 * @property string      $qualification_status
 * @property string|null $qualification_date
 * @property string|null $qualification_expiry
 * @property float|null  $overall_rating
 * @property array|null  $metadata
 */
class Vendor extends Model {

    protected $table = 'vendors';
    protected $fillable = [
        'name',
        'code',
        'category_id',
        'type',
        'registration_no',
        'tax_no',
        'contact_name',
        'contact_email',
        'contact_phone',
        'address',
        'country',
        'website',
        'account_manager_id',
        'status',
        'risk_level',
        'qualification_status',
        'qualification_date',
        'qualification_expiry',
        'overall_rating',
        'metadata',
    ];
    protected $casts = [
        'metadata' => 'array',
        'overall_rating' => 'float',
        'qualification_date' => 'date',
        'qualification_expiry' => 'date',
    ];

    // â”€â”€ Relationships â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

    /** @return BelongsTo<VendorCategory, Vendor> */
    public function category(): BelongsTo {
        return $this->belongsTo(VendorCategory::class);
    }

    /** @return BelongsTo<User, Vendor> */
    public function accountManager(): BelongsTo {
        return $this->belongsTo(User::class, 'account_manager_id');
    }

    /** @return HasMany<VendorEvaluation> */
    public function evaluations(): HasMany {
        return $this->hasMany(VendorEvaluation::class);
    }

    /** @return HasMany<VendorContract> */
    public function contracts(): HasMany {
        return $this->hasMany(VendorContract::class);
    }
}
