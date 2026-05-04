<?php

declare(strict_types=1);

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

// ============================================================
// VendorContractRequest
// ============================================================
class VendorContractRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array
    {
        return [
            'contract_no'         => 'required|string|max:100|unique:vendor_contracts,contract_no',
            'title'               => 'required|string|max:255',
            'description'         => 'nullable|string',
            'type'                => 'required|in:service,supply,nda,partnership,maintenance,other',
            'value'               => 'nullable|numeric|min:0',
            'currency'            => 'nullable|string|size:3',
            'start_date'          => 'required|date',
            'end_date'            => 'nullable|date|after:start_date',
            'auto_renewal'        => 'boolean',
            'renewal_notice_days' => 'nullable|integer|min:0|max:365',
            'status'              => 'nullable|in:draft,active,expired,terminated,suspended',
            'file_path'           => 'nullable|string|max:255',
        ];
    }

    public function messages(): array
    {
        return [
            'contract_no.unique' => 'This contract number already exists.',
            'end_date.after'     => 'End date must be after the start date.',
            'currency.size'      => 'Currency must be a 3-letter ISO code (e.g. SAR, USD).',
        ];
    }
}

// ============================================================
// VendorEvaluationRequest
// ============================================================
class VendorEvaluationRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array
    {
        return [
            'evaluation_date'  => 'required|date|before_or_equal:today',
            'period'           => 'nullable|string|max:50',
            'quality_score'    => 'required|numeric|min:0|max:10',
            'delivery_score'   => 'required|numeric|min:0|max:10',
            'price_score'      => 'required|numeric|min:0|max:10',
            'service_score'    => 'required|numeric|min:0|max:10',
            'compliance_score' => 'required|numeric|min:0|max:10',
            'comments'         => 'nullable|string|max:2000',
            'recommendations'  => 'nullable|string|max:2000',
            'status'           => 'nullable|in:draft,submitted,approved',
        ];
    }

    public function messages(): array
    {
        return [
            'evaluation_date.before_or_equal' => 'Evaluation date cannot be in the future.',
            'quality_score.max'               => 'Scores cannot exceed 10.',
            'delivery_score.max'              => 'Scores cannot exceed 10.',
            'price_score.max'                 => 'Scores cannot exceed 10.',
            'service_score.max'               => 'Scores cannot exceed 10.',
            'compliance_score.max'            => 'Scores cannot exceed 10.',
        ];
    }
}

// ============================================================
// PartnershipRequest
// ============================================================
class PartnershipRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array
    {
        $isUpdate = $this->isMethod('PUT') || $this->isMethod('PATCH');

        return [
            'name'              => ($isUpdate ? 'sometimes|' : '') . 'required|string|max:255',
            'partner_type'      => ($isUpdate ? 'sometimes|' : '') . 'required|in:strategic,technology,channel,referral,joint_venture,other',
            'vendor_id'         => 'nullable|exists:vendors,id',
            'client_id'         => 'nullable|exists:clients,id',
            'description'       => 'nullable|string',
            'start_date'        => ($isUpdate ? 'sometimes|' : '') . 'required|date',
            'end_date'          => 'nullable|date|after:start_date',
            'status'            => 'nullable|in:active,inactive,negotiating,terminated',
            'value_proposition' => 'nullable|string|max:2000',
            'kpis'              => 'nullable|array',
        ];
    }
}
