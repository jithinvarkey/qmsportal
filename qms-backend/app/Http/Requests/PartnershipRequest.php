<?php

declare(strict_types=1);

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

/**
 * PartnershipRequest
 *
 * Validates partnership create and update payloads.
 */
class PartnershipRequest extends FormRequest
{
    /** @return bool */
    public function authorize(): bool
    {
        return true;
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        $isUpdate = $this->isMethod('PUT') || $this->isMethod('PATCH');

        return [
            'name'               => ($isUpdate ? 'sometimes|' : '') . 'required|string|max:255',
            'partner_type'       => ($isUpdate ? 'sometimes|' : '') . 'required|in:strategic,technology,channel,referral,joint_venture,other',
            'vendor_id'          => 'nullable|exists:vendors,id',
            'client_id'          => 'nullable|exists:clients,id',
            'description'        => 'nullable|string',
            'start_date'         => ($isUpdate ? 'sometimes|' : '') . 'required|date',
            'end_date'           => 'nullable|date|after:start_date',
            'status'             => 'nullable|in:active,inactive,negotiating,terminated',
            'value_proposition'  => 'nullable|string|max:2000',
            'kpis'               => 'nullable|array',
        ];
    }

    /** @return array<string, string> */
    public function messages(): array
    {
        return [
            'name.required'         => 'Partnership name is required.',
            'partner_type.required' => 'Partner type is required.',
            'start_date.required'   => 'Partnership start date is required.',
            'end_date.after'        => 'End date must be after the start date.',
        ];
    }
}
