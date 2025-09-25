import 'package:flutter/material.dart';
import 'package:school_app/dto/evaluation_dto.dart';
import 'package:school_app/model/model_evaluation.dart';
import 'package:school_app/theme/color.dart';

class EvaluationCard extends StatelessWidget {
  final EvaluationDTO evaluation;

  const EvaluationCard({Key? key, required this.evaluation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: _getTypeColor(evaluation.type ?? ''),
              width: 6,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec type et date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTypeBadge(evaluation.type ?? 'Non spécifié'),
                  Text(
                    _formatDate((evaluation.dateEvaluation ?? '').toString()),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: myredColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Module
              _buildInfoRow(
                Icons.school,
                'Module:',
                evaluation.nomModule ?? 'Non spécifié',
              ),

              // Professeur
              _buildInfoRow(
                Icons.person,
                'Professeur:',
                '${evaluation.prenomProf ?? ''} ${evaluation.nomProf ?? ''}'
                    .trim(),
              ),

              // Horaires
              _buildInfoRow(
                Icons.access_time,
                'Horaire:',
                '${_formatTime(evaluation.heureDebut ?? '')} - ${_formatTime(evaluation.heureFin ?? '')}',
              ),

              // Durée
              _buildInfoRow(
                Icons.timer,
                'Durée:',
                _calculateDuration(evaluation.heureDebut, evaluation.heureFin),
              ),

              // Nombre de notes
              // if (evaluation.notes?.isNotEmpty ?? false) ...[
              //   const SizedBox(height: 8),
              //   Container(
              //     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              //     decoration: BoxDecoration(
              //       color: Colors.green.shade50,
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //     child: Text(
              //       '${evaluation.notes?.length ?? 0} note(s) disponible(s)',
              //       style: const TextStyle(
              //         fontSize: 12,
              //         color: Colors.green,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ),
              // ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeBadge(String type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getTypeColor(type).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _getTypeColor(type)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getTypeIcon(type), size: 14, color: _getTypeColor(type)),
          const SizedBox(width: 4),
          Text(
            type,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: _getTypeColor(type),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.4,
                ),
                children: [
                  TextSpan(
                    text: '$label ',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'devoir':
        return Colors.orange;
      case 'examen':
        return Colors.red;
      case 'projet':
        return Colors.blue;
      case 'quiz':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'devoir':
        return Icons.assignment;
      case 'examen':
        return Icons.quiz;
      case 'projet':
        return Icons.work;
      case 'quiz':
        return Icons.quickreply;
      default:
        return Icons.assignment_turned_in;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
      final months = [
        'Jan',
        'Fév',
        'Mar',
        'Avr',
        'Mai',
        'Juin',
        'Juil',
        'Aoû',
        'Sep',
        'Oct',
        'Nov',
        'Déc',
      ];

      return '${days[date.weekday - 1]} ${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _formatTime(String timeString) {
    try {
      final timeParts = timeString.split(':');
      if (timeParts.length >= 2) {
        return '${timeParts[0]}h${timeParts[1]}';
      }
      return timeString;
    } catch (e) {
      return timeString;
    }
  }

  String _calculateDuration(String? heureDebut, String? heureFin) {
    try {
      if (heureDebut == null || heureFin == null) return 'Non spécifiée';

      final debutParts = heureDebut.split(':');
      final finParts = heureFin.split(':');

      if (debutParts.length >= 2 && finParts.length >= 2) {
        final debut = int.parse(debutParts[0]) * 60 + int.parse(debutParts[1]);
        final fin = int.parse(finParts[0]) * 60 + int.parse(finParts[1]);
        final dureeMinutes = fin - debut;

        if (dureeMinutes <= 0) return 'Non spécifiée';

        final heures = dureeMinutes ~/ 60;
        final minutes = dureeMinutes % 60;

        if (heures > 0) {
          return '$heures h ${minutes > 0 ? '$minutes min' : ''}';
        } else {
          return '$minutes min';
        }
      }
      return 'Non spécifiée';
    } catch (e) {
      return 'Non spécifiée';
    }
  }
}
