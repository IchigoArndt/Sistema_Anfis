import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { Observable, of } from 'rxjs';
import { delay } from 'rxjs/operators';

const TOKEN_KEY = 'token';

// Credenciais fake para desenvolvimento — remover ao integrar o backend real
const FAKE_USERS: Record<string, { name: string; role: string; password: string }> = {
  'admin@fitportal.com': { name: 'Admin FitPortal', role: 'Admin', password: 'admin123' },
  'user@fitportal.com':  { name: 'Usuário FitPortal', role: 'User',  password: 'user123'  },
};

function buildFakeToken(email: string, name: string, role: string): string {
  const header  = btoa(JSON.stringify({ alg: 'none', typ: 'JWT' }));
  const payload = btoa(JSON.stringify({ sub: email, name, email, role, exp: 9999999999 }));
  return `${header}.${payload}.fake`;
}

@Injectable({ providedIn: 'root' })
export class AuthService {
  private _isAuthenticated = false;
  private _token: string | null = null;

  constructor(private readonly router: Router) {}

  login(email: string, password: string): Observable<boolean> {
    const user = FAKE_USERS[email.toLowerCase()];
    const success = !!user && user.password === password;

    if (success) {
      const token = buildFakeToken(email, user.name, user.role);
      this._isAuthenticated = true;
      this._token = token;
      this.setToken(token);
    }

    // Simula latência de rede (800 ms) para o spinner aparecer
    return of(success).pipe(delay(800));
  }

  logout(): void {
    this.clearAuthState();
    this.router.navigate(['/login']);
  }

  isLoggedIn(): boolean {
    return this._isAuthenticated || !!this._token || !!this.getToken();
  }

  private setToken(token: string): void {
    localStorage.setItem(TOKEN_KEY, token);
    sessionStorage.removeItem(TOKEN_KEY);
  }

  private getToken(): string | null {
    return localStorage.getItem(TOKEN_KEY) ?? sessionStorage.getItem(TOKEN_KEY);
  }

  private clearAuthState(): void {
    this._isAuthenticated = false;
    this._token = null;
    localStorage.removeItem(TOKEN_KEY);
    sessionStorage.removeItem(TOKEN_KEY);
  }

  getRole(): string | null {
    const token = this.getToken();
    if (!token) return null;

    try {
      const parts = token.split('.');
      if (parts.length !== 3) return null;
      const payload = JSON.parse(atob(parts[1]));
      const roles = payload.role ?? payload.roles ?? payload['http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];
      if (!roles) return null;
      if (Array.isArray(roles)) return roles[0];
      return roles;
    } catch {
      return null;
    }
  }
}
