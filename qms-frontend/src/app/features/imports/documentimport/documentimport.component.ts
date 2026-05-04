import { Component } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'document-import',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <div style="max-width:400px">

      <input type="file" (change)="onFileChange($event)" />

      <br><br>

      <button (click)="upload()" [disabled]="loading">
        {{ loading ? 'Uploading...' : 'Upload' }}
      </button>

      <p *ngIf="message">{{ message }}</p>
      <p *ngIf="error" style="color:red">{{ error }}</p>

    </div>
  `
})
export class DocumentimportComponent {

  selectedFile!: File;
  message = '';
  error = '';
  loading = false;

  constructor(private http: HttpClient) {}

  onFileChange(event: any) {
    const file = event.target.files[0];

    if (!file) return;

    // ✅ Validate file type
    const allowedTypes = [
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', // xlsx
      'text/csv'
    ];

    if (!allowedTypes.includes(file.type)) {
      this.error = 'Only Excel (.xlsx) or CSV files are allowed';
      this.selectedFile = undefined as any;
      return;
    }

    this.selectedFile = file;
    this.error = '';
    this.message = '';
  }

  upload() {
    if (!this.selectedFile) {
      this.error = 'Please select a file';
      return;
    }

    const formData = new FormData();
    formData.append('file', this.selectedFile);

    this.loading = true;
    this.message = '';
    this.error = '';

    

      this.http.post('http://localhost:8084/api/document/documentimport', formData)
      .subscribe({
        next: (res: any) => {
          this.message = `✅ Inserted: ${res.inserted}, Skipped: ${res.skipped}`;
          this.loading = false;
        },
        error: (err: any) => {
          this.error = err?.error?.message || 'Upload failed';
          this.loading = false;
          console.error(err);
        }
      });



  }
}