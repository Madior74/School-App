import 'package:flutter/material.dart';
import 'package:school_app/dto/seance_dto.dart';
import 'package:school_app/services/all_services.dart';
import 'package:school_app/theme/color.dart';

class SeancesPage extends StatefulWidget {
  const SeancesPage({super.key});

  @override
  State<SeancesPage> createState() => _SeancesPageState();
}

class _SeancesPageState extends State<SeancesPage> {
  late Future<List<SeanceDTO>> _seancesFuture;
  final AllServices _seanceService = AllServices();

  @override
  void initState() {
    super.initState();
    _seancesFuture = _seanceService.getAllSeances();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Séances'),
        backgroundColor: myblueColor,
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _seancesFuture = _seanceService.getAllSeances();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<SeanceDTO>>(
        future: _seancesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Erreur de chargement',
                    style: TextStyle(fontSize: 18, color: Colors.red[300]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _seancesFuture = _seanceService.getAllSeances();
                      });
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.schedule, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text(
                    'Aucune séance trouvée',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final seances = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: seances.length,
              itemBuilder: (context, index) {
                final seance = seances[index];
                return _buildSeanceCard(seance);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSeanceCard(SeanceDTO seance) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          border: seance.estAnnulee == true
              ? Border.all(color: Colors.red, width: 2)
              : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête avec module et statut
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      seance.nomModule ?? 'Module non spécifié',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: myblueColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _buildStatusBadge(seance),
                ],
              ),
              const SizedBox(height: 12),

              // Date et heure
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(seance.dateSeance),
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    '${seance.heureDebut ?? '--:--'} - ${seance.heureFin ?? '--:--'}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Professeur
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    '${seance.prenomProf ?? ''} ${seance.nomProf ?? 'Professeur non spécifié'}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Type de séance (En ligne/Présentiel)
              Row(
                children: [
                  Icon(
                    seance.estEnLigne == true
                        ? Icons.videocam
                        : Icons.meeting_room,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    seance.estEnLigne == true ? 'En ligne' : 'Présentiel',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  if (seance.salleId != null && seance.estEnLigne != true)
                    Text(
                      ' - Salle ${seance.nomSalle}',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(SeanceDTO seance) {
    if (seance.estAnnulee == true) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red),
        ),
        child: const Text(
          'Annulée',
          style: TextStyle(
            color: Colors.red,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green),
      ),
      child: const Text(
        'Planifiée',
        style: TextStyle(
          color: Colors.green,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Date non spécifiée';

    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _showSeanceDetails(SeanceDTO seance) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(seance.nomModule ?? 'Détails de la séance'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailItem('Module', seance.nomModule),
              _buildDetailItem(
                'Professeur',
                '${seance.prenomProf} ${seance.nomProf}',
              ),
              _buildDetailItem('Date', _formatDate(seance.dateSeance)),
              _buildDetailItem(
                'Heure',
                '${seance.heureDebut} - ${seance.heureFin}',
              ),
              _buildDetailItem(
                'Type',
                seance.estEnLigne == true ? 'En ligne' : 'Présentiel',
              ),
              if (seance.salleId != null)
                _buildDetailItem('Salle', seance.salleId.toString()),
              _buildDetailItem(
                'Statut',
                seance.estAnnulee == true ? 'Annulée' : 'Planifiée',
              ),
              _buildDetailItem(
                'Date de création',
                _formatDate(seance.dateCreation),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value ?? 'Non spécifié')),
        ],
      ),
    );
  }
}
