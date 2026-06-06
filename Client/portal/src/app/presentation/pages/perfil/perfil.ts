import { Component, OnInit } from '@angular/core';
import { FormsModule } from '@angular/forms';
import { ButtonModule } from 'primeng/button';
import { InputTextModule } from 'primeng/inputtext';
import { TextareaModule } from 'primeng/textarea';
import { AvatarModule } from 'primeng/avatar';
import { DividerModule } from 'primeng/divider';
import { ProgressSpinnerModule } from 'primeng/progressspinner';
import { Profissional } from '../../../domain/entities/profissional.entity';
import { GetProfissionaisUseCase } from '../../../domain/usecases/profissional/get-profissionais.usecase';
import { UpdateProfissionalUseCase } from '../../../domain/usecases/profissional/update-profissional.usecase';
import { AuthService } from '../../../core/services/auth.service';

@Component({
  selector: 'app-perfil',
  imports: [
    FormsModule, ButtonModule, InputTextModule,
    TextareaModule, AvatarModule, DividerModule, ProgressSpinnerModule
  ],
  templateUrl: './perfil.html',
  styleUrl: './perfil.scss'
})
export class PerfilComponent implements OnInit {
  profissional: Profissional = { id: 0, nome: '', email: '', telefone: '', cref: '' };
  loading = true;
  saving = false;
  error: string | null = null;

  constructor(
    private readonly authService: AuthService,
    private readonly getProfissionaisUseCase: GetProfissionaisUseCase,
    private readonly updateProfissionalUseCase: UpdateProfissionalUseCase
  ) {}

  ngOnInit(): void {
    const entityId = this.authService.getEntityId();
    if (!entityId) {
      this.error = 'Sessão inválida. Faça login novamente.';
      this.loading = false;
      return;
    }

    this.getProfissionaisUseCase.execute().subscribe({
      next: (lista) => {
        const found = lista.find(p => p.id === entityId);
        if (found) this.profissional = found;
        else this.error = 'Perfil não encontrado.';
        this.loading = false;
      },
      error: () => {
        this.error = 'Erro ao carregar perfil.';
        this.loading = false;
      }
    });
  }

  getAvatar(): string {
    return this.profissional.nome?.charAt(0).toUpperCase() ?? '?';
  }

  save(): void {
    this.saving = true;
    this.updateProfissionalUseCase.execute(this.profissional.id, this.profissional).subscribe({
      next: (updated) => {
        this.profissional = updated;
        this.saving = false;
      },
      error: () => {
        this.saving = false;
      }
    });
  }
}
