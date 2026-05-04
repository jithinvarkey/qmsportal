<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

// ============================================================
// Vendor
// ============================================================
class Vendor extends Model
{
    protected $table    = 'vendors';
    protected $fillable = [
        'name', 'code', 'category_id', 'type', 'registration_no', 'tax_no',
        'contact_name', 'contact_email', 'contact_phone', 'address', 'country',
        'website', 'account_manager_id', 'status', 'risk_level',
        'qualification_status', 'qualification_date', 'qualification_expiry',
        'overall_rating', 'metadata',
    ];

    protected $casts = [
        'metadata'             => 'array',
        'overall_rating'       => 'float',
        'qualification_date'   => 'date',
        'qualification_expiry' => 'date',
    ];

    public function category(): BelongsTo
    {
        return $this->belongsTo(VendorCategory::class);
    }

    public function accountManager(): BelongsTo
    {
        return $this->belongsTo(User::class, 'account_manager_id');
    }

    public function evaluations(): HasMany
    {
        return $this->hasMany(VendorEvaluation::class);
    }

    public function contracts(): HasMany
    {
        return $this->hasMany(VendorContract::class);
    }
}

// ============================================================
// VendorCategory
// ============================================================
class VendorCategory extends Model
{
    public $timestamps  = false;
    protected $table    = 'vendor_categories';
    protected $fillable = ['name', 'description'];
}

// ============================================================
// VendorEvaluation
// ============================================================
class VendorEvaluation extends Model
{
    public $timestamps  = false;
    protected $table    = 'vendor_evaluations';
    protected $fillable = [
        'vendor_id', 'evaluated_by_id', 'evaluation_date', 'period',
        'quality_score', 'delivery_score', 'price_score', 'service_score',
        'compliance_score', 'comments', 'recommendations', 'status',
    ];

    protected $casts = [
        'evaluation_date'  => 'date',
        'quality_score'    => 'float',
        'delivery_score'   => 'float',
        'price_score'      => 'float',
        'service_score'    => 'float',
        'compliance_score' => 'float',
        'overall_score'    => 'float', // GENERATED column — never set manually
    ];

    public function vendor(): BelongsTo
    {
        return $this->belongsTo(Vendor::class);
    }

    public function evaluatedBy(): BelongsTo
    {
        return $this->belongsTo(User::class, 'evaluated_by_id');
    }
}

// ============================================================
// VendorContract
// ============================================================
class VendorContract extends Model
{
    protected $table    = 'vendor_contracts';
    protected $fillable = [
        'vendor_id', 'contract_no', 'title', 'description', 'type',
        'value', 'currency', 'start_date', 'end_date', 'auto_renewal',
        'renewal_notice_days', 'status', 'owner_id', 'file_path',
    ];

    protected $casts = [
        'start_date'   => 'date',
        'end_date'     => 'date',
        'auto_renewal' => 'boolean',
        'value'        => 'float',
    ];

    public function vendor(): BelongsTo
    {
        return $this->belongsTo(Vendor::class);
    }

    public function owner(): BelongsTo
    {
        return $this->belongsTo(User::class, 'owner_id');
    }
}

// ============================================================
// Partnership
// ============================================================
class Partnership extends Model
{
    public $timestamps  = false;
    protected $table    = 'partnerships';
    protected $fillable = [
        'name', 'partner_type', 'vendor_id', 'client_id', 'description',
        'start_date', 'end_date', 'status', 'owner_id', 'value_proposition', 'kpis',
    ];

    protected $casts = [
        'start_date' => 'date',
        'end_date'   => 'date',
        'kpis'       => 'array',
    ];

    public function vendor(): BelongsTo
    {
        return $this->belongsTo(Vendor::class);
    }

    public function client(): BelongsTo
    {
        return $this->belongsTo(Client::class);
    }

    public function owner(): BelongsTo
    {
        return $this->belongsTo(User::class, 'owner_id');
    }
}
