// src/app/features/surveys/services/survey.service.ts
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { ApiService } from './api.service';

/**
 * SurveyService
 *
 * Handles all HTTP calls for the Survey / CSAT Management module.
 * Supports both internal (department) and customer (client token) surveys.
 */
@Injectable({ providedIn: 'root' })
export class SurveyService {
  constructor(private api: ApiService) {}

  // ── Survey CRUD ────────────────────────────────────────────────────────────

  list(filters: any = {}): Observable<any> {
    return this.api.get('/surveys', filters);
  }

  get(id: number): Observable<any> {
    return this.api.get(`/surveys/${id}`);
  }

  create(data: any): Observable<any> {
    return this.api.post('/surveys', data);
  }

  update(id: number, data: any): Observable<any> {
    return this.api.put(`/surveys/${id}`, data);
  }

  delete(id: number): Observable<any> {
    return this.api.delete(`/surveys/${id}`);
  }

  stats(): Observable<any> {
    return this.api.get('/surveys/stats');
  }

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  activate(id: number): Observable<any> {
    return this.api.post(`/surveys/${id}/activate`, {});
  }

  pause(id: number): Observable<any> {
    return this.api.post(`/surveys/${id}/pause`, {});
  }

  close(id: number): Observable<any> {
    return this.api.post(`/surveys/${id}/close`, {});
  }

  // ── Questions ──────────────────────────────────────────────────────────────

  questions(id: number): Observable<any> {
    return this.api.get(`/surveys/${id}/questions`);
  }

  addQuestion(id: number, data: any): Observable<any> {
    return this.api.post(`/surveys/${id}/questions`, data);
  }

  updateQuestion(id: number, qid: number, data: any): Observable<any> {
    return this.api.put(`/surveys/${id}/questions/${qid}`, data);
  }

  deleteQuestion(id: number, qid: number): Observable<any> {
    return this.api.delete(`/surveys/${id}/questions/${qid}`);
  }

  // ── Responses & Analytics ─────────────────────────────────────────────────

  responses(id: number): Observable<any> {
    return this.api.get(`/surveys/${id}/responses`);
  }

  /** Submit response for internal survey (authenticated user) */
  submitResponse(id: number, data: any): Observable<any> {
    return this.api.post(`/surveys/${id}/responses`, data);
  }

  analytics(id: number): Observable<any> {
    return this.api.get(`/surveys/${id}/analytics`);
  }

  // ── Customer Survey ────────────────────────────────────────────────────────

  /**
   * Send survey to customers — generates tokens and optionally emails links.
   *
   * @param id        Survey ID
   * @param clientIds Specific client IDs (empty = all active clients)
   * @param sendEmail Whether to email the survey link
   */
  sendToCustomers(id: number, clientIds: number[] = [], sendEmail = true): Observable<any> {
    return this.api.post(`/surveys/${id}/send-to-customers`, {
      client_ids: clientIds,
      send_email: sendEmail,
    });
  }

  /** List all tokens (shows which clients received survey + completion status) */
  tokens(id: number): Observable<any> {
    return this.api.get(`/surveys/${id}/tokens`);
  }

  // ── File upload ────────────────────────────────────────────────────────────

  /**
   * Upload a branding image (logo or background).
   * @param formData FormData with 'file' and 'type' (logo|background)
   */
  uploadMedia(formData: FormData): Observable<any> {
    return this.api.post('/surveys/upload-media', formData);
  }

  // ── Dropdown helpers ───────────────────────────────────────────────────────

  users(): Observable<any> {
    return this.api.get('/surveys/users');
  }

  clients(): Observable<any> {
    return this.api.get('/surveys/clients');
  }

  departments(): Observable<any> {
    return this.api.get('/surveys/departments');
  }

  // ── Public endpoints (no auth — used by customer-facing survey page) ───────

  /**
   * Load survey form for a customer using their unique token.
   * Call from the public survey page component (no auth required).
   */
  publicGetSurvey(token: string): Observable<any> {
    return this.api.get(`/survey-public/${token}`);
  }

  /**
   * Submit a customer survey response.
   * Call from the public survey page component (no auth required).
   */
  publicSubmit(token: string, data: {
    answers: { question_id: number; answer: any; score?: number }[];
    respondent_name?: string;
    respondent_email?: string;
    comments?: string;
  }): Observable<any> {
    return this.api.post(`/survey-public/${token}/submit`, data);
  }
}
