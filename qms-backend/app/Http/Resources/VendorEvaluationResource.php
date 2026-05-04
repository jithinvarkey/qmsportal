<?php

declare(strict_types=1);

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

// ============================================================
// VendorEvaluationResource
// ============================================================

/**
 * Transforms a VendorEvaluation model for API output.
 */
class VendorEvaluationResource extends JsonResource
{
    /** @return array<string, mixed> */
    public function toArray($request): array
    {
        return [
            'id'               => $this->id,
            'vendor_id'        => $this->vendor_id,
            'evaluated_by'     => $this->whenLoaded('evaluatedBy', fn () => [
                'id'   => $this->evaluatedBy->id,
                'name' => $this->evaluatedBy->name,
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
