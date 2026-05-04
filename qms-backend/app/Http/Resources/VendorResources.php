<?php

declare(strict_types=1);

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

// ============================================================
// VendorResource
// ============================================================
class VendorResource extends JsonResource
{
    public function toArray($request): array
    {
        return [
            'id'                   => $this->id,
            'name'                 => $this->name,
            'code'                 => $this->code,
            'category'             => $this->whenLoaded('category', fn () => [
                'id' => $this->category->id, 'name' => $this->category->name,
            ]),
            'type'                 => $this->type,
            'registration_no'      => $this->registration_no,
            'tax_no'               => $this->tax_no,
            'contact_name'         => $this->contact_name,
            'contact_email'        => $this->contact_email,
            'contact_phone'        => $this->contact_phone,
            'address'              => $this->address,
            'country'              => $this->country,
            'website'              => $this->website,
            'account_manager'      => $this->whenLoaded('accountManager', fn () => [
                'id' => $this->accountManager->id, 'name' => $this->accountManager->name,
            ]),
            'status'               => $this->status,
            'risk_level'           => $this->risk_level,
            'qualification_status' => $this->qualification_status,
            'qualification_date'   => $this->qualification_date,
            'qualification_expiry' => $this->qualification_expiry,
            'overall_rating'       => $this->overall_rating,
            'evaluations'          => VendorEvaluationResource::collection($this->whenLoaded('evaluations')),
            'contracts'            => VendorContractResource::collection($this->whenLoaded('contracts')),
            'created_at'           => $this->created_at,
            'updated_at'           => $this->updated_at,
        ];
    }
}

// ============================================================
// VendorContractResource
// ============================================================
class VendorContractResource extends JsonResource
{
    public function toArray($request): array
    {
        return [
            'id'                  => $this->id,
            'vendor_id'           => $this->vendor_id,
            'vendor'              => $this->whenLoaded('vendor', fn () => [
                'id' => $this->vendor->id, 'name' => $this->vendor->name,
            ]),
            'contract_no'         => $this->contract_no,
            'title'               => $this->title,
            'description'         => $this->description,
            'type'                => $this->type,
            'value'               => $this->value,
            'currency'            => $this->currency,
            'start_date'          => $this->start_date,
            'end_date'            => $this->end_date,
            'auto_renewal'        => (bool) $this->auto_renewal,
            'renewal_notice_days' => $this->renewal_notice_days,
            'status'              => $this->status,
            'owner'               => $this->whenLoaded('owner', fn () => [
                'id' => $this->owner->id, 'name' => $this->owner->name,
            ]),
            'file_path'           => $this->file_path,
            'days_until_expiry'   => $this->end_date
                ? (int) now()->diffInDays($this->end_date, false)
                : null,
            'created_at'          => $this->created_at,
            'updated_at'          => $this->updated_at,
        ];
    }
}

// ============================================================
// VendorEvaluationResource
// ============================================================
class VendorEvaluationResource extends JsonResource
{
    public function toArray($request): array
    {
        return [
            'id'               => $this->id,
            'vendor_id'        => $this->vendor_id,
            'evaluated_by'     => $this->whenLoaded('evaluatedBy', fn () => [
                'id' => $this->evaluatedBy->id, 'name' => $this->evaluatedBy->name,
            ]),
            'evaluation_date'  => $this->evaluation_date,
            'period'           => $this->period,
            'quality_score'    => $this->quality_score,
            'delivery_score'   => $this->delivery_score,
            'price_score'      => $this->price_score,
            'service_score'    => $this->service_score,
            'compliance_score' => $this->compliance_score,
            'overall_score'    => $this->overall_score,
            'comments'         => $this->comments,
            'recommendations'  => $this->recommendations,
            'status'           => $this->status,
            'created_at'       => $this->created_at,
        ];
    }
}

// ============================================================
// PartnershipResource
// ============================================================
class PartnershipResource extends JsonResource
{
    public function toArray($request): array
    {
        return [
            'id'                => $this->id,
            'name'              => $this->name,
            'partner_type'      => $this->partner_type,
            'vendor'            => $this->whenLoaded('vendor', fn () => $this->vendor
                ? ['id' => $this->vendor->id, 'name' => $this->vendor->name] : null),
            'client'            => $this->whenLoaded('client', fn () => $this->client
                ? ['id' => $this->client->id, 'name' => $this->client->name] : null),
            'description'       => $this->description,
            'start_date'        => $this->start_date,
            'end_date'          => $this->end_date,
            'status'            => $this->status,
            'owner'             => $this->whenLoaded('owner', fn () => [
                'id' => $this->owner->id, 'name' => $this->owner->name,
            ]),
            'value_proposition' => $this->value_proposition,
            'kpis'              => $this->kpis,
            'created_at'        => $this->created_at,
        ];
    }
}
