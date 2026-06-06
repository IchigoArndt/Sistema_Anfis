import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { Profissional } from '../../entities/profissional.entity';
import { ProfissionalRepository } from '../../repositories/profissional.repository';

@Injectable({ providedIn: 'root' })
export class UpdateProfissionalUseCase {
  constructor(private readonly profissionalRepository: ProfissionalRepository) {}

  execute(id: number, profissional: Partial<Profissional>): Observable<Profissional> {
    return this.profissionalRepository.update(id, profissional);
  }
}
