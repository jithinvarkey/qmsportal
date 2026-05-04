<?php

declare(strict_types=1);

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

/**
 * Transforms a Partnership model for API output.
 */
class PartnershipResource extends JsonResource
{
    /** @return array<string, mixed> */
    public function toArray($request): array
    {
        return [
            'id'                => $this->id,
            'name'              => $this->name,
            'partner_type'      => $this->partner_type,
            'vendor'            => $this->whenLoaded('vendor', fn () => $this->vendor
                ? ['id' => $this->vendor->id, 'name' => $this->vendor->name]
                : null),
            'client'            => $this->whenLoaded('client', fn () => $this->client
                ? ['id' => $this->client->id, 'name' => $this->client->name]
                : null),
            'description'       => $this->description,
            'start_date'        => $this->start_date,
            'end_date'          => $this->end_date,
            'status'            => $this->status,
            'owner'             => $this->whenLoaded('owner', fn () => [
                'id'   => $this->owner->id,
                'name' => $this->owner->name,
            ]),
            'value_proposition' => $this->value_proposition,
            'kpis'              => $this->kpis,
            'created_at'        => $this->created_at,
        ];
    }
}
