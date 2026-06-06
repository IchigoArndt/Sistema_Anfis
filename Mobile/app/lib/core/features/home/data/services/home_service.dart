import 'package:sistema_distribuido/core/features/avaliacoes/data/models/assessment_model.dart';
import 'package:sistema_distribuido/core/features/avaliacoes/data/services/avaliacoes_service.dart';
import 'package:sistema_distribuido/core/features/avaliacoes/domain/entities/assessment.dart';
import 'package:sistema_distribuido/core/features/perfil/data/services/perfil_service.dart';

class HomeService {
  final AvaliacoesService _avaliacoesService;
  final PerfilService _perfilService;

  HomeService(this._avaliacoesService, this._perfilService);

  Future<AssessmentModel?> getProximaAvaliacao() async {
    final assessments = await _avaliacoesService.getAssessments();
    final pending = assessments
        .where((a) => a.status == AssessmentStatus.pending)
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    return pending.isEmpty ? null : pending.first;
  }

  Future<({double? weight, double? imc})> getLastMetrics() async {
    final assessments = await _avaliacoesService.getAssessments();
    final completed = assessments
        .where((a) =>
            a.status == AssessmentStatus.completed &&
            a.bodyComposition != null)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    if (completed.isEmpty) return (weight: null, imc: null);

    final last = completed.first;
    final imcValue = last.imc != null ? double.tryParse(last.imc!) : null;
    return (weight: last.bodyComposition?.weight, imc: imcValue);
  }
}
