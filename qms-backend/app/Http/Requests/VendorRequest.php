<?php

declare(strict_types=1);

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

/**
 * VendorRequest — validates vendor create and update payloads.
 */
class VendorRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array
    {
        $isUpdate = $this->isMethod('PUT') || $this->isMethod('PATCH');
        $vendorId = $this->route('id') ?? 'NULL';

        return [
            'name'               => ($isUpdate ? 'sometimes|' : '') . 'required|string|max:255',
            'code'               => "nullable|string|max:50|unique:vendors,code,{$vendorId}",
            'category_id'        => 'nullable|exists:vendor_categories,id',
            'type'               => ($isUpdate ? 'sometimes|' : '') . 'required|in:supplier,service_provider,contractor,partner,consultant',
            'registration_no'    => 'nullable|string|max:100',
            'tax_no'             => 'nullable|string|max:100',
            'contact_name'       => 'nullable|string|max:200',
            'contact_email'      => 'nullable|email|max:200',
            'contact_phone'      => 'nullable|string|max:50',
            'address'            => 'nullable|string|max:1000',
            'country'            => 'nullable|string|max:100',
            'website'            => 'nullable|url|max:255',
            'account_manager_id' => 'nullable|exists:users,id',
            'risk_level'         => 'nullable|in:low,medium,high,critical',
            'status'             => 'nullable|in:prospect,active,approved,suspended,blacklisted,inactive',
        ];
    }

    public function messages(): array
    {
        return [
            'name.required'          => 'Vendor name is required.',
            'type.required'          => 'Vendor type is required.',
            'code.unique'            => 'This vendor code is already in use.',
            'contact_email.email'    => 'Please provide a valid contact email address.',
            'website.url'            => 'Please provide a valid website URL.',
        ];
    }
}
