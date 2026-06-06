import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sistema_distribuido/core/features/avaliacoes/data/models/assessment_model.dart';
import 'package:sistema_distribuido/core/features/avaliacoes/domain/entities/assessment.dart';

class HomeNextEvaluationFromAssessment extends StatelessWidget {
  final AssessmentModel assessment;
  const HomeNextEvaluationFromAssessment({super.key, required this.assessment});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd/MM/yyyy').format(assessment.date);
    final typeName = _typeLabel(assessment.typeAvaliation);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Próxima Avaliação',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  assessment.professionalName ?? 'Profissional',
                  style: const TextStyle(
                    color: Color(0xFFD32F2F),
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  dateStr,
                  style: const TextStyle(
                    color: Color(0xFFE57373),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  typeName,
                  style: const TextStyle(
                    color: Color(0xFFE57373),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _typeLabel(TypeAvaliation type) {
    switch (type) {
      case TypeAvaliation.basic:
        return 'Avaliação Básica';
      case TypeAvaliation.complete:
        return 'Avaliação Completa';
      case TypeAvaliation.revaluation:
        return 'Reavaliação';
    }
  }
}
