import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { ApiService } from './api.service';

/**
 * VendorService
 *
 * Handles all HTTP calls for the Vendor & Partnership Management module.
 *
 * URL corrections applied (vs original):
 *   users()              /vendors/users          → /users
 *   listContracts()      /contracts              → /vendors/contracts
 *   getContract()        /contracts/:id          → /vendors/contracts/:id
 *   createContract()     /contracts              → /vendors/contracts
 *   updateContract()     /contracts/:id          → /vendors/contracts/:id
 *   activateContract()   /contracts/:id/activate → /vendors/contracts/:id/activate
 *   terminateContract()  /contracts/:id/terminate→ /vendors/contracts/:id/terminate
 *   contractStats()      /contracts/stats        → /vendors/contracts/stats
 */
@Injectable({ providedIn: 'root' })
export class VendorService {
  constructor(private api: ApiService) {}

  // ── Vendors ────────────────────────────────────────────────────────────────

  /** Paginated vendor list with optional filters */
  list(filters: any = {}): Observable<any> {
    return this.api.get('/vendors', filters);
  }

  /** Minimal id+name list for dropdowns */
  vendorsList(): Observable<any> {
    return this.api.get('/vendors/list');
  }

  /** Single vendor by ID */
  get(id: number): Observable<any> {
    return this.api.get(`/vendors/${id}`);
  }

  /** Create a new vendor */
  create(data: any): Observable<any> {
    return this.api.post('/vendors', data);
  }

  /** Update a vendor */
  update(id: number, data: any): Observable<any> {
    return this.api.put(`/vendors/${id}`, data);
  }

  /** Delete a vendor */
  delete(id: number): Observable<any> {
    return this.api.delete(`/vendors/${id}`);
  }

  /** Vendor aggregate stats */
  stats(): Observable<any> {
    return this.api.get('/vendors/stats');
  }

  /** All vendor categories for dropdowns */
  categories(): Observable<any> {
    return this.api.get('/vendors/categories');
  }

  /**
   * Fetch users list for account-manager / assignee dropdowns.
   * FIX: was incorrectly calling /vendors/users — users live at /users.
   */
  users(): Observable<any> {
    return this.api.get('/users');
  }

  /** Contracts expiring within the next 60 days */
  expiringContracts(): Observable<any> {
    return this.api.get('/vendors/expiring-contracts');
  }

  // ── Vendor Lifecycle ───────────────────────────────────────────────────────

  /** Mark vendor as qualified */
  qualify(id: number, data: any = {}): Observable<any> {
    return this.api.post(`/vendors/${id}/qualify`, data);
  }

  /** Suspend a vendor */
  suspend(id: number, data: any = {}): Observable<any> {
    return this.api.post(`/vendors/${id}/suspend`, data);
  }

  /** Reactivate a suspended vendor */
  reactivate(id: number, data: any = {}): Observable<any> {
    return this.api.post(`/vendors/${id}/reactivate`, data);
  }

  // ── Per-vendor Evaluations ─────────────────────────────────────────────────

  /** List evaluations for a specific vendor */
  getEvaluations(id: number): Observable<any> {
    return this.api.get(`/vendors/${id}/evaluations`);
  }

  /** Add a new performance evaluation to a vendor */
  addEvaluation(id: number, data: any): Observable<any> {
    return this.api.post(`/vendors/${id}/evaluations`, data);
  }

  // ── Per-vendor Contracts ───────────────────────────────────────────────────

  /** List contracts for a specific vendor */
  getContracts(id: number): Observable<any> {
    return this.api.get(`/vendors/${id}/contracts`);
  }

  /** Add a new contract to a specific vendor */
  addContract(id: number, data: any): Observable<any> {
    return this.api.post(`/vendors/${id}/contracts`, data);
  }

  // ── Global Contracts (all vendors) ────────────────────────────────────────

  /**
   * List ALL contracts across all vendors.
   * FIX: was calling /contracts — correct path is /vendors/contracts.
   */
  listContracts(filters: any = {}): Observable<any> {
    return this.api.get('/vendors/contracts', filters);
  }

  /**
   * Get a single contract by its ID.
   * FIX: was calling /contracts/:id — correct path is /vendors/contracts/:id.
   */
  getContract(id: number): Observable<any> {
    return this.api.get(`/vendors/contracts/${id}`);
  }

  /**
   * Create a new contract (global endpoint).
   * FIX: was calling /contracts — correct path is /vendors/contracts.
   */
  createContract(data: any): Observable<any> {
    return this.api.post('/vendors/contracts', data);
  }

  /**
   * Update a contract.
   * FIX: was calling /contracts/:id — correct path is /vendors/contracts/:id.
   */
  updateContract(id: number, data: any): Observable<any> {
    return this.api.put(`/vendors/contracts/${id}`, data);
  }

  /**
   * Activate a contract (set status → active).
   * FIX: was calling /contracts/:id/activate — correct path is /vendors/contracts/:id/activate.
   */
  activateContract(id: number): Observable<any> {
    return this.api.post(`/vendors/contracts/${id}/activate`, {});
  }

  /**
   * Terminate a contract (set status → terminated).
   * FIX: was calling /contracts/:id/terminate — correct path is /vendors/contracts/:id/terminate.
   */
  terminateContract(id: number): Observable<any> {
    return this.api.post(`/vendors/contracts/${id}/terminate`, {});
  }

  /**
   * Contract statistics.
   * FIX: was calling /contracts/stats — correct path is /vendors/contracts/stats.
   */
  contractStats(): Observable<any> {
    return this.api.get('/vendors/contracts/stats');
  }

  // ── Partnerships ───────────────────────────────────────────────────────────

  /** Paginated list of all partnerships */
  listPartnerships(filters: any = {}): Observable<any> {
    return this.api.get('/partnerships', filters);
  }

  /** Create a new partnership */
  createPartnership(data: any): Observable<any> {
    return this.api.post('/partnerships', data);
  }

  /** Get a single partnership */
  getPartnership(id: number): Observable<any> {
    return this.api.get(`/partnerships/${id}`);
  }

  /** Update a partnership */
  updatePartnership(id: number, data: any): Observable<any> {
    return this.api.put(`/partnerships/${id}`, data);
  }
/**
   * Reactivate a contract a contract (set status → terminated).
   * FIX: was calling /contracts/:id/terminate — correct path is /vendors/contracts/:id/terminate.
   */
  reactivateContract(id: number, data: any): Observable<any> {
    return this.api.post(`/vendors/contracts/${id}/renew`, data);
  }

}
