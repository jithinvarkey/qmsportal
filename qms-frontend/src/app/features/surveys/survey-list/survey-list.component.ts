// src/app/features/surveys/components/survey-list/survey-list.component.ts
import {
  ChangeDetectionStrategy,
  Component,
  OnInit,
  computed,
  inject,
  signal,
} from '@angular/core';
import { NgClass, NgFor, NgIf, DatePipe } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { SurveyService } from '@app/core/services/survey.service';

interface Client       { id: number; name: string; contact_email: string; contact_name: string; }
interface Department   { id: number; name: string; }
interface SurveyQuestion { id?: number; question: string; type: string; is_required: boolean; scale_max?: number; sort_order?: number; options?: string[]; }
interface Survey {
  id: number; reference_no: string; title: string; description: string;
  audience_type: 'internal' | 'customer'; type: string; status: string;
  department?: { id: number; name: string };
  client?: { id: number; name: string };
  client_ids?: number[] | null;          // JSON array of selected client IDs
  total_sent: number; total_responses: number; average_score: number | null;
  start_date: string | null; end_date: string | null; created_at: string;
  logo_url?: string; background_color?: string; background_image?: string;
  primary_color?: string; header_text_color?: string; card_color?: string; font_family?: string; language?: string;
}

@Component({
  selector: 'app-survey-list',
  standalone: true,
  imports: [NgIf, NgFor, NgClass, FormsModule, DatePipe],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
<div class="page">

  <!-- ── Header ── -->
  <div class="page-header">
    <div>
      <h1 class="page-title">Survey Management</h1>
      <p class="page-sub">Customer &amp; Internal CSAT / NPS Surveys</p>
    </div>
    <button class="btn btn-primary" (click)="openNew()">+ New Survey</button>
  </div>

  <!-- ── Stats ── -->
  <div class="stats-row" *ngIf="stats()">
    <div class="stat-card" *ngFor="let s of statCards()">
      <div class="stat-val">{{ s.val }}</div>
      <div class="stat-lbl">{{ s.lbl }}</div>
    </div>
  </div>

  <!-- ── Filters ── -->
  <div class="filters-row">
    <input class="f-input" type="text" placeholder="Search surveys…" [(ngModel)]="searchText" (ngModelChange)="resetPage()">
    <select class="f-sel" [(ngModel)]="filterStatus" (ngModelChange)="resetPage()">
      <option value="">All Status</option>
      <option value="draft">Draft</option>
      <option value="active">Active</option>
      <option value="paused">Paused</option>
      <option value="closed">Closed</option>
    </select>
    <select class="f-sel" [(ngModel)]="filterAudience" (ngModelChange)="resetPage()">
      <option value="">All Audiences</option>
      <option value="customer">Customer</option>
      <option value="internal">Internal</option>
    </select>
  </div>

  <!-- ── Table ── -->
  <div class="table-card">
    <div class="loading-row" *ngIf="loading()"><div class="spinner"></div> Loading…</div>
    <div class="empty-state" *ngIf="!loading() && allFiltered().length === 0">No surveys found.</div>
    <table class="tbl" *ngIf="!loading() && filtered().length > 0">
      <thead>
        <tr>
          <th>Ref</th><th>Title</th><th>Audience</th><th>Type</th>
          <th>Status</th><th>Sent</th><th>Responses</th><th>Rate</th><th>Score</th><th>Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr *ngFor="let s of filtered()">
          <td><code class="ref-code">{{ s.reference_no }}</code></td>
          <td>
            <div class="tbl-title">{{ s.title }}</div>
            <div class="tbl-meta" *ngIf="s.department">🏢 {{ s.department.name }}</div>
            <div class="tbl-meta" *ngIf="s.client">👤 {{ s.client.name }}</div>
          </td>
          <td><span class="badge" [ngClass]="s.audience_type === 'customer' ? 'bdg-blue' : 'bdg-purple'">{{ s.audience_type }}</span></td>
          <td class="tbl-type">{{ s.type }}</td>
          <td><span class="badge" [ngClass]="statusClass(s.status)">{{ s.status }}</span></td>
          <td class="num">{{ s.total_sent }}</td>
          <td class="num">{{ s.total_responses }}</td>
          <td class="num">{{ responseRate(s) }}</td>
          <td class="num">{{ s.average_score ?? '—' }}</td>
          <td class="act-cell">
            <button class="ic-btn" title="View Details" (click)="openView(s)">👁️</button>
            <button class="ic-btn" title="Edit" (click)="openEdit(s)">✏️</button>
            @if (s.status === 'draft')  { <button class="ic-btn" title="Activate" (click)="activate(s)">▶️</button> }
            @if (s.status === 'active') { <button class="ic-btn" title="Pause" (click)="pause(s)">⏸️</button> }
            @if (s.status === 'active') { <button class="ic-btn" title="Close" (click)="closeSurvey(s)">⏹️</button> }
            @if (s.status === 'paused') { <button class="ic-btn" title="Resume" (click)="activate(s)">▶️</button> }
            @if (s.audience_type === 'customer' && s.status === 'active') {
              <button class="ic-btn send-ic" title="Send to Customers" (click)="openSendModal(s)">📧</button>
            }
            <button class="ic-btn del-ic" title="Delete" (click)="deleteSurvey(s)">🗑️</button>
          </td>
        </tr>
      </tbody>
    </table>

  <!-- Pagination bar -->
  <div class="pagination-bar" *ngIf="!loading() && allFiltered().length > 0">
    <div class="pg-info">
      Showing {{ (currentPage - 1) * pageSize + 1 }}–{{ currentPage * pageSize > allFiltered().length ? allFiltered().length : currentPage * pageSize }}
      of {{ allFiltered().length }} surveys
    </div>
    <div class="pg-controls">
      <button class="pg-btn" (click)="goToPage(currentPage - 1)" [disabled]="currentPage === 1">‹</button>
      <ng-container *ngFor="let p of pageNumbers()">
        <span *ngIf="p === '...'" class="pg-dots">…</span>
        <button *ngIf="p !== '...'" class="pg-btn" [class.pg-active]="p === currentPage" (click)="goToPage(+p)">{{ p }}</button>
      </ng-container>
      <button class="pg-btn" (click)="goToPage(currentPage + 1)" [disabled]="currentPage === totalPages()">›</button>
    </div>
    <div class="pg-size">
      <select [(ngModel)]="pageSize" (ngModelChange)="onPageSizeChange()">
        <option *ngFor="let s of pageSizes" [value]="s">{{ s }} / page</option>
      </select>
    </div>
  </div>
</div>
</div>


<!-- ══════════════════════════════════════════════════════════════════════════
     SURVEY VIEW PANEL (slide-over)
══════════════════════════════════════════════════════════════════════════ -->
<div class="view-overlay" *ngIf="showViewPanel" (click)="closeView()"></div>
<div class="view-panel" [class.open]="showViewPanel" *ngIf="showViewPanel">

  <!-- Header -->
  <div class="vp-header">
    <div>
      <code class="ref-code">{{ viewSurvey?.reference_no }}</code>
      <h2 class="vp-title">{{ viewSurvey?.title }}</h2>
    </div>
    <div class="vp-header-right">
      <span class="badge" [ngClass]="viewSurvey?.audience_type === 'customer' ? 'bdg-blue' : 'bdg-purple'">{{ viewSurvey?.audience_type }}</span>
      <span class="badge" [ngClass]="statusClass(viewSurvey?.status)">{{ viewSurvey?.status }}</span>
      <button class="modal-x" (click)="closeView()">✕</button>
    </div>
  </div>

  <!-- Tabs -->
  <div class="vp-tabs">
    <button class="vp-tab" [class.active]="viewTab==='overview'"   (click)="viewTab='overview'">Overview</button>
    <button class="vp-tab" [class.active]="viewTab==='questions'"  (click)="viewTab='questions'">Questions ({{ viewQuestions().length }})</button>
    <button class="vp-tab" [class.active]="viewTab==='responses'"  (click)="viewTab='responses'">Responses ({{ viewResponses().length }})</button>
    <button class="vp-tab" [class.active]="viewTab==='analytics'"  (click)="viewTab='analytics'">Analytics</button>
  </div>

  <div class="vp-body" *ngIf="!viewLoading()">

    <!-- OVERVIEW TAB -->
    <div *ngIf="viewTab === 'overview'">
      <div class="vp-grid-2">
        <div class="vp-field"><div class="vp-lbl">Type</div><div class="vp-val">{{ viewSurvey?.type }}</div></div>
        <div class="vp-field"><div class="vp-lbl">Status</div><div class="vp-val">{{ viewSurvey?.status }}</div></div>
        <div class="vp-field"><div class="vp-lbl">Send Date</div><div class="vp-val">{{ viewSurvey?.start_date || '—' }}</div></div>
        <div class="vp-field"><div class="vp-lbl">Close Date</div><div class="vp-val">{{ viewSurvey?.end_date || '—' }}</div></div>
        <div class="vp-field"><div class="vp-lbl">Total Sent</div><div class="vp-val">{{ viewSurvey?.total_sent }}</div></div>
        <div class="vp-field"><div class="vp-lbl">Responses</div><div class="vp-val">{{ viewSurvey?.total_responses }}</div></div>
        <div class="vp-field"><div class="vp-lbl">Response Rate</div><div class="vp-val">{{ responseRate(viewSurvey) }}</div></div>
        <div class="vp-field"><div class="vp-lbl">Avg Score</div><div class="vp-val">{{ viewSurvey?.average_score || '—' }}</div></div>
        <div class="vp-field" *ngIf="viewSurvey?.department"><div class="vp-lbl">Department</div><div class="vp-val">{{ viewSurvey.department.name }}</div></div>
        <div class="vp-field" *ngIf="viewSurvey?.audience_type === 'customer'"><div class="vp-lbl">Clients Selected</div><div class="vp-val">{{ viewSurvey?.client_ids?.length || 'All active clients' }}</div></div>
      </div>
      <div class="vp-field mt-12" *ngIf="viewSurvey?.description">
        <div class="vp-lbl">Description</div>
        <div class="vp-val">{{ viewSurvey.description }}</div>
      </div>
    </div>

    <!-- QUESTIONS TAB -->
    <div *ngIf="viewTab === 'questions'">
      <div class="empty-state" *ngIf="viewQuestions().length === 0">No questions added yet.</div>
      <div class="q-view-item" *ngFor="let q of viewQuestions(); let i = index">
        <div class="q-view-num">{{ i + 1 }}</div>
        <div class="q-view-body">
          <div class="q-view-text">{{ q.question }}</div>
          <div class="q-view-meta">
            <span class="badge bdg-gray">{{ q.type }}</span>
            <span class="badge" [ngClass]="q.is_required ? 'bdg-red' : 'bdg-gray'">{{ q.is_required ? 'Required' : 'Optional' }}</span>
            <span class="vp-lbl" *ngIf="q.scale_max">Scale: 1–{{ q.scale_max }}</span>
          </div>
          <div class="q-options" *ngIf="q.options?.length">
            <span class="q-opt" *ngFor="let o of q.options">{{ o }}</span>
          </div>
        </div>
      </div>
    </div>

    <!-- RESPONSES TAB -->
    <div *ngIf="viewTab === 'responses'">
      <div class="empty-state" *ngIf="viewResponses().length === 0">No responses yet.</div>
      <div class="resp-card" *ngFor="let r of viewResponses()">
        <div class="resp-header">
          <div class="resp-who">
            <strong>{{ r.respondent_name || r.user?.name || r.client?.name || 'Anonymous' }}</strong>
            <span *ngIf="r.respondent_email || r.user?.email" class="resp-email">{{ r.respondent_email || r.user?.email }}</span>
          </div>
          <div class="resp-meta">
            <span class="badge bdg-blue" *ngIf="r.overall_score">Score: {{ r.overall_score }}</span>
            <span class="resp-date">{{ r.submitted_at | date:'dd MMM yyyy, h:mm a' }}</span>
          </div>
        </div>
        <div class="resp-answers">
          <div class="ans-item" *ngFor="let a of r.answers">
            <div class="ans-q">{{ getQuestion(a.question_id) }}</div>
            <div class="ans-a">
              <span *ngIf="a.score !== undefined" class="score-pill">{{ a.score }}</span>
              <span *ngIf="a.answer && a.answer !== a.score">{{ a.answer }}</span>
            </div>
          </div>
        </div>
        <div class="resp-comments" *ngIf="r.comments">
          <div class="vp-lbl">Additional Comments</div>
          <div class="vp-val">{{ r.comments }}</div>
        </div>
      </div>
    </div>

    <!-- ANALYTICS TAB -->
    <div *ngIf="viewTab === 'analytics'">
      <div class="empty-state" *ngIf="!viewAnalytics()">No analytics data yet.</div>
      <div *ngIf="viewAnalytics()">
        <div class="analytics-kpis">
          <div class="kpi-card">
            <div class="kpi-val">{{ viewAnalytics().total_responses }}</div>
            <div class="kpi-lbl">Responses</div>
          </div>
          <div class="kpi-card">
            <div class="kpi-val">{{ viewAnalytics().response_rate }}%</div>
            <div class="kpi-lbl">Response Rate</div>
          </div>
          <div class="kpi-card">
            <div class="kpi-val">{{ viewAnalytics().average_score || '—' }}</div>
            <div class="kpi-lbl">Avg Score</div>
          </div>
          <div class="kpi-card" *ngIf="viewAnalytics().nps_score !== null">
            <div class="kpi-val">{{ viewAnalytics().nps_score }}</div>
            <div class="kpi-lbl">NPS Score</div>
          </div>
        </div>

        <div class="sec-title mt-20">PER-QUESTION BREAKDOWN</div>
        <div class="q-analytics-item" *ngFor="let q of viewAnalytics().by_question">
          <div class="qa-question">{{ q.question }}</div>
          <div class="qa-meta">{{ q.total_answers }} answers</div>
          <div class="qa-avg" *ngIf="q.average_score !== undefined">
            Avg: <strong>{{ q.average_score }}</strong>
            <div class="score-bar-wrap">
              <div class="score-bar" [style.width]="(q.average_score / 10 * 100) + '%'"></div>
            </div>
          </div>
          <div class="qa-dist" *ngIf="q.distribution">
            <div class="dist-item" *ngFor="let entry of distributionEntries(q.distribution)">
              <span class="dist-key">{{ entry.key }}</span>
              <div class="dist-bar-wrap">
                <div class="dist-bar" [style.width]="(entry.val / q.total_answers * 100) + '%'"></div>
              </div>
              <span class="dist-count">{{ entry.val }}</span>
            </div>
          </div>
          <div class="qa-yesno" *ngIf="q.yes_count !== undefined">
            <span class="badge bdg-green">Yes: {{ q.yes_count }}</span>
            <span class="badge bdg-red">No: {{ q.no_count }}</span>
          </div>
        </div>
      </div>
    </div>

  </div>
  <div class="vp-loading" *ngIf="viewLoading()"><div class="spinner"></div> Loading…</div>
</div>

<!-- ══════════════════════════════════════════════════════════════════════════
     BRANDING PREVIEW OVERLAY
══════════════════════════════════════════════════════════════════════════ -->
<div class="preview-overlay" *ngIf="showPreview">
  <div class="preview-toolbar">
    <div class="preview-toolbar-left">
      <span class="preview-badge">👁 Preview Mode</span>
      <span class="preview-note">This is how your survey will appear to respondents</span>
    </div>
    <button class="preview-close" (click)="showPreview=false">✕ Close Preview</button>
  </div>

  <!-- Full survey preview with branding applied -->
  <div class="preview-body"
       [style.background-color]="form.background_color || '#0f172a'"
       [style.background-image]="form.background_image ? 'url(' + form.background_image + ')' : 'none'"
       [style.background-size]="'cover'"
       [style.background-position]="'center'"
       [style.font-family]="form.font_family === 'serif' ? 'Georgia, serif' : form.font_family === 'mono' ? 'monospace' : 'system-ui, sans-serif'">

    <div class="preview-wrapper">
      <div class="preview-card" [style.background]="form.card_color || '#1e293b'">

        <!-- Header -->
        <div class="preview-header" [style.background]="form.card_color || '#1e293b'">
          <div class="preview-logo-wrap">
            <img *ngIf="form.logo_url" [src]="form.logo_url" class="preview-logo-img" alt="Logo">
            <div *ngIf="!form.logo_url" class="preview-logo-placeholder" [style.color]="form.primary_color || '#0ea5e9'">◈ Diamond QMS</div>
          </div>
          <h1 class="preview-title" [style.color]="form.header_text_color || '#f1f5f9'">
            {{ form.title || 'Survey Title' }}
          </h1>
          <p class="preview-desc" *ngIf="form.description">{{ form.description }}</p>
          <p class="preview-greeting">Hello, <strong>Respondent Name</strong></p>
        </div>

        <!-- Sample questions -->
        <div class="preview-questions">
          <div class="preview-q-block" *ngFor="let q of questions.slice(0,3); let i = index">
            <div class="preview-q-label">
              <span class="preview-q-num" [style.background]="form.primary_color || '#0ea5e9'">{{ i + 1 }}</span>
              {{ q.question || 'Question ' + (i+1) }}
              <span class="preview-required" *ngIf="q.is_required">*</span>
            </div>

            <!-- Rating preview -->
            <div class="preview-rating" *ngIf="q.type === 'rating'">
              <span class="preview-star" *ngFor="let s of [1,2,3,4,5]">★</span>
            </div>

            <!-- NPS preview -->
            <div class="preview-nps" *ngIf="q.type === 'nps'">
              <span class="preview-nps-btn" *ngFor="let n of [0,1,2,3,4,5,6,7,8,9,10]">{{ n }}</span>
            </div>

            <!-- Yes/No preview -->
            <div class="preview-yesno" *ngIf="q.type === 'yes_no'">
              <span class="preview-yn">👍 Yes</span>
              <span class="preview-yn">👎 No</span>
            </div>

            <!-- Single/Multi choice preview -->
            <div class="preview-choices" *ngIf="q.type === 'single_choice' || q.type === 'multi_choice'">
              <div class="preview-choice" *ngFor="let opt of (q.options || ['Option A', 'Option B', 'Option C']).slice(0,4)">
                <span class="preview-choice-icon">{{ q.type === 'single_choice' ? '○' : '☐' }}</span>
                {{ opt }}
              </div>
            </div>

            <!-- Text preview -->
            <div class="preview-text-placeholder" *ngIf="q.type === 'text'">
              <div class="preview-textarea">Your answer here…</div>
            </div>
          </div>

          <!-- Show count if more questions -->
          <div class="preview-more" *ngIf="questions.length > 3">
            + {{ questions.length - 3 }} more question{{ questions.length - 3 > 1 ? 's' : '' }}
          </div>

          <!-- Comments block -->
          <div class="preview-comments-label">Any additional comments? <span class="preview-optional">(optional)</span></div>
          <div class="preview-textarea">Additional feedback…</div>
        </div>

        <!-- Submit button -->
        <div class="preview-submit-row">
          <button class="preview-submit-btn"
                  [style.background]="form.primary_color || '#0ea5e9'">
            Submit Feedback →
          </button>
        </div>

        <div class="preview-footer">Diamond Insurance Brokers — Quality Management System</div>
      </div>
    </div>
  </div>
</div>

<!-- ══════════════════════════════════════════════════════════════════════════
     NEW / EDIT SURVEY MODAL
══════════════════════════════════════════════════════════════════════════ -->
<div class="backdrop" *ngIf="showModal" (click)="onBackdrop($event, closeModal.bind(this))">
  <div class="modal modal-lg">

    <div class="modal-hdr">
      <h2 class="modal-ttl">{{ editId ? '✏️ Edit Survey' : '📋 New Survey' }}</h2>
      <button class="modal-x" (click)="closeModal()">✕</button>
    </div>

    <div class="modal-body">

      <!-- SURVEY DETAILS -->
      <div class="sec-title">SURVEY DETAILS</div>
      <div class="grid-2">
        <div class="field">
          <label class="lbl">Title *</label>
          <input class="inp" type="text" [(ngModel)]="form.title" placeholder="e.g. Q2 Client Satisfaction Survey">
        </div>
        <div class="field">
          <label class="lbl">Survey Type *</label>
          <select class="inp" [(ngModel)]="form.type">
            <option value="csat">CSAT — Customer Satisfaction</option>
            <option value="nps">NPS — Net Promoter Score</option>
            <option value="general">General Feedback</option>
            <option value="post_visit">Post Visit</option>
            <option value="post_service">Post Service</option>
          </select>
        </div>
      </div>

      <div class="field mt-10">
        <label class="lbl">Description</label>
        <textarea class="inp inp-ta" rows="3" [(ngModel)]="form.description" placeholder="Describe the purpose of this survey…"></textarea>
      </div>

      <!-- TARGET AUDIENCE -->
      <div class="sec-title mt-20">TARGET AUDIENCE</div>
      <div class="grid-3">
        <div class="field">
          <label class="lbl">Target Audience *</label>
          <select class="inp" [(ngModel)]="form.audience_type" (ngModelChange)="onAudienceChange()">
            <option value="internal">Internal (Departments)</option>
            <option value="customer">Customer (Clients)</option>
          </select>
        </div>
        <div class="field">
          <label class="lbl">Send Date</label>
          <input class="inp" type="date" [(ngModel)]="form.start_date">
        </div>
        <div class="field">
          <label class="lbl">Close Date</label>
          <input class="inp" type="date" [(ngModel)]="form.end_date">
        </div>
      </div>

      <!-- INTERNAL: Department -->
      <div class="field mt-10" *ngIf="form.audience_type === 'internal'">
        <label class="lbl">Department *</label>
        <select class="inp" [(ngModel)]="form.department_id">
          <option value="">— All Departments —</option>
          <option *ngFor="let d of departments()" [value]="d.id">{{ d.name }}</option>
        </select>
      </div>

      <!-- CUSTOMER: Client multi-select -->
      <div class="field mt-10" *ngIf="form.audience_type === 'customer'">
        <label class="lbl">
          Select Clients
          <span class="lbl-hint">(leave empty to send to all active clients)</span>
        </label>

        <!-- Trigger -->
        <div class="ms-wrap">
          <button type="button" class="ms-trigger" (click)="clientDropOpen = !clientDropOpen" [class.open]="clientDropOpen">
            <span>{{ clientSelectionLabel() }}</span>
            <span class="ms-arrow">{{ clientDropOpen ? '▲' : '▼' }}</span>
          </button>

          <!-- Dropdown -->
          <div class="ms-drop" *ngIf="clientDropOpen">
            <div class="ms-search-wrap">
              <input class="ms-search" type="text" placeholder="Search clients…"
                     [ngModel]="clientSearch()" (ngModelChange)="clientSearch.set($event)" (click)="$event.stopPropagation()">
            </div>
            <div class="ms-ctrl-row">
              <button type="button" class="ms-ctrl" (click)="selectAllClients()">Select all</button>
              <button type="button" class="ms-ctrl" (click)="clearAllClients()">Clear</button>
              <span class="ms-count">{{ selectedClientIds().length }} selected</span>
            </div>
            <div class="ms-divider"></div>
            <div class="ms-list">
              <div class="ms-empty" *ngIf="filteredClients().length === 0">No clients found</div>
              <label class="ms-item" *ngFor="let c of filteredClients()" [class.checked]="isClientSel(c.id)">
                <input type="checkbox" [checked]="isClientSel(c.id)"
                       (change)="toggleClient(c.id)" (click)="$event.stopPropagation()">
                <div class="ms-item-body">
                  <div class="ms-name">{{ c.name }}</div>
                  <div class="ms-email" *ngIf="c.contact_email">{{ c.contact_email }}</div>
                </div>
              </label>
            </div>
          </div>
        </div>

        <!-- Chips -->
        <div class="chips" *ngIf="selectedClientIds().length > 0">
          <div class="chip" *ngFor="let c of selectedClients()">
            <span>{{ c.name }}</span>
            <button type="button" class="chip-x" (click)="removeClient(c.id)">✕</button>
          </div>
        </div>

        <div class="field-info" *ngIf="selectedClientIds().length === 0">
          ℹ️ No clients selected — survey will be sent to <strong>all active clients</strong>.
        </div>
      </div>

      <!-- SETTINGS -->
      <div class="grid-3 mt-14">
        <div class="field">
          <label class="lbl">Anonymous Responses</label>
          <select class="inp" [(ngModel)]="form.allow_anonymous">
            <option [ngValue]="false">No — Identify respondents</option>
            <option [ngValue]="true">Yes — Anonymous</option>
          </select>
        </div>
        <div class="field">
          <label class="lbl">Send Reminder</label>
          <select class="inp" [(ngModel)]="form.send_reminder">
            <option [ngValue]="false">No</option>
            <option [ngValue]="true">Yes</option>
          </select>
        </div>
        <div class="field" *ngIf="form.send_reminder">
          <label class="lbl">Reminder Days Before Close</label>
          <input class="inp" type="number" [(ngModel)]="form.reminder_days" min="1" max="30">
        </div>
      </div>

      <div class="field mt-10">
        <label class="lbl">Thank You Message</label>
        <input class="inp" type="text" [(ngModel)]="form.thank_you_message">
      </div>

      <!-- BRANDING -->
      <div class="sec-title mt-20">BRANDING &amp; APPEARANCE</div>
      <p class="sec-hint">Customise how the survey looks for your respondents.</p>

      <!-- Live preview -->
      <div class="branding-preview"
           [style.background-color]="form.background_color || '#0f172a'"
           [style.background-image]="form.background_image ? 'url(' + form.background_image + ')' : 'none'"
           [style.background-size]="'cover'"
           [style.border-color]="form.primary_color || '#0ea5e9'">
        <div class="bp-logo-area">
          <img *ngIf="form.logo_url" [src]="form.logo_url" class="bp-logo-img" alt="Logo">
          <div *ngIf="!form.logo_url" class="bp-logo-placeholder" [style.color]="form.primary_color">◈ Logo</div>
        </div>
        <div class="bp-card" [style.background]="form.card_color || '#1e293b'">
          <div class="bp-title" [style.color]="form.header_text_color || '#f1f5f9'">Survey Title</div>
          <button class="bp-btn" [style.background]="form.primary_color || '#0ea5e9'">Submit →</button>
        </div>
      </div>

      <!-- Logo upload -->
      <div class="grid-2 mt-10">
        <div class="field">
          <label class="lbl">Company Logo</label>
          <div class="upload-box" (click)="logoInput.click()" [class.has-file]="form.logo_url">
            <input #logoInput type="file" accept="image/*" style="display:none"
                   (change)="uploadFile($event, 'logo')">
            <div *ngIf="!form.logo_url && !uploadingLogo()" class="upload-placeholder">
              <span class="upload-icon">🖼️</span>
              <span>Click to upload logo</span>
              <span class="upload-hint">PNG, JPG, SVG · max 2MB</span>
            </div>
            <div *ngIf="uploadingLogo()" class="upload-placeholder">
              <span>⏳ Uploading…</span>
            </div>
            <div *ngIf="form.logo_url && !uploadingLogo()" class="upload-preview">
              <img [src]="form.logo_url" class="upload-thumb" alt="Logo">
              <button type="button" class="upload-remove" (click)="$event.stopPropagation(); form.logo_url = ''">✕ Remove</button>
            </div>
          </div>
          <div class="upload-err" *ngIf="logoError()">{{ logoError() }}</div>
        </div>

        <!-- Background image upload -->
        <div class="field">
          <label class="lbl">Background Image <span class="lbl-hint">(optional)</span></label>
          <div class="upload-box" (click)="bgInput.click()" [class.has-file]="form.background_image">
            <input #bgInput type="file" accept="image/*" style="display:none"
                   (change)="uploadFile($event, 'background')">
            <div *ngIf="!form.background_image && !uploadingBg()" class="upload-placeholder">
              <span class="upload-icon">🌄</span>
              <span>Click to upload background</span>
              <span class="upload-hint">PNG, JPG · max 2MB</span>
            </div>
            <div *ngIf="uploadingBg()" class="upload-placeholder">
              <span>⏳ Uploading…</span>
            </div>
            <div *ngIf="form.background_image && !uploadingBg()" class="upload-preview">
              <img [src]="form.background_image" class="upload-thumb" alt="Background">
              <button type="button" class="upload-remove" (click)="$event.stopPropagation(); form.background_image = ''">✕ Remove</button>
            </div>
          </div>
          <div class="upload-err" *ngIf="bgError()">{{ bgError() }}</div>
        </div>
      </div>

      <!-- Colors + font -->
      <div class="grid-3 mt-10">
        <div class="field">
          <label class="lbl">Background Color</label>
          <div class="color-field">
            <input class="color-pick" type="color" [(ngModel)]="form.background_color">
            <input class="inp color-hex" type="text" [(ngModel)]="form.background_color" placeholder="#0f172a" maxlength="7">
          </div>
        </div>
        <div class="field">
          <label class="lbl">Card Color</label>
          <div class="color-field">
            <input class="color-pick" type="color" [(ngModel)]="form.card_color">
            <input class="inp color-hex" type="text" [(ngModel)]="form.card_color" placeholder="#1e293b" maxlength="7">
          </div>
        </div>
        <div class="field">
          <label class="lbl">Accent / Button Color</label>
          <div class="color-field">
            <input class="color-pick" type="color" [(ngModel)]="form.primary_color">
            <input class="inp color-hex" type="text" [(ngModel)]="form.primary_color" placeholder="#0ea5e9" maxlength="7">
          </div>
        </div>
      </div>

      <div class="grid-2 mt-10">
        <div class="field">
          <label class="lbl">Header Text Color</label>
          <div class="color-field">
            <input class="color-pick" type="color" [(ngModel)]="form.header_text_color">
            <input class="inp color-hex" type="text" [(ngModel)]="form.header_text_color" placeholder="#f1f5f9" maxlength="7">
          </div>
        </div>
        <div class="field">
          <label class="lbl">Font Family</label>
          <select class="inp" [(ngModel)]="form.font_family">
            <option value="system">System (Default)</option>
            <option value="serif">Serif (Formal)</option>
            <option value="mono">Monospace (Technical)</option>
          </select>
        </div>
      </div>

      <!-- Language / Direction -->
      <div class="field mt-14">
        <label class="lbl">Survey Language &amp; Direction</label>
        <div class="lang-options">
          <div class="lang-opt" [class.active]="form.language === 'en' || !form.language"
               (click)="form.language = 'en'">
            <span class="lang-flag">🇬🇧</span>
            <div>
              <div class="lang-name">English</div>
              <div class="lang-dir">Left → Right</div>
            </div>
            <span class="lang-check" *ngIf="form.language === 'en' || !form.language">✓</span>
          </div>
          <div class="lang-opt" [class.active]="form.language === 'ar'"
               (click)="form.language = 'ar'">
            <span class="lang-flag">🇸🇦</span>
            <div>
              <div class="lang-name">العربية</div>
              <div class="lang-dir">Right ← Left</div>
            </div>
            <span class="lang-check" *ngIf="form.language === 'ar'">✓</span>
          </div>
        </div>
        <div class="lang-hint" *ngIf="form.language === 'ar'">
          ✅ Arabic mode: questions and answers will be displayed right-to-left on the survey page.
        </div>
      </div>

      <!-- QUESTIONS -->
      <div class="sec-title mt-20">QUESTIONS</div>
      <p class="sec-hint">Add questions to collect specific feedback. You can also add questions after creating the survey.</p>

      <div class="q-list">
        <div class="q-block" *ngFor="let q of questions; let i = index; trackBy: trackByIndex">
          <div class="q-row">
            <div class="q-num">{{ i + 1 }}</div>
            <input class="inp q-inp" type="text" [(ngModel)]="q.question"
                   [attr.dir]="form.language === 'ar' ? 'rtl' : 'ltr'"
                   [placeholder]="form.language === 'ar' ? 'نص السؤال…' : 'Question text…'">
            <select class="inp q-type" [(ngModel)]="q.type">
              <option value="rating">Rating (1–5)</option>
              <option value="nps">NPS (0–10)</option>
              <option value="text">Open Text</option>
              <option value="yes_no">Yes / No</option>
              <option value="single_choice">Single Choice</option>
              <option value="multi_choice">Multiple Choice</option>
            </select>
            <select class="inp q-req" [(ngModel)]="q.is_required">
              <option [ngValue]="true">Required</option>
              <option [ngValue]="false">Optional</option>
            </select>
            <button type="button" class="q-del" (click)="removeQuestion(i)">✕</button>
          </div>

          <!-- Options builder — shown only for single/multi choice questions -->
          <div class="q-options-wrap" *ngIf="q.type === 'single_choice' || q.type === 'multi_choice'">
            <div class="q-opts-label" [attr.dir]="form.language === 'ar' ? 'rtl' : 'ltr'">
              {{ form.language === 'ar' ? 'خيارات الإجابة' : 'Answer options' }}
              <span class="lbl-hint">{{ form.language === 'ar' ? '(اضغط Enter أو + للإضافة)' : '(press Enter or click + to add)' }}</span>
            </div>
            <div class="q-opt-list">
              <div class="q-opt-row" *ngFor="let opt of (q.options || []); let oi = index; trackBy: trackByIndex">
                <span class="q-opt-icon">{{ q.type === 'single_choice' ? '○' : '☐' }}</span>
                <input
                  class="inp q-opt-inp"
                  type="text"
                  [value]="opt"
                  (input)="updateOption(i, oi, $any($event.target).value)"
                  [attr.dir]="form.language === 'ar' ? 'rtl' : 'ltr'"
                  [placeholder]="form.language === 'ar' ? ('الخيار ' + (oi + 1)) : ('Option ' + (oi + 1))"
                  (keydown.enter)="$event.preventDefault(); addOption(i)">
                <button type="button" class="q-opt-del" (click)="removeOption(i, oi)" title="Remove option">✕</button>
              </div>
              <div class="q-opt-empty" *ngIf="!q.options || q.options.length === 0">
                No options yet — click + to add choices
              </div>
            </div>
            <button type="button" class="q-opt-add" (click)="addOption(i)">+ Add option</button>
          </div>
        </div>
      </div>
      <button type="button" class="btn-add-q" (click)="addQuestion()">{{ form.language === 'ar' ? '+ إضافة سؤال' : '+ Add Question' }}</button>

      <!-- Error -->
      <div class="alert-err" *ngIf="modalError()">⚠️ {{ modalError() }}</div>
    </div>

    <div class="modal-ftr">
      <button class="btn btn-sec" (click)="closeModal()" [disabled]="saving()">Cancel</button>
      <button class="btn btn-preview" type="button" (click)="showPreview=true" [disabled]="saving()">👁 Preview</button>
      <button class="btn btn-primary" (click)="save()" [disabled]="saving()">
        {{ saving() ? '⏳ Saving…' : (editId ? '💾 Update Survey' : '✅ Create Survey') }}
      </button>
    </div>
  </div>
</div>


<!-- ══════════════════════════════════════════════════════════════════════════
     SEND TO CUSTOMERS MODAL
══════════════════════════════════════════════════════════════════════════ -->
<div class="backdrop" *ngIf="showSendModal" (click)="onBackdrop($event, closeSendModal.bind(this))">
  <div class="modal">

    <div class="modal-hdr">
      <h2 class="modal-ttl">📧 Send to Customers</h2>
      <button class="modal-x" (click)="closeSendModal()">✕</button>
    </div>

    <div class="modal-body">
      <p class="send-name">📋 <strong>{{ sendTarget?.title }}</strong></p>

      <div class="field mt-12">
        <label class="lbl">
          Select Clients
          <span class="lbl-hint">(empty = all active clients)</span>
        </label>
        <div class="ms-wrap">
          <button type="button" class="ms-trigger" (click)="sendDropOpen = !sendDropOpen" [class.open]="sendDropOpen">
            <span>{{ sendClientIds().length === 0 ? 'All active clients' : sendClientIds().length + ' client(s) selected' }}</span>
            <span class="ms-arrow">{{ sendDropOpen ? '▲' : '▼' }}</span>
          </button>
          <div class="ms-drop" *ngIf="sendDropOpen">
            <div class="ms-search-wrap">
              <input class="ms-search" type="text" placeholder="Search clients…"
                     [ngModel]="sendClientSearch()" (ngModelChange)="sendClientSearch.set($event)" (click)="$event.stopPropagation()">
            </div>
            <div class="ms-ctrl-row">
              <button type="button" class="ms-ctrl" (click)="selectAllSendClients()">Select all</button>
              <button type="button" class="ms-ctrl" (click)="clearSendClients()">Clear</button>
              <span class="ms-count">{{ sendClientIds().length }} selected</span>
            </div>
            <div class="ms-divider"></div>
            <div class="ms-list">
              <label class="ms-item" *ngFor="let c of filteredSendClients()" [class.checked]="isSendSel(c.id)">
                <input type="checkbox" [checked]="isSendSel(c.id)"
                       (change)="toggleSend(c.id)" (click)="$event.stopPropagation()">
                <div class="ms-item-body">
                  <div class="ms-name">{{ c.name }}</div>
                  <div class="ms-email">{{ c.contact_email }}</div>
                </div>
              </label>
            </div>
          </div>
        </div>
      </div>

      <div class="field mt-14">
        <label class="lbl">Send Email Invitation</label>
        <select class="inp" [(ngModel)]="sendEmail">
          <option [ngValue]="true">Yes — Email survey link to client contact</option>
          <option [ngValue]="false">No — Generate tokens only</option>
        </select>
      </div>

      <div class="info-banner mt-12">
        ℹ️ Each client receives a unique secure link. Previously sent clients are automatically skipped.
      </div>

      <div class="alert-err" *ngIf="sendError()">⚠️ {{ sendError() }}</div>
      <div class="alert-ok"  *ngIf="sendSuccess()">✅ {{ sendSuccess() }}</div>
    </div>

    <div class="modal-ftr">
      <button class="btn btn-sec" (click)="closeSendModal()">Cancel</button>
      <button class="btn btn-primary" (click)="doSend()" [disabled]="sending()">
        {{ sending() ? '⏳ Sending…' : '📧 Send Survey' }}
      </button>
    </div>
  </div>
</div>
  `,
  styles: [`
    .page { padding: 1.5rem; width: 100%; box-sizing: border-box; }

    /* Header */
    .page-header { display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:1.5rem; }
    .page-title  { font-size:1.5rem; font-weight:700; color:var(--text-primary); margin:0 0 .25rem; }
    .page-sub    { color:var(--text-muted); font-size:.85rem; margin:0; }

    /* Stats */
    .stats-row { display:grid; grid-template-columns:repeat(6,1fr); gap:.75rem; margin-bottom:1.25rem; }
    @media(max-width:900px){ .stats-row{ grid-template-columns:repeat(3,1fr); } }
    .stat-card { background:var(--surface); border:1px solid var(--border); border-radius:10px; padding:.9rem 1rem; text-align:center; }
    .stat-val  { font-size:1.5rem; font-weight:700; color:var(--text-primary); }
    .stat-lbl  { font-size:.72rem; color:var(--text-muted); margin-top:.2rem; text-transform:uppercase; letter-spacing:.05em; }

    /* Filters */
    .filters-row { display:flex; gap:.75rem; margin-bottom:1rem; flex-wrap:wrap; }
    .f-input,.f-sel { padding:.5rem .75rem; border-radius:7px; border:1px solid var(--border); background:var(--surface); color:var(--text-primary); font-size:.85rem; }
    .f-input { flex:1; min-width:200px; }
    .f-sel   { min-width:150px; }
    .f-input:focus,.f-sel:focus { outline:none; border-color:var(--accent); }

    /* Table */
    .table-card { background:var(--surface); border:1px solid var(--border); border-radius:10px; overflow:hidden; }
    .tbl        { width:100%; border-collapse:collapse; font-size:.84rem; }
    .tbl th     { background:rgba(0,0,0,.15); color:var(--text-muted); font-size:.72rem; font-weight:700; letter-spacing:.05em; text-transform:uppercase; padding:.65rem .9rem; text-align:left; border-bottom:1px solid var(--border); }
    .tbl td     { padding:.7rem .9rem; border-bottom:1px solid var(--border); color:var(--text-secondary); vertical-align:middle; }
    .tbl tr:last-child td { border-bottom:none; }
    .tbl tr:hover td { background:rgba(255,255,255,.03); }
    .num        { text-align:center; font-variant-numeric:tabular-nums; }
    .tbl-title  { font-weight:600; color:var(--text-primary); }
    .tbl-meta   { font-size:.75rem; color:var(--text-muted); margin-top:2px; }
    .tbl-type   { font-size:.75rem; color:var(--text-muted); text-transform:uppercase; letter-spacing:.04em; }
    .ref-code   { font-family:monospace; font-size:.78rem; color:var(--accent); }
    .act-cell   { white-space:nowrap; }
    .ic-btn     { background:none; border:none; cursor:pointer; padding:.25rem .35rem; border-radius:5px; font-size:.95rem; transition:background .15s; }
    .ic-btn:hover { background:rgba(255,255,255,.08); }
    .send-ic:hover { background:rgba(14,165,233,.12); }
    .del-ic:hover  { background:rgba(239,68,68,.12); }
    .loading-row,.empty-state { text-align:center; padding:3rem; color:var(--text-muted); font-size:.9rem; display:flex; align-items:center; justify-content:center; gap:.75rem; }
    .spinner { width:22px; height:22px; border:2px solid var(--border); border-top-color:var(--accent); border-radius:50%; animation:spin .7s linear infinite; }
    @keyframes spin{ to{ transform:rotate(360deg); } }

    /* Badges */
    .badge      { padding:.15rem .55rem; border-radius:10px; font-size:.72rem; font-weight:700; text-transform:capitalize; white-space:nowrap; }
    .bdg-green  { background:rgba(34,197,94,.15);  color:#22c55e; }
    .bdg-gray   { background:rgba(100,116,139,.15); color:#94a3b8; }
    .bdg-yellow { background:rgba(234,179,8,.15);   color:#eab308; }
    .bdg-red    { background:rgba(239,68,68,.15);   color:#ef4444; }
    .bdg-blue   { background:rgba(14,165,233,.15);  color:#0ea5e9; }
    .bdg-purple { background:rgba(168,85,247,.15);  color:#a855f7; }

    /* Modal */
    .backdrop { position:fixed; inset:0; background:rgba(0,0,0,.65); backdrop-filter:blur(2px); z-index:1000; display:flex; align-items:flex-start; justify-content:center; padding:2rem 1rem; overflow-y:auto; }
    .modal     { background:var(--surface); border:1px solid var(--border); border-radius:14px; width:100%; max-width:560px; box-shadow:0 24px 60px rgba(0,0,0,.5); overflow:hidden; animation:slideUp .2s ease; }
    .modal-lg  { max-width:780px; }
    @keyframes slideUp{ from{ transform:translateY(18px); opacity:0; } to{ transform:translateY(0); opacity:1; } }
    .modal-hdr { display:flex; align-items:center; justify-content:space-between; padding:1.25rem 1.5rem; border-bottom:1px solid var(--border); }
    .modal-ttl { font-size:1.05rem; font-weight:700; color:var(--text-primary); margin:0; }
    .modal-x   { background:none; border:none; color:var(--text-muted); font-size:1rem; cursor:pointer; padding:.25rem .4rem; border-radius:4px; }
    .modal-x:hover { background:rgba(255,255,255,.08); }
    .modal-body { padding:1.4rem 1.5rem; max-height:70vh; overflow-y:auto; }
    .modal-ftr  { display:flex; justify-content:flex-end; gap:.75rem; padding:1rem 1.5rem; border-top:1px solid var(--border); background:rgba(0,0,0,.1); }

    /* Form */
    .sec-title   { font-size:.72rem; font-weight:700; letter-spacing:.1em; text-transform:uppercase; color:var(--text-muted); margin-bottom:.75rem; }
    .sec-hint    { font-size:.8rem; color:var(--text-muted); margin-bottom:.75rem; }
    .grid-2      { display:grid; grid-template-columns:1fr 1fr; gap:.9rem; }
    .grid-3      { display:grid; grid-template-columns:1fr 1fr 1fr; gap:.9rem; }
    @media(max-width:600px){ .grid-2,.grid-3{ grid-template-columns:1fr; } }
    .field       { display:flex; flex-direction:column; gap:.35rem; }
    .lbl         { font-size:.78rem; font-weight:600; color:var(--text-secondary); }
    .lbl-hint    { font-weight:400; color:var(--text-muted); font-size:.73rem; margin-left:.3rem; }
    .inp         { padding:.52rem .75rem; border-radius:7px; border:1px solid var(--border); background:var(--surface); color:var(--text-primary); font-size:.875rem; box-sizing:border-box; width:100%; }
    .inp:focus   { outline:none; border-color:var(--accent); box-shadow:0 0 0 3px rgba(14,165,233,.13); }
    .inp-ta      { resize:vertical; min-height:80px; font-family:inherit; }
    .field-info  { margin-top:.5rem; padding:.6rem .75rem; border-radius:7px; background:rgba(14,165,233,.07); border:1px solid rgba(14,165,233,.18); font-size:.78rem; color:var(--text-muted); }
    .mt-10 { margin-top:10px; } .mt-12 { margin-top:12px; } .mt-14 { margin-top:14px; } .mt-20 { margin-top:20px; }

    /* Multi-select */
    .ms-wrap    { position:relative; }
    .ms-trigger { display:flex; align-items:center; justify-content:space-between; width:100%; padding:.52rem .75rem; border-radius:7px; border:1px solid var(--border); background:var(--surface); color:var(--text-primary); font-size:.875rem; cursor:pointer; text-align:left; transition:border-color .15s; }
    .ms-trigger:hover,.ms-trigger.open { border-color:var(--accent); }
    .ms-arrow   { color:var(--text-muted); font-size:.7rem; margin-left:.5rem; flex-shrink:0; }
    .ms-drop    { position:absolute; top:calc(100% + 4px); left:0; right:0; background:var(--surface); border:1px solid var(--border); border-radius:10px; box-shadow:0 12px 40px rgba(0,0,0,.45); z-index:500; overflow:hidden; }
    .ms-search-wrap { padding:.6rem .75rem; border-bottom:1px solid var(--border); }
    .ms-search  { width:100%; padding:.45rem .65rem; border-radius:6px; border:1px solid var(--border); background:rgba(0,0,0,.2); color:var(--text-primary); font-size:.83rem; box-sizing:border-box; }
    .ms-search:focus { outline:none; border-color:var(--accent); }
    .ms-ctrl-row { display:flex; align-items:center; gap:.5rem; padding:.4rem .75rem; }
    .ms-ctrl    { background:none; border:none; color:var(--accent); font-size:.78rem; cursor:pointer; padding:0; font-weight:600; }
    .ms-ctrl:hover { text-decoration:underline; }
    .ms-count   { margin-left:auto; font-size:.75rem; color:var(--text-muted); }
    .ms-divider { height:1px; background:var(--border); }
    .ms-list    { max-height:200px; overflow-y:auto; padding:.4rem 0; }
    .ms-empty   { padding:1rem; text-align:center; color:var(--text-muted); font-size:.83rem; }
    .ms-item    { display:flex; align-items:center; gap:.7rem; padding:.5rem .75rem; cursor:pointer; transition:background .12s; }
    .ms-item:hover  { background:rgba(255,255,255,.05); }
    .ms-item.checked{ background:rgba(14,165,233,.08); }
    .ms-item input  { cursor:pointer; flex-shrink:0; accent-color:var(--accent); }
    .ms-item-body   { flex:1; min-width:0; }
    .ms-name  { font-size:.85rem; color:var(--text-primary); white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
    .ms-email { font-size:.72rem; color:var(--text-muted); white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }

    /* Chips */
    .chips  { display:flex; flex-wrap:wrap; gap:.4rem; margin-top:.6rem; }
    .chip   { display:inline-flex; align-items:center; gap:.35rem; padding:.2rem .4rem .2rem .65rem; background:rgba(14,165,233,.12); border:1px solid rgba(14,165,233,.3); border-radius:20px; font-size:.78rem; color:var(--text-primary); }
    .chip-x { background:none; border:none; color:var(--text-muted); cursor:pointer; font-size:.7rem; padding:0; }
    .chip-x:hover { color:var(--text-primary); }

    /* Questions */
    .q-list { display:flex; flex-direction:column; gap:.6rem; margin-bottom:.75rem; }
    .q-row  { display:flex; align-items:center; gap:.5rem; }
    .q-num  { min-width:26px; height:26px; border-radius:50%; background:var(--accent); color:#fff; font-size:.72rem; font-weight:700; display:flex; align-items:center; justify-content:center; flex-shrink:0; }
    .q-inp  { flex:1; }
    .q-type { width:140px; flex-shrink:0; }
    .q-req  { width:110px; flex-shrink:0; }
    .q-del  { background:none; border:none; color:var(--text-muted); cursor:pointer; font-size:.85rem; padding:.25rem; border-radius:4px; flex-shrink:0; }
    .q-del:hover { color:#ef4444; background:rgba(239,68,68,.1); }
    .btn-add-q { background:none; border:1px dashed var(--border); border-radius:7px; color:var(--text-muted); font-size:.83rem; padding:.5rem 1rem; cursor:pointer; width:100%; transition:all .15s; }
    .btn-add-q:hover { border-color:var(--accent); color:var(--accent); }
    /* Options builder */
    .q-block      { display:flex; flex-direction:column; gap:6px; }
    .q-options-wrap { margin-left:34px; padding:10px 12px; background:rgba(0,0,0,.15); border-radius:8px; border:1px solid var(--border); }
    .q-opts-label { font-size:.75rem; font-weight:600; color:var(--text-muted); margin-bottom:8px; }
    .q-opt-list   { display:flex; flex-direction:column; gap:6px; margin-bottom:8px; }
    .q-opt-row    { display:flex; align-items:center; gap:8px; }
    .q-opt-icon   { color:var(--text-muted); font-size:.9rem; width:16px; text-align:center; flex-shrink:0; }
    .q-opt-inp    { flex:1; padding:.4rem .65rem; font-size:.82rem; }
    .q-opt-del    { background:none; border:none; color:var(--text-muted); cursor:pointer; font-size:.8rem; padding:.2rem .35rem; border-radius:4px; flex-shrink:0; }
    .q-opt-del:hover { color:#ef4444; background:rgba(239,68,68,.1); }
    .q-opt-empty  { font-size:.78rem; color:var(--text-muted); padding:.35rem .5rem; font-style:italic; }
    .q-opt-add    { background:none; border:1px dashed var(--border); border-radius:6px; color:var(--accent); font-size:.78rem; padding:.35rem .75rem; cursor:pointer; transition:all .15s; }
    .q-opt-add:hover { background:rgba(14,165,233,.08); border-color:var(--accent); }

    /* Buttons */
    .btn        { padding:.55rem 1.25rem; border-radius:7px; font-size:.875rem; font-weight:600; cursor:pointer; border:none; transition:opacity .15s; }
    .btn:disabled { opacity:.5; cursor:not-allowed; }
    .btn:not(:disabled):hover { opacity:.88; }
    .btn-primary { background:var(--accent, #0ea5e9); color:#fff; }
    .btn-sec     { background:transparent; border:1px solid var(--border); color:var(--text-secondary); }

    /* Alerts */
    .alert-err { margin-top:1rem; padding:.7rem 1rem; border-radius:8px; background:rgba(239,68,68,.1); border:1px solid rgba(239,68,68,.25); color:#f87171; font-size:.83rem; }
    .alert-ok  { margin-top:1rem; padding:.7rem 1rem; border-radius:8px; background:rgba(34,197,94,.1);  border:1px solid rgba(34,197,94,.25);  color:#4ade80; font-size:.83rem; }
    .info-banner { padding:.75rem 1rem; border-radius:8px; font-size:.82rem; background:rgba(14,165,233,.08); border:1px solid rgba(14,165,233,.2); color:var(--text-muted); line-height:1.5; }
    .send-name  { color:var(--text-secondary); font-size:.9rem; margin:0; }
    /* ── Branding Preview Overlay ────────────────────────────────────────────── */
    .preview-overlay {
      position:fixed; inset:0; z-index:2000;
      display:flex; flex-direction:column; overflow:hidden;
    }
    .preview-toolbar {
      display:flex; align-items:center; justify-content:space-between;
      padding:.75rem 1.5rem; background:#0f172a; border-bottom:1px solid #334155;
      flex-shrink:0; gap:1rem; z-index:10;
    }
    .preview-toolbar-left { display:flex; align-items:center; gap:1rem; }
    .preview-badge {
      padding:.3rem .75rem; border-radius:20px; font-size:.78rem; font-weight:700;
      background:rgba(14,165,233,.15); border:1px solid rgba(14,165,233,.3); color:#38bdf8;
    }
    .preview-note { font-size:.8rem; color:#64748b; }
    .preview-close {
      padding:.45rem 1rem; border-radius:7px; border:1px solid #334155;
      background:transparent; color:#94a3b8; font-size:.83rem; cursor:pointer;
      transition:all .15s;
    }
    .preview-close:hover { border-color:#ef4444; color:#f87171; }

    .preview-body {
      flex:1; overflow-y:auto; display:flex;
      align-items:flex-start; justify-content:center;
      padding:2rem 1rem 4rem;
    }
    .preview-wrapper { width:100%; max-width:620px; }
    .preview-card {
      border-radius:14px; overflow:hidden;
      box-shadow:0 20px 60px rgba(0,0,0,.6);
    }
    .preview-header { padding:1.75rem 2rem 1.5rem; border-bottom:1px solid rgba(255,255,255,.08); }
    .preview-logo-wrap { margin-bottom:.9rem; }
    .preview-logo-img { height:44px; max-width:180px; object-fit:contain; border-radius:6px; }
    .preview-logo-placeholder { font-size:.82rem; font-weight:700; letter-spacing:.08em; }
    .preview-title { font-size:1.5rem; font-weight:700; margin:0 0 .5rem; }
    .preview-desc { font-size:.88rem; color:#94a3b8; margin:0 0 .65rem; line-height:1.6; }
    .preview-greeting { font-size:.85rem; color:#94a3b8; margin:0; }

    .preview-questions { padding:1.5rem 2rem; display:flex; flex-direction:column; gap:1.75rem; }
    .preview-q-block { display:flex; flex-direction:column; gap:.75rem; }
    .preview-q-label {
      font-size:.93rem; font-weight:600; color:#e2e8f0;
      display:flex; align-items:center; gap:.5rem;
    }
    .preview-q-num {
      min-width:24px; height:24px; border-radius:50%; color:#fff;
      font-size:.7rem; font-weight:700; display:flex; align-items:center; justify-content:center; flex-shrink:0;
    }
    .preview-required { color:#f87171; font-size:.85rem; }

    .preview-rating { display:flex; gap:.35rem; padding-left:2rem; }
    .preview-star { font-size:1.8rem; color:#334155; }

    .preview-nps { display:flex; gap:.3rem; padding-left:2rem; flex-wrap:wrap; }
    .preview-nps-btn {
      width:36px; height:36px; border-radius:7px; border:1px solid #334155;
      background:#0f172a; color:#94a3b8; font-size:.8rem; font-weight:600;
      display:flex; align-items:center; justify-content:center;
    }

    .preview-yesno { display:flex; gap:1rem; padding-left:2rem; }
    .preview-yn {
      padding:.55rem 1.25rem; border-radius:8px;
      border:1px solid #334155; background:#0f172a; color:#94a3b8; font-size:.88rem;
    }

    .preview-choices { display:flex; flex-direction:column; gap:.45rem; padding-left:2rem; }
    .preview-choice { display:flex; align-items:center; gap:.65rem; font-size:.875rem; color:#cbd5e1; }
    .preview-choice-icon { color:#64748b; }

    .preview-text-placeholder { padding-left:2rem; }
    .preview-textarea {
      width:100%; padding:.7rem .85rem; border-radius:8px;
      border:1px solid #334155; background:rgba(0,0,0,.2); color:#64748b;
      font-size:.875rem; min-height:72px; display:flex; align-items:flex-start;
      box-sizing:border-box;
    }

    .preview-more { color:#64748b; font-size:.82rem; font-style:italic; padding-left:2rem; }
    .preview-comments-label { font-size:.88rem; color:#e2e8f0; font-weight:600; margin-bottom:.5rem; }
    .preview-optional { font-weight:400; color:#64748b; font-size:.8rem; }

    .preview-submit-row { padding:1.5rem 2rem 2rem; }
    .preview-submit-btn {
      width:100%; padding:.875rem; border:none; border-radius:10px;
      color:#fff; font-size:1rem; font-weight:700; cursor:default;
      opacity:.85;
    }
    .preview-footer {
      text-align:center; padding:.85rem; font-size:.7rem; color:#475569;
      border-top:1px solid rgba(255,255,255,.06);
    }
    .btn-preview {
      padding:.55rem 1.1rem; border-radius:7px; font-size:.875rem;
      font-weight:600; cursor:pointer; border:1px solid var(--border);
      background:rgba(14,165,233,.1); color:#38bdf8; transition:all .15s;
    }
    .btn-preview:hover { background:rgba(14,165,233,.18); border-color:#38bdf8; }
    /* Language selector */
    .lang-options { display:flex; gap:10px; }
    .lang-opt { display:flex; align-items:center; gap:10px; padding:10px 14px; border-radius:8px; border:1px solid var(--border); cursor:pointer; flex:1; transition:all .15s; background:var(--surface); }
    .lang-opt:hover { border-color:var(--accent); }
    .lang-opt.active { border-color:var(--accent); background:rgba(14,165,233,.08); }
    .lang-flag { font-size:1.5rem; flex-shrink:0; }
    .lang-name { font-size:.85rem; font-weight:600; color:var(--text-primary); }
    .lang-dir  { font-size:.72rem; color:var(--text-muted); }
    .lang-check { margin-left:auto; color:var(--accent); font-weight:700; font-size:1rem; }
    .lang-hint { margin-top:8px; padding:8px 12px; border-radius:7px; font-size:.78rem; background:rgba(34,197,94,.08); border:1px solid rgba(34,197,94,.2); color:#4ade80; }

    /* Branding */
    /* File upload boxes */
    .upload-box { border:2px dashed var(--border); border-radius:10px; padding:16px; cursor:pointer; transition:all .2s; min-height:90px; display:flex; align-items:center; justify-content:center; }
    .upload-box:hover, .upload-box.has-file { border-color:var(--accent); background:rgba(14,165,233,.04); }
    .upload-placeholder { display:flex; flex-direction:column; align-items:center; gap:4px; color:var(--text-muted); font-size:.8rem; text-align:center; pointer-events:none; }
    .upload-icon { font-size:1.5rem; }
    .upload-hint { font-size:.7rem; color:var(--text-muted); opacity:.7; }
    .upload-preview { display:flex; flex-direction:column; align-items:center; gap:8px; }
    .upload-thumb { max-height:60px; max-width:140px; object-fit:contain; border-radius:6px; }
    .upload-remove { background:rgba(239,68,68,.12); border:1px solid rgba(239,68,68,.3); color:#f87171; border-radius:6px; padding:3px 10px; font-size:.75rem; cursor:pointer; }
    .upload-remove:hover { background:rgba(239,68,68,.25); }
    .upload-err { font-size:.75rem; color:#f87171; margin-top:4px; }
    .branding-preview { border-radius:10px; padding:14px; border:2px solid; margin-bottom:12px; display:flex; align-items:center; gap:14px; transition:all .3s; }
    .bp-logo { flex-shrink:0; }
    .bp-logo-img { height:36px; max-width:120px; object-fit:contain; border-radius:4px; }
    .bp-logo-placeholder { font-size:.78rem; color:rgba(255,255,255,.4); font-style:italic; }
    .bp-card { border-radius:8px; padding:10px 14px; flex:1; display:flex; align-items:center; justify-content:space-between; }
    .bp-title { font-size:.85rem; font-weight:600; }
    .bp-btn { border:none; border-radius:6px; padding:5px 14px; font-size:.78rem; font-weight:700; color:#fff; cursor:default; }
    .color-field { display:flex; align-items:center; gap:8px; }
    .color-pick { width:36px; height:36px; border:1px solid var(--border); border-radius:7px; padding:2px; cursor:pointer; background:none; flex-shrink:0; }
    .color-hex { flex:1; font-family:monospace; font-size:.82rem; }
    /* ── Pagination ──────────────────────────────────────────────────────────── */
    .pagination-bar {
      display:flex; align-items:center; justify-content:space-between;
      padding:.85rem 1.25rem; border-top:1px solid var(--border);
      flex-wrap:wrap; gap:.75rem;
    }
    .pg-info  { font-size:.82rem; color:var(--text-muted); white-space:nowrap; }
    .pg-controls { display:flex; align-items:center; gap:.3rem; flex-wrap:wrap; }
    .pg-btn {
      min-width:34px; height:34px; padding:0 .6rem;
      border-radius:7px; border:1px solid var(--border);
      background:var(--surface); color:var(--text-secondary);
      font-size:.83rem; cursor:pointer; transition:all .15s;
      display:flex; align-items:center; justify-content:center;
    }
    .pg-btn:hover:not(:disabled) { border-color:var(--accent); color:var(--accent); background:rgba(14,165,233,.08); }
    .pg-btn:disabled { opacity:.4; cursor:not-allowed; }
    .pg-btn.pg-active { background:var(--accent); border-color:var(--accent); color:#fff; font-weight:700; }
    .pg-dots { padding:0 .25rem; color:var(--text-muted); font-size:.85rem; }
    .pg-size select {
      padding:.4rem .65rem; border-radius:7px; border:1px solid var(--border);
      background:var(--surface); color:var(--text-secondary); font-size:.82rem; cursor:pointer;
    }
    .pg-size select:focus { outline:none; border-color:var(--accent); }
    /* View Panel */
    .view-overlay { position:fixed; inset:0; background:rgba(0,0,0,.5); z-index:900; }
    .view-panel { position:fixed; top:0; right:0; bottom:0; width:680px; max-width:95vw; background:var(--surface); border-left:1px solid var(--border); z-index:901; display:flex; flex-direction:column; transform:translateX(100%); transition:transform .25s ease; box-shadow:-8px 0 40px rgba(0,0,0,.4); }
    .view-panel.open { transform:translateX(0); }
    .vp-header { display:flex; align-items:flex-start; justify-content:space-between; padding:1.25rem 1.5rem; border-bottom:1px solid var(--border); flex-shrink:0; }
    .vp-title { font-size:1.1rem; font-weight:700; color:var(--text-primary); margin:.3rem 0 0; }
    .vp-header-right { display:flex; align-items:center; gap:.5rem; flex-shrink:0; }
    .vp-tabs { display:flex; border-bottom:1px solid var(--border); background:rgba(0,0,0,.1); flex-shrink:0; overflow-x:auto; }
    .vp-tab { padding:.75rem 1.25rem; background:none; border:none; border-bottom:2px solid transparent; color:var(--text-muted); font-size:.85rem; cursor:pointer; white-space:nowrap; transition:all .15s; }
    .vp-tab:hover { color:var(--text-primary); }
    .vp-tab.active { color:var(--accent); border-bottom-color:var(--accent); font-weight:600; }
    .vp-body { flex:1; overflow-y:auto; padding:1.5rem; }
    .vp-loading { display:flex; align-items:center; justify-content:center; gap:.75rem; padding:3rem; color:var(--text-muted); }
    .vp-grid-2 { display:grid; grid-template-columns:1fr 1fr; gap:.75rem; }
    .vp-field { display:flex; flex-direction:column; gap:.25rem; padding:.6rem .75rem; background:rgba(0,0,0,.1); border-radius:7px; }
    .vp-lbl { font-size:.72rem; font-weight:600; color:var(--text-muted); text-transform:uppercase; letter-spacing:.05em; }
    .vp-val { font-size:.88rem; color:var(--text-primary); }
    .q-view-item { display:flex; gap:.75rem; padding:.9rem 0; border-bottom:1px solid var(--border); }
    .q-view-num { min-width:26px; height:26px; border-radius:50%; background:var(--accent); color:#fff; font-size:.72rem; font-weight:700; display:flex; align-items:center; justify-content:center; flex-shrink:0; margin-top:2px; }
    .q-view-body { flex:1; }
    .q-view-text { font-size:.9rem; color:var(--text-primary); margin-bottom:.4rem; font-weight:500; }
    .q-view-meta { display:flex; gap:.4rem; flex-wrap:wrap; margin-bottom:.35rem; }
    .q-options { display:flex; flex-wrap:wrap; gap:.35rem; margin-top:.35rem; }
    .q-opt { padding:.15rem .5rem; background:rgba(255,255,255,.07); border-radius:5px; font-size:.75rem; color:var(--text-muted); }
    .resp-card { background:rgba(0,0,0,.1); border:1px solid var(--border); border-radius:10px; padding:1rem; margin-bottom:.75rem; }
    .resp-header { display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:.75rem; flex-wrap:wrap; gap:.5rem; }
    .resp-who { display:flex; flex-direction:column; gap:.15rem; }
    .resp-email { font-size:.75rem; color:var(--text-muted); }
    .resp-meta { display:flex; align-items:center; gap:.5rem; }
    .resp-date { font-size:.75rem; color:var(--text-muted); }
    .resp-answers { display:flex; flex-direction:column; gap:.5rem; }
    .ans-item { display:flex; align-items:flex-start; justify-content:space-between; gap:.75rem; padding:.5rem; background:rgba(255,255,255,.03); border-radius:6px; }
    .ans-q { flex:1; font-size:.82rem; color:var(--text-secondary); }
    .ans-a { font-size:.85rem; color:var(--text-primary); font-weight:600; display:flex; align-items:center; gap:.4rem; }
    .score-pill { background:var(--accent); color:#fff; padding:.15rem .5rem; border-radius:10px; font-size:.78rem; font-weight:700; }
    .resp-comments { margin-top:.75rem; padding-top:.75rem; border-top:1px solid var(--border); }
    .analytics-kpis { display:grid; grid-template-columns:repeat(4,1fr); gap:.75rem; margin-bottom:1.5rem; }
    .kpi-card { background:rgba(0,0,0,.15); border:1px solid var(--border); border-radius:8px; padding:.9rem; text-align:center; }
    .kpi-val { font-size:1.6rem; font-weight:700; color:var(--accent); }
    .kpi-lbl { font-size:.72rem; color:var(--text-muted); margin-top:.2rem; text-transform:uppercase; letter-spacing:.05em; }
    .q-analytics-item { padding:1rem 0; border-bottom:1px solid var(--border); }
    .qa-question { font-size:.88rem; font-weight:600; color:var(--text-primary); margin-bottom:.35rem; }
    .qa-meta { font-size:.75rem; color:var(--text-muted); margin-bottom:.5rem; }
    .qa-avg { display:flex; align-items:center; gap:.75rem; font-size:.85rem; color:var(--text-secondary); }
    .score-bar-wrap { flex:1; height:6px; background:rgba(255,255,255,.1); border-radius:3px; overflow:hidden; max-width:200px; }
    .score-bar { height:100%; background:var(--accent); border-radius:3px; }
    .qa-dist { display:flex; flex-direction:column; gap:.3rem; }
    .dist-item { display:flex; align-items:center; gap:.6rem; font-size:.78rem; }
    .dist-key { width:20px; text-align:center; color:var(--text-muted); }
    .dist-bar-wrap { flex:1; height:8px; background:rgba(255,255,255,.08); border-radius:4px; overflow:hidden; }
    .dist-bar { height:100%; background:var(--accent); border-radius:4px; }
    .dist-count { width:24px; text-align:right; color:var(--text-muted); }
    .qa-yesno { display:flex; gap:.5rem; }
  `],
})
export class SurveyListComponent implements OnInit {
  private readonly svc = inject(SurveyService);

  // ── Signals ────────────────────────────────────────────────────────────────
  readonly surveys     = signal<Survey[]>([]);
  readonly clients     = signal<Client[]>([]);
  readonly departments = signal<Department[]>([]);
  readonly stats       = signal<any>(null);
  readonly loading     = signal(true);
  readonly saving      = signal(false);
  readonly sending     = signal(false);
  readonly modalError  = signal('');
  readonly sendError   = signal('');
  readonly sendSuccess = signal('');

  // ── Branding preview ──────────────────────────────────────────────────────
  showPreview = false;

  // ── File upload state ────────────────────────────────────────────────────
  readonly uploadingLogo = signal(false);
  readonly uploadingBg   = signal(false);
  readonly logoError     = signal('');
  readonly bgError       = signal('');

  uploadFile(event: Event, type: 'logo' | 'background'): void {
    const input = event.target as HTMLInputElement;
    const file  = input.files?.[0];
    if (!file) return;
    if (file.size > 2 * 1024 * 1024) {
      if (type === 'logo') this.logoError.set('File too large — max 2MB');
      else this.bgError.set('File too large — max 2MB');
      input.value = ''; return;
    }
    if (!file.type.startsWith('image/')) {
      if (type === 'logo') this.logoError.set('Only image files are allowed');
      else this.bgError.set('Only image files are allowed');
      input.value = ''; return;
    }
    if (type === 'logo') { this.uploadingLogo.set(true); this.logoError.set(''); }
    else { this.uploadingBg.set(true); this.bgError.set(''); }
    const formData = new FormData();
    formData.append('file', file);
    formData.append('type', type);
    this.svc.uploadMedia(formData).subscribe({
      next: (r: any) => {
        const url = r.data?.url ?? r.url;
        if (type === 'logo') { this.form.logo_url = url; this.uploadingLogo.set(false); }
        else { this.form.background_image = url; this.uploadingBg.set(false); }
        input.value = '';
      },
      error: (e: any) => {
        const msg = e?.error?.message ?? 'Upload failed.';
        if (type === 'logo') { this.logoError.set(msg); this.uploadingLogo.set(false); }
        else { this.bgError.set(msg); this.uploadingBg.set(false); }
        input.value = '';
      },
    });
  }

  // ── View panel ─────────────────────────────────────────────────────────
  showViewPanel   = false;
  viewSurvey: any = null;
  viewTab         = 'overview';
  readonly viewResponses = signal<any[]>([]);
  readonly viewAnalytics = signal<any>(null);
  readonly viewQuestions = signal<any[]>([]);
  readonly viewLoading   = signal(false);

  // ── Filters ────────────────────────────────────────────────────────────────
  searchText     = '';
  filterStatus   = '';
  filterAudience = '';

  // ── Pagination ───────────────────────────────────────────────────────────────
  currentPage  = 1;
  pageSize     = 10;
  readonly pageSizes = [5, 10, 25, 50];

  readonly allFiltered = computed(() =>
    this.surveys().filter(s => {
      if (this.filterStatus   && s.status        !== this.filterStatus)   return false;
      if (this.filterAudience && s.audience_type !== this.filterAudience) return false;
      if (this.searchText && !s.title.toLowerCase().includes(this.searchText.toLowerCase())) return false;
      return true;
    })
  );

  readonly filtered = computed(() => {
    const start = (this.currentPage - 1) * this.pageSize;
    return this.allFiltered().slice(start, start + this.pageSize);
  });

  readonly totalPages = computed(() =>
    Math.max(1, Math.ceil(this.allFiltered().length / this.pageSize))
  );

  readonly pageNumbers = computed(() => {
    const total = this.totalPages();
    const cur   = this.currentPage;
    const pages: (number | '...')[] = [];
    if (total <= 7) {
      for (let i = 1; i <= total; i++) pages.push(i);
    } else {
      pages.push(1);
      if (cur > 3)            pages.push('...');
      for (let i = Math.max(2, cur - 1); i <= Math.min(total - 1, cur + 1); i++) pages.push(i);
      if (cur < total - 2)    pages.push('...');
      pages.push(total);
    }
    return pages;
  });

  readonly statCards = computed(() => {
    const s = this.stats();
    if (!s) return [];
    return [
      { val: s.total, lbl: 'Total' }, { val: s.active, lbl: 'Active' },
      { val: s.customer, lbl: 'Customer' }, { val: s.internal, lbl: 'Internal' },
      { val: s.total_responses, lbl: 'Responses' }, { val: s.average_score || '—', lbl: 'Avg Score' },
    ];
  });

  // ── Modal state ────────────────────────────────────────────────────────────
  showModal = false;
  editId: number | null = null;
  form: any = this.blankForm();
  questions: SurveyQuestion[] = [];

  // ── Client multi-select (create/edit modal) ────────────────────────────────
  readonly clientSearch    = signal('');
  clientDropOpen  = false;
  readonly selectedClientIds = signal<number[]>([]);   // signal so computed() tracks changes

  readonly filteredClients = computed(() =>
    this.clients().filter(c =>
      !this.clientSearch() ||
      c.name.toLowerCase().includes(this.clientSearch().toLowerCase()) ||
      (c.contact_email ?? '').toLowerCase().includes(this.clientSearch().toLowerCase())
    )
  );

  readonly selectedClients = computed(() =>
    this.clients().filter(c => this.selectedClientIds().includes(c.id))
  );

  // ── Send-to-customers modal ────────────────────────────────────────────────
  showSendModal   = false;
  sendTarget: Survey | null = null;
  readonly sendClientIds = signal<number[]>([]);       // signal so computed() tracks changes
  readonly sendClientSearch = signal('');
  sendDropOpen    = false;
  sendEmail       = true;

  readonly filteredSendClients = computed(() =>
    this.clients().filter(c =>
      !this.sendClientSearch() ||
      c.name.toLowerCase().includes(this.sendClientSearch().toLowerCase())
    )
  );

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  ngOnInit(): void {
    this.load();
    this.svc.clients().subscribe({ next: (r: any) => this.clients.set(r.data ?? r) });
    this.svc.departments().subscribe({ next: (r: any) => this.departments.set(r.data ?? r) });
  }

  load(): void {
    this.loading.set(true);
    const p: any = {};
    if (this.filterStatus) p.status = this.filterStatus;
    if (this.filterAudience) p.audience_type = this.filterAudience;
    if (this.searchText) p.search = this.searchText;


    this.svc.list(p).subscribe({
      next: (r: any) => { this.surveys.set(r.data ?? r); this.loading.set(false); },
      error: () => this.loading.set(false),
    });
    this.svc.stats().subscribe({ next: (r: any) => this.stats.set(r.data ?? r) });
  }

  // ── Create / Edit modal ────────────────────────────────────────────────────

  openView(s: any): void {
    this.viewSurvey  = s;
    this.viewTab     = 'overview';
    this.showViewPanel = true;
    this.viewLoading.set(true);
    this.viewResponses.set([]);
    this.viewAnalytics.set(null);
    this.viewQuestions.set([]);

    this.svc.questions(s.id).subscribe({
      next: (r: any) => this.viewQuestions.set(r.data ?? r),
    });
    this.svc.responses(s.id).subscribe({
      next: (r: any) => this.viewResponses.set(r.data ?? r),
    });
    this.svc.analytics(s.id).subscribe({
      next: (r: any) => { this.viewAnalytics.set(r.data ?? r); this.viewLoading.set(false); },
      error: () => this.viewLoading.set(false),
    });
  }

  closeView(): void { this.showViewPanel = false; this.viewSurvey = null; }

    openNew(): void {
    this.editId = null;
    this.form = this.blankForm();
    this.questions = this.defaultQuestions();
    this.selectedClientIds.set([]);
    this.clientSearch.set('');
    this.clientDropOpen = false;
    this.modalError.set('');
    this.showModal = true;
  }

  openEdit(s: Survey): void {
    this.editId = s.id;
    this.form = {
      title: s.title, description: s.description ?? '',
      audience_type: s.audience_type, type: s.type,
      department_id: s.department?.id ?? '',
      start_date: s.start_date ?? '', end_date: s.end_date ?? '',
      allow_anonymous: false, send_reminder: false, reminder_days: 3,
      thank_you_message: 'Thank you for your valuable feedback!',
      logo_url:           s.logo_url           ?? '',
      background_color:   s.background_color   ?? '#0f172a',
      background_image:   s.background_image   ?? '',
      primary_color:      s.primary_color      ?? '#0ea5e9',
      header_text_color:  s.header_text_color  ?? '#f1f5f9',
      card_color:         s.card_color         ?? '#1e293b',
      font_family:        s.font_family        ?? 'system',
      language:           s.language           ?? 'en',
    };
    this.questions = [];
    this.selectedClientIds.set([]);   // reset; will be populated below from client_ids
    this.clientDropOpen = false;
    this.clientSearch.set('');
    this.modalError.set('');
    this.showModal = true;

    // Load questions — normalise options to always be string[]
    this.svc.questions(s.id).subscribe({
      next: (r: any) => {
        const raw: any[] = r.data ?? r;
        this.questions = raw.map((q: any) => ({
          id:          q.id,
          question:    q.question ?? '',
          type:        q.type ?? 'rating',
          is_required: q.is_required ?? true,
          scale_max:   q.scale_max ?? 5,
          sort_order:  q.sort_order ?? 0,
          // Normalise options: null | string | string[] → string[]
          options: Array.isArray(q.options)
            ? q.options
            : (typeof q.options === 'string' && q.options
                ? JSON.parse(q.options)
                : []),
        }));
      },
    });

    // Pre-populate selected clients from survey's client_ids JSON column
    if (s.audience_type === 'customer') {
      if (s.client_ids && s.client_ids.length > 0) {
        this.selectedClientIds.set([...s.client_ids]);
      } else if (s.client?.id) {
        this.selectedClientIds.set([s.client.id]);
      } else {
        this.selectedClientIds.set([]);
      }
    }
  }

  closeModal(): void { this.showModal = false; this.clientDropOpen = false; }

  onAudienceChange(): void {
    this.selectedClientIds.set([]);
    this.form.department_id = '';
    this.clientDropOpen = false;
    this.clientSearch.set('');
  }

  save(): void {
    if (!this.form.title?.trim()) { this.modalError.set('Title is required.'); return; }
    if (this.form.audience_type === 'internal' && !this.form.department_id) {
      this.modalError.set('Please select a department.'); return;
    }
    this.saving.set(true);
    this.modalError.set('');

    const payload: any = {
      ...this.form,
      questions: this.questions
        .filter((q: any) => q.question?.trim())
        .map((q: any, i: number) => ({
          id:          q.id ?? null,          // include id so backend updates, not recreates
          question:    q.question,
          type:        q.type,
          is_required: q.is_required,
          scale_max:   q.scale_max ?? 5,
          sort_order:  i,
          options:     (q.type === 'single_choice' || q.type === 'multi_choice')
                         ? (q.options ?? []).filter((o: string) => o?.trim())
                         : null,
        })),
    };
    if (this.form.audience_type === 'customer') {
      payload.client_ids = this.selectedClientIds();
      delete payload.department_id;
    }

    const req$ = this.editId ? this.svc.update(this.editId, payload) : this.svc.create(payload);
    req$.subscribe({
      next: () => { this.saving.set(false); this.closeModal(); this.load(); },
      error: (e: any) => {
        this.saving.set(false);
        const errs = e?.error?.errors;
        this.modalError.set(errs ? Object.values(errs).flat().join(', ') : (e?.error?.message ?? 'Failed to save.'));
      },
    });
  }

  // ── Client multi-select helpers ────────────────────────────────────────────

  toggleClient(id: number): void {
    const cur = this.selectedClientIds();
    this.selectedClientIds.set(cur.includes(id) ? cur.filter(x => x !== id) : [...cur, id]);
  }
  removeClient(id: number): void { this.selectedClientIds.update(ids => ids.filter(x => x !== id)); }
  selectAllClients(): void { this.selectedClientIds.set(this.filteredClients().map(c => c.id)); }
  clearAllClients(): void  { this.selectedClientIds.set([]); this.clientSearch.set(''); }
  isClientSel(id: number): boolean { return this.selectedClientIds().includes(id); }

  clientSelectionLabel(): string {
    const ids = this.selectedClientIds();
    if (ids.length === 0) return 'Select clients…';
    if (ids.length === 1) return this.clients().find(c => c.id === ids[0])?.name ?? '1 client selected';
    return `${ids.length} clients selected`;
  }

  // ── Questions ──────────────────────────────────────────────────────────────

  addQuestion(): void    { this.questions.push({ question: '', type: 'rating', is_required: true, options: [] }); }

  addOption(questionIndex: number): void {
    const q = this.questions[questionIndex];
    if (!q.options) q.options = [];
    q.options.push('');   // mutate in-place — preserves focus context
    // Auto-focus the new input after Angular renders it
    setTimeout(() => {
      const blocks = document.querySelectorAll('.q-block');
      const block  = blocks[questionIndex];
      if (!block) return;
      const inputs = block.querySelectorAll<HTMLInputElement>('.q-opt-inp');
      const last   = inputs[inputs.length - 1];
      if (last) last.focus();
    }, 30);
  }

  updateOption(questionIndex: number, optionIndex: number, value: string): void {
    const q = this.questions[questionIndex];
    if (!q.options) return;
    // Mutate in-place — do NOT recreate the array reference
    // Recreating the array causes *ngFor to destroy/recreate DOM nodes → focus lost
    q.options[optionIndex] = value;
  }

  removeOption(questionIndex: number, optionIndex: number): void {
    const q = this.questions[questionIndex];
    if (!q.options) return;
    q.options.splice(optionIndex, 1);  // mutate in-place
    // Focus previous input after removal
    setTimeout(() => {
      const blocks = document.querySelectorAll('.q-block');
      const block  = blocks[questionIndex];
      if (!block) return;
      const inputs = block.querySelectorAll<HTMLInputElement>('.q-opt-inp');
      const target = inputs[Math.max(0, optionIndex - 1)];
      if (target) target.focus();
    }, 30);
  }
  removeQuestion(i: number): void { this.questions.splice(i, 1); }

  defaultQuestions(): SurveyQuestion[] {
    return [
      { question: 'Overall, how satisfied are you with our service?', type: 'rating', is_required: true },
      { question: '', type: 'rating', is_required: true },
      { question: '', type: 'rating', is_required: true },
      { question: '', type: 'nps',    is_required: true },
      { question: '', type: 'text',   is_required: false },
    ];
  }

  // ── Survey actions ─────────────────────────────────────────────────────────

  activate(s: Survey):    void { this.svc.activate(s.id).subscribe({ next: () => this.load() }); }
  pause(s: Survey):       void { this.svc.pause(s.id).subscribe({ next: () => this.load() }); }
  closeSurvey(s: Survey): void { this.svc.close(s.id).subscribe({ next: () => this.load() }); }
  deleteSurvey(s: Survey): void {
    if (!confirm(`Delete "${s.title}"?`)) return;
    this.svc.delete(s.id).subscribe({ next: () => this.load() });
  }

  // ── Send-to-customers modal ────────────────────────────────────────────────

  openSendModal(s: Survey): void {
    this.sendTarget = s;
    this.sendClientIds.set([]);
    this.sendClientSearch.set('');
    this.sendDropOpen = false;
    this.sendEmail = true;
    this.sendError.set('');
    this.sendSuccess.set('');
    this.showSendModal = true;
  }

  closeSendModal(): void { this.showSendModal = false; this.sendTarget = null; }

  toggleSend(id: number): void {
    const cur = this.sendClientIds();
    this.sendClientIds.set(cur.includes(id) ? cur.filter(x => x !== id) : [...cur, id]);
  }
  isSendSel(id: number): boolean { return this.sendClientIds().includes(id); }
  selectAllSendClients(): void { this.sendClientIds.set(this.filteredSendClients().map(c => c.id)); }
  clearSendClients(): void        { this.sendClientIds.set([]); this.sendClientSearch.set(''); }

  doSend(): void {
    if (!this.sendTarget) return;
    this.sending.set(true);
    this.sendError.set('');
    this.sendSuccess.set('');
    this.svc.sendToCustomers(this.sendTarget.id, this.sendClientIds(), this.sendEmail).subscribe({
      next: (r: any) => { this.sending.set(false); this.sendSuccess.set(r.data?.message ?? 'Survey sent!'); this.load(); },
      error: (e: any) => { this.sending.set(false); this.sendError.set(e?.error?.message ?? 'Failed to send.'); },
    });
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  statusClass(s: string): string {
    return ({ active:'bdg-green', draft:'bdg-gray', paused:'bdg-yellow', closed:'bdg-red' } as any)[s] ?? 'bdg-gray';
  }

  responseRate(s: Survey): string {
    return s.total_sent ? Math.round((s.total_responses / s.total_sent) * 100) + '%' : '—';
  }

  goToPage(p: number | '...'): void {
    if (p === '...') return;
    this.currentPage = Math.max(1, Math.min(p, this.totalPages()));
  }

  onPageSizeChange(): void {
    this.currentPage = 1;
  }

  resetPage(): void { this.currentPage = 1;  this.load();    }

  onBackdrop(e: MouseEvent, fn: () => void): void {
    if ((e.target as HTMLElement).classList.contains('backdrop')) fn();
  }

  distributionEntries(dist: Record<string, number> | undefined): { key: string; val: number }[] {
    if (!dist) return [];
    return Object.entries(dist).map(([key, val]) => ({ key, val: Number(val) }));
  }

  trackByIndex(index: number): number { return index; }

  getQuestion(questionId: number): string {
    const q = this.viewQuestions().find(q => q.id === questionId);
    return q?.question ?? 'Question #' + questionId;
  }

    private blankForm(): any {
    return {
      title: '', description: '', audience_type: 'internal', type: 'csat',
      department_id: '', start_date: '', end_date: '',
      allow_anonymous: false, send_reminder: false, reminder_days: 3,
      thank_you_message: 'Thank you for your valuable feedback!',
      logo_url: '', background_color: '#0f172a', background_image: '',
      primary_color: '#0ea5e9', header_text_color: '#f1f5f9',
      card_color: '#1e293b', font_family: 'system', language: 'en',
    };
  }
}
