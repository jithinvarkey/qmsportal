<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Requests\VendorRequest;
use App\Http\Requests\VendorContractRequest;
use App\Http\Requests\VendorEvaluationRequest;
use App\Http\Requests\PartnershipRequest;
use App\Http\Resources\VendorResource;
use App\Http\Resources\VendorContractResource;
use App\Http\Resources\VendorEvaluationResource;
use App\Http\Resources\PartnershipResource;
use App\Models\Vendor;
use App\Models\VendorContract;
use App\Models\VendorEvaluation;
use App\Models\VendorCategory;
use App\Models\Partnership;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/**
 * VendorController
 *
 * Handles all Vendor & Partnership Management API endpoints for Diamond-QMS.
 * Covers vendor CRUD, qualification lifecycle, performance evaluations,
 * contract management (global + per-vendor), and partnership records.
 *
 * Route map (routes/api.php — vendors prefix):
 *   GET    /vendors                       → index
 *   POST   /vendors                       → store
 *   GET    /vendors/stats                 → stats           ┐
 *   GET    /vendors/categories            → categories      │ Static routes —
 *   GET    /vendors/dropdown              → listDropdown    │ MUST be before
 *   GET    /vendors/expiring-contracts    → expiringContracts│ /{id} wildcard
 *   GET    /vendors/contracts             → contractsIndex  ┘
 *   GET    /vendors/contracts/{id}        → showContract
 *   GET    /vendors/{id}                  → show
 *   PUT    /vendors/{id}                  → update
 *   DELETE /vendors/{id}                  → destroy
 *   POST   /vendors/{id}/qualify          → qualify
 *   POST   /vendors/{id}/suspend          → suspend
 *   POST   /vendors/{id}/reactivate       → reactivate
 *   GET    /vendors/{id}/evaluations      → evaluations
 *   POST   /vendors/{id}/evaluations      → addEvaluation
 *   GET    /vendors/{id}/contracts        → contracts
 *   POST   /vendors/{id}/contracts        → addContract
 *   GET    /partnerships                  → partnerships
 *   POST   /partnerships                  → storePartnership
 *   GET    /partnerships/{id}             → showPartnership
 *   PUT    /partnerships/{id}             → updatePartnership
 */
class VendorController extends BaseController
{
    // =========================================================================
    // VENDOR CRUD
    // =========================================================================

    /**
     * Paginated vendor list with optional filters.
     *
     * @param  Request $request
     * @return JsonResponse
     */
    public function index(Request $request): JsonResponse
    {
        $query = Vendor::with(['category', 'accountManager'])
            ->when($request->status, fn ($q) => $q->where('status', $request->status))
            ->when($request->risk_level, fn ($q) => $q->where('risk_level', $request->risk_level))
            ->when($request->qualification_status, fn ($q) => $q->where('qualification_status', $request->qualification_status))
            ->when($request->category_id, fn ($q) => $q->where('category_id', $request->category_id))
            ->when($request->type, fn ($q) => $q->where('type', $request->type))
            ->when($request->search, fn ($q) => $q->where(
                fn ($q2) => $q2->where('name', 'like', "%{$request->search}%")
                               ->orWhere('code', 'like', "%{$request->search}%")
                               ->orWhere('contact_name', 'like', "%{$request->search}%")
            ))
            ->orderBy('name');

        return $this->paginated($query);
    }

    /**
     * Create a new vendor record.
     *
     * @param  VendorRequest $request
     * @return JsonResponse
     */
    public function store(VendorRequest $request): JsonResponse
    {
        $vendor = Vendor::create($request->validated());
        $this->logActivity('vendors', 'created', $vendor);

        return $this->success(new VendorResource($vendor), 'Vendor created successfully', 201);
    }

    /**
     * Return a single vendor with all relations.
     *
     * @param  int $id
     * @return JsonResponse
     */
    public function show(string $id): JsonResponse
    {
        $vendor = Vendor::with([
            'category',
            'accountManager',
            'evaluations.evaluatedBy',
            'contracts.owner',
        ])->findOrFail($id);

        return $this->success(new VendorResource($vendor));
    }

    /**
     * Update an existing vendor.
     *
     * @param  VendorRequest $request
     * @param  int           $id
     * @return JsonResponse
     */
    public function update(VendorRequest $request, string $id): JsonResponse
    {
        $vendor = Vendor::findOrFail($id);
        $old    = $vendor->toArray();

        $vendor->update($request->validated());
        $this->logActivity('vendors', 'updated', $vendor, $old, $vendor->fresh()->toArray());

        return $this->success(new VendorResource($vendor->fresh()), 'Vendor updated successfully');
    }

    /**
     * Delete a vendor. Blocked when active contracts exist.
     *
     * @param  int $id
     * @return JsonResponse
     */
    public function destroy(string $id): JsonResponse
    {
        $vendor = Vendor::findOrFail($id);

        if ($vendor->contracts()->where('status', 'active')->exists()) {
            return $this->error('Cannot delete a vendor with active contracts. Suspend or terminate contracts first.', 422);
        }

        $this->logActivity('vendors', 'deleted', $vendor);
        $vendor->delete();

        return $this->success(null, 'Vendor deleted successfully');
    }

    // =========================================================================
    // STATIC LOOKUP ENDPOINTS
    // ⚠️  These MUST be registered in routes/api.php BEFORE the /{id} wildcard.
    // =========================================================================

    /**
     * Aggregate statistics for the vendor dashboard.
     *
     * @return JsonResponse
     */
    public function stats(): JsonResponse
    {
        return $this->success([
            'total'                  => Vendor::count(),
            'active'                 => Vendor::where('status', 'active')->count(),
            'approved'               => Vendor::where('status', 'approved')->count(),
            'suspended'              => Vendor::where('status', 'suspended')->count(),
            'blacklisted'            => Vendor::where('status', 'blacklisted')->count(),
            'qualified'              => Vendor::where('qualification_status', 'qualified')->count(),
            'pending_qualification'  => Vendor::where('qualification_status', 'pending')->count(),
            'expired_qualification'  => Vendor::where('qualification_status', 'expired')->count(),
            'expiring_contracts_30d' => VendorContract::where('status', 'active')
                                          ->whereBetween('end_date', [now(), now()->addDays(30)])
                                          ->count(),
            'by_risk_level'          => Vendor::groupBy('risk_level')
                                          ->select('risk_level', DB::raw('count(*) as count'))
                                          ->get(),
            'by_type'                => Vendor::groupBy('type')
                                          ->select('type', DB::raw('count(*) as count'))
                                          ->get(),
            'average_rating'         => round((float) Vendor::whereNotNull('overall_rating')->avg('overall_rating'), 2),
        ]);
    }

    /**
     * All vendor categories for filter/form dropdowns.
     *
     * @return JsonResponse
     */
    public function categories(): JsonResponse
    {
        return $this->success(VendorCategory::orderBy('name')->get());
    }

    /**
     * Minimal id+name list for Angular select/autocomplete fields.
     * Defaults to active and approved vendors only.
     *
     * @param  Request $request
     * @return JsonResponse
     */
    public function listDropdown(Request $request): JsonResponse
    {
        $status = $request->status ?? ['active', 'approved'];

        $vendors = Vendor::query()
            ->when(
                is_array($status),
                fn ($q) => $q->whereIn('status', $status),
                fn ($q) => $q->where('status', $status)
            )
            ->when($request->type,   fn ($q) => $q->where('type', $request->type))
            ->when($request->search, fn ($q) => $q->where('name', 'like', "%{$request->search}%"))
            ->orderBy('name')
            ->get(['id', 'name', 'code', 'type', 'status', 'qualification_status']);

        return $this->success($vendors);
    }

    /**
     * Active contracts expiring within the next N days (default 60).
     *
     * @param  Request $request
     * @return JsonResponse
     */
    public function expiringContracts(Request $request): JsonResponse
    {
        $days = (int) ($request->days ?? 60);

        $contracts = VendorContract::with(['vendor', 'owner'])
            ->where('status', 'active')
            ->whereNotNull('end_date')
            ->whereBetween('end_date', [now(), now()->addDays($days)])
            ->orderBy('end_date')
            ->get();

        return $this->success(VendorContractResource::collection($contracts));
    }

    // =========================================================================
    // GLOBAL CONTRACT ENDPOINTS (no vendor {id} in the route)
    // Route: GET /api/vendors/contracts
    // Route: GET /api/vendors/contracts/{id}
    // =========================================================================

    /**
     * List ALL contracts across all vendors (global contracts view).
     *
     * This method takes ZERO parameters because the route has no {id} segment:
     *   Route::get('/contracts', [VendorController::class, 'contractsIndex']);
     *
     * Supports query filters: vendor_id, status, type, expiring_soon, search.
     *
     * @param  Request $request
     * @return JsonResponse
     */
    public function contractsIndex(Request $request): JsonResponse
    {
        $query = VendorContract::with(['vendor', 'owner'])
            ->when($request->vendor_id, fn ($q) => $q->where('vendor_id', $request->vendor_id))
            ->when($request->status,    fn ($q) => $q->where('status', $request->status))
            ->when($request->type,      fn ($q) => $q->where('type', $request->type))
            ->when($request->expiring_soon, fn ($q) => $q
                ->where('status', 'active')
                ->whereNotNull('end_date')
                ->where('end_date', '<=', now()->addDays(30))
            )
            ->when($request->search, fn ($q) => $q->where(
                fn ($q2) => $q2->where('title', 'like', "%{$request->search}%")
                               ->orWhere('contract_no', 'like', "%{$request->search}%")
            ))
            ->orderBy('end_date')
            ->orderBy('created_at', 'desc');

        return $this->paginated($query);
    }

    /**
     * Return a single contract by its own primary key.
     *
     * Route: GET /api/vendors/contracts/{id}
     *
     * @param  int $id  VendorContract primary key
     * @return JsonResponse
     */
    public function showContract(string $id): JsonResponse
    {
        $contract = VendorContract::with(['vendor', 'owner'])->findOrFail($id);

        return $this->success(new VendorContractResource($contract));
    }

    // =========================================================================
    // VENDOR LIFECYCLE
    // =========================================================================

    /**
     * Mark a vendor as qualified and record the qualification dates.
     *
     * @param  Request $request
     * @param  int     $id
     * @return JsonResponse
     */
    public function qualify(Request $request, string $id): JsonResponse
    {
        $request->validate([
            'qualification_date'   => 'required|date',
            'qualification_expiry' => 'nullable|date|after:qualification_date',
            'notes'                => 'nullable|string|max:1000',
        ]);

        $vendor = Vendor::findOrFail($id);
        $old    = $vendor->toArray();

        $vendor->update([
            'qualification_status' => 'qualified',
            'qualification_date'   => $request->qualification_date,
            'qualification_expiry' => $request->qualification_expiry,
            'status'               => $vendor->status === 'prospect' ? 'approved' : $vendor->status,
        ]);

        $this->logActivity('vendors', 'qualified', $vendor, $old, $vendor->fresh()->toArray());

        return $this->success(new VendorResource($vendor->fresh()), 'Vendor qualified successfully');
    }

    /**
     * Suspend a vendor with a mandatory reason.
     *
     * @param  Request $request
     * @param  int     $id
     * @return JsonResponse
     */
    public function suspend(Request $request, string $id): JsonResponse
    {
        $request->validate(['reason' => 'required|string|max:1000']);

        $vendor = Vendor::findOrFail($id);
        $old    = $vendor->toArray();

        $vendor->update([
            'status'   => 'suspended',
            'metadata' => array_merge((array) $vendor->metadata, [
                'suspension_reason' => $request->reason,
                'suspended_by'      => auth()->id(),
                'suspended_at'      => now()->toISOString(),
            ]),
        ]);

        $this->logActivity('vendors', 'suspended', $vendor, $old, $vendor->fresh()->toArray());

        return $this->success(new VendorResource($vendor->fresh()), 'Vendor suspended');
    }

    /**
     * Reactivate a previously suspended vendor.
     *
     * @param  Request $request
     * @param  int     $id
     * @return JsonResponse
     */
    public function reactivate(Request $request, string $id): JsonResponse
    {
        $request->validate(['notes' => 'nullable|string|max:1000']);

        $vendor = Vendor::findOrFail($id);

        $vendor->update([
            'status'   => 'active',
            'metadata' => array_merge((array) $vendor->metadata, [
                'reactivated_by'     => auth()->id(),
                'reactivated_at'     => now()->toISOString(),
                'reactivation_notes' => $request->notes,
            ]),
        ]);

        $this->logActivity('vendors', 'reactivated', $vendor);

        return $this->success(new VendorResource($vendor->fresh()), 'Vendor reactivated');
    }

    // =========================================================================
    // PER-VENDOR EVALUATIONS
    // =========================================================================

    /**
     * List all performance evaluations for a specific vendor.
     *
     * @param  int $id  Vendor ID
     * @return JsonResponse
     */
    public function evaluations(string $id): JsonResponse
    {
        $vendor      = Vendor::findOrFail($id);
        $evaluations = $vendor->evaluations()
            ->with('evaluatedBy')
            ->orderBy('evaluation_date', 'desc')
            ->get();

        return $this->success(VendorEvaluationResource::collection($evaluations));
    }

    /**
     * Record a new evaluation and refresh the vendor's overall_rating.
     *
     * @param  VendorEvaluationRequest $request
     * @param  int                     $id  Vendor ID
     * @return JsonResponse
     */
    public function addEvaluation(VendorEvaluationRequest $request, string $id): JsonResponse
    {
        $vendor     = Vendor::findOrFail($id);
        $evaluation = $vendor->evaluations()->create(array_merge(
            $request->validated(),
            ['evaluated_by_id' => auth()->id()]
        ));

        // Recalculate overall_rating from the last 5 submitted evaluations
        $avg = $vendor->evaluations()
            ->where('status', 'submitted')
            ->latest('evaluation_date')
            ->limit(5)
            ->avg('overall_score');

        $vendor->update(['overall_rating' => round((float) $avg, 1)]);

        $this->logActivity('vendors', 'evaluation_added', $vendor);

        return $this->success(
            new VendorEvaluationResource($evaluation->load('evaluatedBy')),
            'Evaluation recorded',
            201
        );
    }

    // =========================================================================
    // PER-VENDOR CONTRACTS  (route has /{id} prefix)
    // =========================================================================

    /**
     * List contracts belonging to a specific vendor.
     *
     * Route: GET /api/vendors/{id}/contracts
     *
     * @param  int $id  Vendor ID
     * @return JsonResponse
     */
    public function contracts(string $id): JsonResponse
    {
        $vendor    = Vendor::findOrFail($id);
        $contracts = $vendor->contracts()
            ->with('owner')
            ->orderBy('start_date', 'desc')
            ->get();

        return $this->success(VendorContractResource::collection($contracts));
    }

    /**
     * Add a new contract to a specific vendor.
     *
     * Route: POST /api/vendors/{id}/contracts
     *
     * @param  VendorContractRequest $request
     * @param  int                   $id  Vendor ID
     * @return JsonResponse
     */
    public function addContract(VendorContractRequest $request, string $id): JsonResponse
    {
        $vendor   = Vendor::findOrFail($id);
        $contract = $vendor->contracts()->create(array_merge(
            $request->validated(),
            ['owner_id' => auth()->id()]
        ));

        $this->logActivity('vendors', 'contract_added', $vendor);

        return $this->success(
            new VendorContractResource($contract->load('owner')),
            'Contract added',
            201
        );
    }

    // =========================================================================
    // PARTNERSHIPS
    // =========================================================================

    /**
     * Paginated list of all partnerships.
     *
     * @param  Request $request
     * @return JsonResponse
     */
    public function partnerships(Request $request): JsonResponse
    {
        $query = Partnership::with(['vendor', 'client', 'owner'])
            ->when($request->status,       fn ($q) => $q->where('status', $request->status))
            ->when($request->partner_type, fn ($q) => $q->where('partner_type', $request->partner_type))
            ->when($request->search,       fn ($q) => $q->where('name', 'like', "%{$request->search}%"))
            ->orderBy('name');

        return $this->paginated($query);
    }

    /**
     * Create a new partnership record.
     *
     * @param  PartnershipRequest $request
     * @return JsonResponse
     */
    public function storePartnership(PartnershipRequest $request): JsonResponse
    {
        $partnership = Partnership::create(array_merge(
            $request->validated(),
            ['owner_id' => auth()->id()]
        ));

        $this->logActivity('partnerships', 'created', $partnership);

        return $this->success(
            new PartnershipResource($partnership->load(['vendor', 'client', 'owner'])),
            'Partnership created',
            201
        );
    }

    /**
     * Return a single partnership by ID.
     *
     * @param  int $id
     * @return JsonResponse
     */
    public function showPartnership(string $id): JsonResponse
    {
        $partnership = Partnership::with(['vendor', 'client', 'owner'])->findOrFail($id);

        return $this->success(new PartnershipResource($partnership));
    }

    /**
     * Update an existing partnership.
     *
     * @param  PartnershipRequest $request
     * @param  int                $id
     * @return JsonResponse
     */
    public function updatePartnership(PartnershipRequest $request, string $id): JsonResponse
    {
        $partnership = Partnership::findOrFail($id);
        $old         = $partnership->toArray();

        $partnership->update($request->validated());
        $this->logActivity('partnerships', 'updated', $partnership, $old, $partnership->fresh()->toArray());

        return $this->success(
            new PartnershipResource($partnership->fresh()->load(['vendor', 'client', 'owner'])),
            'Partnership updated'
        );
    }
}
