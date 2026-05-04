<?php

declare(strict_types=1);

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

// ============================================================
// VendorResource
// ============================================================

/**
 * Transforms a Vendor Eloquent model into a JSON-API-compatible array.
 */
class VendorResource extends JsonResource
{
    /** @return array<string, mixed> */
    public function toArray($request): array
    {
        return [
            'id'                    => $this->id,
            'name'                  => $this->name,
            'code'                  => $this->code,
            'category'              => $this->whenLoaded('category', fn () => [
                'id'   => $this->category->id,
                'name' => $this->category->name,
            ]),
            'type'                  => $this->type,
            'registration_no'       => $this->registration_no,
            'tax_no'                => $this->tax_no,
            'contact_name'          => $this->contact_name,
            'contact_email'         => $this->contact_email,
            'contact_phone'         => $this->contact_phone,
            'address'               => $this->address,
            'country'               => $this->country,
            'website'               => $this->website,
            'account_manager'       => $this->whenLoaded('accountManager', fn () => [
                'id'   => $this->accountManager->id,
                'name' => $this->accountManager->name,
            ]),
            'status'                => $this->status,
            'risk_level'            => $this->risk_level,
            'qualification_status'  => $this->qualification_status,
            'qualification_date'    => $this->qualification_date,
            'qualification_expiry'  => $this->qualification_expiry,
            'overall_rating'        => $this->overall_rating,
            'evaluations'           => VendorEvaluationResource::collection($this->whenLoaded('evaluations')),
            'contracts'             => VendorContractResource::collection($this->whenLoaded('contracts')),
            'created_at'            => $this->created_at,
            'updated_at'            => $this->updated_at,
        ];
    }
}
