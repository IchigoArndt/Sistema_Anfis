import { Profissional } from '../../domain/entities/profissional.entity';

export interface ProfissionalModel {
  id: number;
  name: string;
  email: string;
  phone: string;
  cref: string;
  bio?: string;
  status?: number;
  password?: string;
  specialty?: string;
  methodology?: string;
  price?: number;
  experience?: string;
}

export function toProfissionalEntity(model: ProfissionalModel): Profissional {
  return {
    id: model.id,
    nome: model.name,
    email: model.email,
    telefone: model.phone,
    cref: model.cref,
    bio: model.bio,
    status: model.status !== undefined
      ? (model.status === 1 ? 'Ativo' : 'Inativo')
      : undefined,
    specialty: model.specialty,
    methodology: model.methodology,
    price: model.price,
    experience: model.experience,
  };
}

export function toProfissionalModel(entity: Omit<Profissional, 'id'>): Omit<ProfissionalModel, 'id'> {
  return {
    name: entity.nome,
    email: entity.email,
    phone: entity.telefone.replace(/\D/g, ''),
    cref: entity.cref,
    bio: entity.bio,
    status: entity.status === 'Ativo' ? 1 : entity.status === 'Inativo' ? 2 : undefined,
    password: entity.senha,
    specialty: entity.specialty,
    methodology: entity.methodology,
    price: entity.price,
    experience: entity.experience,
  };
}
