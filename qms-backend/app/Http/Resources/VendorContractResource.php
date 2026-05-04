<?php

declare(strict_types=1);

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

/**
 * Transforms a VendorContract model for API output.
 */
class VendorContractResource extends JsonResource
{
    /** @return array<string, mixed> */
    public function toArray($request): array
    {
        return [
            'id'                   => $this->id,
            'vendor_id'            => $this->vendor_id,
            'vendor'               => $this->whenLoaded('vendor', fn () => [
                'id'   => $this->vendor->id,
                'name' => $this->vendor->name,
            ]),
            'contract_no'          => $this->contract_no,
            'title'                => $this->title,
            'description'          => $this->description,
            'type'                 => $this->type,
            'value'                => $this->value,
            'currency'             => $this->currency,
            'start_date'           => $this->start_date,
            'end_date'             => $this->end_date,
            'auto_renewal'         => (bool) $this->auto_renewal,
            'renewal_notice_days'  => $this->renewal_notice_days,
            'status'               => $this->status,
            'owner'                => $this->whenLoaded('owner', fn () => [
                'id'   => $this->owner->id,
                'name' => $this->owner->name,
            ]),
            'file_path'            => $this->file_path,
            'days_until_expiry'    => $this->end_date
                ? (int) now()->diffInDays($this->end_date, false)
                : null,
            'created_at'           => $this->created_at,
            'updated_at'           => $this->updated_at,
        ];
    }
}
