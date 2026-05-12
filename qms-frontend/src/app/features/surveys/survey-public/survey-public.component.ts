// src/app/features/surveys/components/survey-public/survey-public.component.ts
import {
  ChangeDetectionStrategy,
  Component,
  OnDestroy,
  OnInit,
  inject,
  signal,
} from '@angular/core';
import { ActivatedRoute, RouterLink } from '@angular/router';
import { NgFor, NgIf, NgClass } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { SurveyService } from '@app/core/services/survey.service';

interface SurveyQuestion {
  id: number;
  question: string;
  type: 'rating' | 'nps' | 'text' | 'single_choice' | 'multi_choice' | 'yes_no';
  options: string[] | null;
  scale_max: number;
  is_required: boolean;
  sort_order: number;
}

interface SurveyData {
  id: number;
  title: string;
  description: string;
  type: string;
  questions: SurveyQuestion[];
}

/**
 * SurveyPublicComponent
 *
 * Customer-facing survey page. Accessed via /survey/:token — no login required.
 * Add route to app.routes.ts:
 *   { path: 'survey/:token', component: SurveyPublicComponent }
 *
 * @standalone true
 */
@Component({
  selector: 'app-survey-public',
  standalone: true,
  imports: [NgIf, NgFor, NgClass, FormsModule, RouterLink],
  changeDetection: ChangeDetectionStrategy.OnPush,
  template: `
    <div class="survey-page">
      <div class="survey-wrapper">

        <!-- Loading -->
        <div class="survey-loading" *ngIf="loading()">
          <div class="spinner"></div>
          <p>Loading survey…</p>
        </div>

        <!-- Error / Expired -->
        <div class="survey-error-card" *ngIf="errorMessage() && !loading()">
          <div class="error-icon">⚠️</div>
          <h2>{{ errorMessage() }}</h2>
          <p class="error-sub">If you believe this is an error, please contact Diamond Insurance Brokers.</p>
        </div>

        <!-- Thank You (submitted) -->
        <div class="survey-thanks" *ngIf="submitted() && !loading()">
          <div class="thanks-icon">✅</div>
          <h2>Thank you for your feedback!</h2>
          <p>Your response has been recorded and will help us improve our service.</p>
          <p class="thanks-company">— Diamond Insurance Brokers Quality Team</p>
        </div>

        <!-- Survey Form -->
        <div class="survey-card" *ngIf="survey() && !submitted() && !loading() && !errorMessage()">

          <!-- Header -->
          <div class="survey-header">
            <div class="survey-logo">◈ Diamond QMS</div>
            <h1 class="survey-title">{{ survey()!.title }}</h1>
            <p class="survey-desc" *ngIf="survey()!.description">{{ survey()!.description }}</p>
            <p class="survey-greeting" *ngIf="recipientName">Hello, <strong>{{ recipientName }}</strong></p>
          </div>

          <!-- Questions -->
          <div class="questions-list">
            <div
              class="question-block"
              *ngFor="let q of survey()!.questions; let i = index">

              <div class="question-label">
                <span class="q-num">{{ i + 1 }}</span>
                {{ q.question }}
                <span class="required-dot" *ngIf="q.is_required" title="Required">*</span>
              </div>

              <!-- Rating (star scale) -->
              <div class="rating-row" *ngIf="q.type === 'rating'">
                <button
                  *ngFor="let n of scale(q.scale_max)"
                  class="star-btn"
                  [class.active]="(answers[q.id]?.score ?? -1) >= n"
                  (click)="setRating(q.id, n)"
                  [attr.aria-label]="n + ' out of ' + q.scale_max">
                  ★
                </button>
                <span class="rating-label" *ngIf="answers[q.id]?.score">
                  {{ answers[q.id]?.score }}/{{ q.scale_max }}
                </span>
              </div>

              <!-- NPS (0–10) -->
              <div class="nps-row" *ngIf="q.type === 'nps'">
                <div class="nps-labels">
                  <span>Not likely</span>
                  <span>Extremely likely</span>
                </div>
                <div class="nps-buttons">
                  <button
                    *ngFor="let n of npsScale()"
                    class="nps-btn"
                    [class.active]="(answers[q.id]?.score ?? -1) === n"
                    [class.promoter]="n >= 9 && (answers[q.id]?.score ?? -1) === n"
                    [class.passive]="n >= 7 && n <= 8 && (answers[q.id]?.score ?? -1) === n"
                    [class.detractor]="n <= 6 && (answers[q.id]?.score ?? -1) === n"
                    (click)="setRating(q.id, n)">
                    {{ n }}
                  </button>
                </div>
              </div>

              <!-- Yes/No -->
              <div class="yesno-row" *ngIf="q.type === 'yes_no'">
                <button class="yn-btn" [class.active]="answers[q.id]?.answer === 'yes'" (click)="setAnswer(q.id, 'yes')">👍 Yes</button>
                <button class="yn-btn" [class.active]="answers[q.id]?.answer === 'no'"  (click)="setAnswer(q.id, 'no')">👎 No</button>
              </div>

              <!-- Single choice -->
              <div class="choice-list" *ngIf="q.type === 'single_choice'">
                <div class="no-options" *ngIf="!q.options || q.options.length === 0">No options configured for this question.</div>
                <label class="choice-item" *ngFor="let opt of (q.options || [])">
                  <input type="radio" [name]="'q_' + q.id" [value]="opt" [ngModel]="answers[q.id]?.answer" (ngModelChange)="setAnswer(q.id, $event)">
                  <span>{{ opt }}</span>
                </label>
              </div>

              <!-- Multi choice -->
              <div class="choice-list" *ngIf="q.type === 'multi_choice'">
                <div class="no-options" *ngIf="!q.options || q.options.length === 0">No options configured for this question.</div>
                <label class="choice-item" *ngFor="let opt of (q.options || [])">
                  <input type="checkbox" [value]="opt" [checked]="isChecked(q.id, opt)" (change)="toggleChoice(q.id, opt)">
                  <span>{{ opt }}</span>
                </label>
              </div>

              <!-- Text -->
              <textarea
                *ngIf="q.type === 'text'"
                class="text-answer"
                rows="3"
                [placeholder]="q.is_required ? 'Your answer (required)…' : 'Your answer (optional)…'"
                [(ngModel)]="textAnswers[q.id]"
                (input)="setAnswer(q.id, textAnswers[q.id])"
                maxlength="2000">
              </textarea>

              <!-- Validation error -->
              <div class="q-error" *ngIf="validationErrors[q.id]">
                {{ validationErrors[q.id] }}
              </div>

            </div>
          </div>

          <!-- Comments -->
          <div class="comments-block">
            <label class="question-label">Any additional comments? <span class="optional">(optional)</span></label>
            <textarea class="text-answer" rows="3" [(ngModel)]="comments" placeholder="Additional feedback…" maxlength="2000"></textarea>
          </div>

          <!-- Submit error -->
          <div class="submit-error" *ngIf="submitError()">⚠️ {{ submitError() }}</div>

          <!-- Submit button -->
          <div class="submit-row">
            <button class="btn-submit" (click)="submit()" [disabled]="submitting()">
              <span *ngIf="submitting()">⏳ Submitting…</span>
              <span *ngIf="!submitting()">Submit Feedback →</span>
            </button>
          </div>

          <p class="survey-footer">Diamond Insurance Brokers — Quality Management System</p>
        </div>

      </div>
    </div>
  `,
  styles: [`
    :host {
      display: block;
      min-height: 100vh;
      overflow-y: auto;
    }

    .survey-page {
      min-height: 100vh;
      background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
      display: flex; align-items: flex-start; justify-content: center;
      padding: 2rem 1rem 5rem;
      font-family: 'Segoe UI', system-ui, sans-serif;
    }

    .survey-wrapper { width: 100%; max-width: 680px; padding-bottom: 2rem; }

    .survey-loading, .survey-error-card, .survey-thanks {
      text-align: center; padding: 4rem 2rem;
      color: #cbd5e1;
    }

    .spinner {
      width: 40px; height: 40px;
      border: 3px solid #334155; border-top-color: #0ea5e9;
      border-radius: 50%; animation: spin 0.8s linear infinite;
      margin: 0 auto 1rem;
    }
    @keyframes spin { to { transform: rotate(360deg); } }

    .error-icon, .thanks-icon { font-size: 3rem; margin-bottom: 1rem; }
    .error-sub { color: #64748b; font-size: 0.875rem; margin-top: 0.5rem; }
    .thanks-company { color: #0ea5e9; margin-top: 1.5rem; font-style: italic; }

    .survey-card {
      background: #1e293b;
      border: 1px solid #334155;
      border-radius: 16px;
      box-shadow: 0 25px 60px rgba(0,0,0,0.5);
    }

    .survey-header {
      background: linear-gradient(135deg, #0f172a, #1a2540);
      padding: 2rem 2rem 1.5rem;
      border-bottom: 1px solid #334155;
    }

    .survey-logo { color: #0ea5e9; font-size: 0.85rem; font-weight: 700; margin-bottom: 1rem; letter-spacing: 0.1em; }
    .survey-title { font-size: 1.5rem; font-weight: 700; color: #f1f5f9; margin: 0 0 0.5rem; }
    .survey-desc { color: #94a3b8; font-size: 0.9rem; margin: 0 0 0.75rem; line-height: 1.6; }
    .survey-greeting { color: #94a3b8; font-size: 0.875rem; margin: 0; }

    .questions-list { padding: 1.5rem 2rem; display: flex; flex-direction: column; gap: 2rem; }

    .question-block { display: flex; flex-direction: column; gap: 0.75rem; }

    .question-label {
      font-size: 0.95rem; font-weight: 600; color: #e2e8f0;
      display: flex; align-items: flex-start; gap: 0.5rem; line-height: 1.5;
    }

    .q-num {
      min-width: 24px; height: 24px;
      background: #0ea5e9; color: #fff;
      border-radius: 50%; display: flex; align-items: center; justify-content: center;
      font-size: 0.72rem; font-weight: 700; flex-shrink: 0; margin-top: 1px;
    }

    .required-dot { color: #f87171; margin-left: 2px; }
    .optional { color: #64748b; font-weight: 400; font-size: 0.82rem; }

    /* Rating stars */
    .rating-row { display: flex; align-items: center; gap: 0.5rem; padding-left: 2rem; }
    .star-btn {
      background: none; border: none; font-size: 2rem; cursor: pointer;
      color: #334155; transition: color 0.15s, transform 0.1s;
      &:hover, &.active { color: #f59e0b; }
      &:not(:disabled):active { transform: scale(0.9); }
    }
    .rating-label { font-size: 0.82rem; color: #64748b; margin-left: 0.5rem; }

    /* NPS */
    .nps-row { padding-left: 2rem; }
    .nps-labels { display: flex; justify-content: space-between; font-size: 0.72rem; color: #64748b; margin-bottom: 0.5rem; }
    .nps-buttons { display: flex; gap: 0.35rem; flex-wrap: wrap; }
    .nps-btn {
      width: 40px; height: 40px; border-radius: 8px;
      border: 1px solid #334155; background: #0f172a; color: #94a3b8;
      font-size: 0.85rem; font-weight: 600; cursor: pointer;
      transition: all 0.15s;
      &:hover { border-color: #0ea5e9; color: #0ea5e9; }
      &.promoter  { background: #14532d; border-color: #22c55e; color: #22c55e; }
      &.passive   { background: #713f12; border-color: #f59e0b; color: #f59e0b; }
      &.detractor { background: #7f1d1d; border-color: #ef4444; color: #ef4444; }
    }

    /* Yes/No */
    .yesno-row { display: flex; gap: 1rem; padding-left: 2rem; }
    .yn-btn {
      padding: 0.6rem 1.5rem; border-radius: 8px;
      border: 1px solid #334155; background: #0f172a; color: #94a3b8;
      font-size: 0.9rem; cursor: pointer; transition: all 0.15s;
      &:hover { border-color: #0ea5e9; }
      &.active { background: rgba(14,165,233,0.15); border-color: #0ea5e9; color: #0ea5e9; }
    }

    /* Choices */
    .choice-list { display: flex; flex-direction: column; gap: 0.5rem; padding-left: 2rem; }
    .choice-item {
      display: flex; align-items: center; gap: 0.6rem;
      padding: 0.5rem 0.75rem; border-radius: 6px; cursor: pointer;
      border: 1px solid transparent; font-size: 0.875rem; color: #cbd5e1;
      &:hover { background: rgba(255,255,255,0.05); }
      input { cursor: pointer; }
    }

    /* Text */
    .text-answer {
      width: 100%; padding: 0.75rem; border-radius: 8px;
      border: 1px solid #334155; background: #0f172a; color: #e2e8f0;
      font-size: 0.875rem; font-family: inherit; resize: vertical;
      box-sizing: border-box;
      &:focus { outline: none; border-color: #0ea5e9; box-shadow: 0 0 0 3px rgba(14,165,233,0.15); }
    }

    .q-error { font-size: 0.75rem; color: #f87171; padding-left: 2rem; }

    .comments-block { padding: 0 2rem 1.5rem; }

    .submit-error {
      margin: 0 2rem; padding: 0.75rem 1rem;
      background: rgba(239,68,68,0.1); border: 1px solid rgba(239,68,68,0.3);
      border-radius: 8px; color: #f87171; font-size: 0.85rem;
    }

    .submit-row { padding: 1.5rem 2rem 2rem; }
    .btn-submit {
      width: 100%; padding: 0.875rem;
      background: linear-gradient(135deg, #0ea5e9, #0284c7);
      color: #fff; border: none; border-radius: 10px;
      font-size: 1rem; font-weight: 700; cursor: pointer;
      transition: opacity 0.15s, transform 0.1s;
      &:hover:not(:disabled) { opacity: 0.9; }
      &:active:not(:disabled) { transform: scale(0.99); }
      &:disabled { opacity: 0.5; cursor: not-allowed; }
    }

    .survey-footer {
      text-align: center; padding: 1rem; font-size: 0.72rem;
      color: #475569; border-top: 1px solid #334155;
    }

    @media (max-width: 480px) {
      .survey-page { padding: 0; }
      .survey-card { border-radius: 0; }
      .questions-list, .survey-header { padding: 1.25rem; }
    }
  `],
})
export class SurveyPublicComponent implements OnInit, OnDestroy {
  private readonly route   = inject(ActivatedRoute);
  private readonly svc     = inject(SurveyService);

  readonly loading    = signal(true);
  readonly submitted  = signal(false);
  readonly submitting = signal(false);
  readonly survey     = signal<SurveyData | null>(null);
  readonly errorMessage = signal('');
  readonly submitError  = signal('');

  recipientName = '';
  comments      = '';
  answers: { [key: number]: { answer: any; score?: number } } = {};
  textAnswers:  Record<number, string>   = {};
  validationErrors: Record<number, string> = {};

  ngOnInit(): void {
    // Ensure body scrolls — the layout component may set overflow:hidden on body
    document.body.style.overflow = 'auto';
    document.documentElement.style.overflow = 'auto';
    const token = this.route.snapshot.paramMap.get('token') ?? '';
    this.svc.publicGetSurvey(token).subscribe({
      next: (res: any) => {
        this.survey.set(res.data.survey);
        this.recipientName = res.data.recipient_name ?? '';
        // Initialise answers map
        res.data.survey.questions.forEach((q: SurveyQuestion) => {
          this.answers[q.id] = { answer: q.type === 'multi_choice' ? [] : null };
          this.textAnswers[q.id] = '';
        });
        this.loading.set(false);
      },
      error: (e: any) => {
        this.errorMessage.set(e?.error?.message ?? 'Survey not found or has expired.');
        this.loading.set(false);
      },
    });
  }

  scale(max: number): number[] {
    return Array.from({ length: max }, (_, i) => i + 1);
  }

  npsScale(): number[] {
    return Array.from({ length: 11 }, (_, i) => i);
  }

  setRating(questionId: number, score: number): void {
    this.answers[questionId] = { answer: score, score };
    delete this.validationErrors[questionId];
  }

  setAnswer(questionId: number, value: any): void {
    this.answers[questionId] = { answer: value };
    delete this.validationErrors[questionId];
  }

  isChecked(questionId: number, opt: string): boolean {
    const a = this.answers[questionId];
    if (!a) return false;
    return Array.isArray(a.answer) && (a.answer as string[]).includes(opt);
  }

  toggleChoice(questionId: number, opt: string): void {
    const a = this.answers[questionId];
    const current: string[] = (a && Array.isArray(a.answer)) ? [...(a.answer as string[])] : [];
    const idx = current.indexOf(opt);
    if (idx > -1) current.splice(idx, 1); else current.push(opt);
    this.answers[questionId] = { answer: current };
    delete this.validationErrors[questionId];
  }

  ngOnDestroy(): void {
    document.body.style.overflow = '';
    document.documentElement.style.overflow = '';
  }

  submit(): void {
    const s = this.survey();
    if (!s) return;

    this.validationErrors = {};
    this.submitError.set('');
    let valid = true;

    // Validate required questions
    for (const q of s.questions) {
      if (!q.is_required) continue;
      const a = this.answers[q.id];
      const isEmpty = !a?.answer ||
        (Array.isArray(a.answer) && a.answer.length === 0) ||
        (typeof a.answer === 'string' && !a.answer.trim()) ||
        (q.type === 'text' && !this.textAnswers[q.id]?.trim());

      if (isEmpty) {
        this.validationErrors[q.id] = 'This question is required.';
        valid = false;
      }
    }

    if (!valid) {
      this.submitError.set('Please answer all required questions before submitting.');
      return;
    }

    // Build payload
    const payload = {
      answers: s.questions.map(q => {
        const a: { answer: any; score?: number } | undefined = this.answers[q.id];
        const answer = q.type === 'text' ? this.textAnswers[q.id] : (a ? a.answer : null);
        return {
          question_id: q.id,
          answer,
          score: a ? (a.score ?? (typeof answer === 'number' ? answer : undefined)) : undefined,
        };
      }),
      comments: this.comments,
    };

    const token = this.route.snapshot.paramMap.get('token') ?? '';
    this.submitting.set(true);

    this.svc.publicSubmit(token, payload).subscribe({
      next: () => {
        this.submitting.set(false);
        this.submitted.set(true);
      },
      error: (e: any) => {
        this.submitting.set(false);
        this.submitError.set(e?.error?.message ?? 'Submission failed. Please try again.');
      },
    });
  }
}
