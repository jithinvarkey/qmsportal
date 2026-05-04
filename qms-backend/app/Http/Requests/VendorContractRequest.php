<?php

declare(strict_types=1);

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

/**
 * VendorContractRequest
 *
 * Validates new contract records attached to a vendor.
 */
class VendorContractRequest extends FormRequest
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
            'contract_no'          => 'required|string|max:100|unique:vendor_contracts,contract_no',
            'title'                => 'required|string|max:255',
            'description'          => 'nullable|string',
            'type'                 => 'required|in:service,supply,nda,partnership,maintenance,other',
            'value'                => 'nullable|numeric|min:0',
            'currency'             => 'nullable|string|size:3',
            'start_date'           => 'required|date',
            'end_date'             => 'nullable|date|after:start_date',
            'auto_renewal'         => 'boolean',
            'renewal_notice_days'  => 'nullable|integer|min:0|max:365',
            'status'               => 'nullable|in:draft,active,expired,terminated,suspended',
            'file_path'            => 'nullable|string|max:255',
        ];
    }

    /** @return array<string, string> */
    public function messages(): array
    {
        return [
            'contract_no.unique'    => 'This contract number already exists.',
            'end_date.after'        => 'End date must be after the start date.',
            'currency.size'         => 'Currency must be a 3-letter ISO code (e.g. SAR, USD).',
        ];
    }
}
