<?php

declare(strict_types=1);

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

/**
 * VendorEvaluationRequest
 *
 * Validates the payload for recording a vendor performance evaluation.
 * All score fields are 0–10 decimals matching the vendor_evaluations schema.
 */
class VendorEvaluationRequest extends FormRequest
{
    /** @return bool */
    public function authorize(): bool
    {
        return true;
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        return [
            'evaluation_date'   => 'required|date|before_or_equal:today',
            'period'            => 'nullable|string|max:50',
            'quality_score'     => 'required|numeric|min:0|max:10',
            'delivery_score'    => 'required|numeric|min:0|max:10',
            'price_score'       => 'required|numeric|min:0|max:10',
            'service_score'     => 'required|numeric|min:0|max:10',
            'compliance_score'  => 'required|numeric|min:0|max:10',
            'comments'          => 'nullable|string|max:2000',
            'recommendations'   => 'nullable|string|max:2000',
            'status'            => 'nullable|in:draft,submitted,approved',
        ];
    }

    /** @return array<string, string> */
    public function messages(): array
    {
        return [
            'evaluation_date.before_or_equal' => 'Evaluation date cannot be in the future.',
            '*.required'   => 'All five score fields (quality, delivery, price, service, compliance) are required.',
            '*.min'        => 'Scores cannot be negative.',
            '*.max'        => 'Scores cannot exceed 10.',
        ];
    }
}
