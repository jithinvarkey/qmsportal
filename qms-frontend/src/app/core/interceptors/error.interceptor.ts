import { HttpInterceptorFn, HttpErrorResponse } from '@angular/common/http';
import { inject } from '@angular/core';
import { Router } from '@angular/router';
import { catchError, throwError } from 'rxjs';

export const errorInterceptor: HttpInterceptorFn = (req, next) => {
  const router = inject(Router);

  return next(req).pipe(
    catchError((err: HttpErrorResponse) => {
      const token = localStorage.getItem('qms_token');

      if (err.status === 401 && token && req.url.includes('/auth/me')) {
        // ✅ clear session manually (NO AuthService)
        localStorage.removeItem('qms_token');
        localStorage.removeItem('qms_user');

        router.navigate(['/login']);
      }

      return throwError(() => err);
    })
  );
};