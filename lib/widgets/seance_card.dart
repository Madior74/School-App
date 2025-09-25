import 'package:flutter/material.dart';
import 'package:school_app/dto/seance_dto.dart';

class AbsenceCard extends StatelessWidget {
  final SeanceDTO seance;

  const AbsenceCard({Key? key, required this.seance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          border: const Border(left: BorderSide(color: Colors.red, width: 4)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec date et statut d'absence
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDate(seance.dateSeance ?? ''),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.warning_amber, size: 14, color: Colors.red),
                        SizedBox(width: 4),
                        Text(
                          'Absence',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Module
              _buildInfoRow(
                Icons.school,
                'Module:',
                seance.nomModule ?? 'Non spécifié',
              ),

              // Professeur
              _buildInfoRow(
                Icons.person,
                'Professeur:',
                '${seance.nomProf ?? ''} ${seance.prenomProf ?? ''}'.trim(),
              ),

              // Horaires
              _buildInfoRow(
                Icons.access_time,
                'Horaire:',
                '${_formatTime(seance.heureDebut ?? '')} - ${_formatTime(seance.heureFin ?? '')}',
              ),

              // Mode (En ligne/Présentiel)
              _buildInfoRow(
                Icons.videocam,
                'Mode:',
                seance.estEnLigne == true ? 'En ligne' : 'Présentiel',
                valueColor: seance.estEnLigne == true
                    ? Colors.green
                    : Colors.blue,
              ),

              // // Date de création de l'enregistrement
              // if (seance.dateCreation != null) ...[
              //   const SizedBox(height: 8),
              //   Text(
              //     'Enregistrée le ${_formatDateTime(seance.dateCreation!)}',
              //     style: const TextStyle(
              //       fontSize: 12,
              //       color: Colors.grey,
              //       fontStyle: FontStyle.italic,
              //     ),
              //   ),
              // ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
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
                  TextSpan(
                    text: value,
                    style: TextStyle(color: valueColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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

  String _formatDateTime(String dateTimeString) {
    try {
      final dateTime = DateTime.parse(dateTimeString);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} à ${dateTime.hour.toString().padLeft(2, '0')}h${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTimeString;
    }
  }
}
