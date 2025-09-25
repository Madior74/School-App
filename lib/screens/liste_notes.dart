import 'package:flutter/material.dart';
import 'package:school_app/dto/note_dto.dart';
import 'package:school_app/services/all_services.dart';
import 'package:school_app/theme/color.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late Future<List<NoteDTO>> _notesFuture;
  final AllServices _notesService = AllServices();
  String _filterType = 'Tous';

  @override
  void initState() {
    super.initState();
    _notesFuture = _notesService.getAllNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Notes'),
        backgroundColor: myblueColor,
        foregroundColor: Colors.white,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _notesFuture = _notesService.getAllNotes();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtres par type d'évaluation
          _buildFilterChips(),
          const SizedBox(height: 8),
          Expanded(
            child: FutureBuilder<List<NoteDTO>>(
              future: _notesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Erreur de chargement',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.red[300],
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _notesFuture = _notesService.getAllNotes();
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
                        Icon(Icons.grade, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        const Text(
                          'Aucune note trouvée',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                final notes = snapshot.data!;
                final filteredNotes = _filterType == 'Tous'
                    ? notes
                    : notes
                          .where((note) => note.typeEvaluation == _filterType)
                          .toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredNotes.length,
                  itemBuilder: (context, index) {
                    final note = filteredNotes[index];
                    return _buildNoteCard(note);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final types = ['Tous', 'Devoir', 'Examen', 'Projet', 'TP', 'Autre'];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: types.length,
        itemBuilder: (context, index) {
          final type = types[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(type),
              selected: _filterType == type,
              onSelected: (selected) {
                setState(() {
                  _filterType = selected ? type : 'Tous';
                });
              },
              selectedColor: myredColor,
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: _filterType == type ? Colors.white : Colors.grey[700],
                fontWeight: _filterType == type
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoteCard(NoteDTO note) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNoteCircle(note.valeur),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.typeEvaluation ?? 'Non spécifié',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(note.dateEvaluation ?? 'Non spécifié'),
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      if (note.nomModule != null && note.nomModule!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            note.nomModule!,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                _getEvaluationIcon(note.typeEvaluation ?? 'Autre'),
              ],
            ),
            const SizedBox(height: 12),
            // Professeur uniquement
            _buildInfoRow(
              'Professeur',
              '${note.prenomProf ?? ''} ${note.nomProf ?? ''}',
            ),
            const SizedBox(height: 12),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteCircle(double valeur) {
    Color getNoteColor(double note) {
      if (note >= 16) return Colors.green;
      if (note >= 14) return Colors.lightGreen;
      if (note >= 12) return Colors.orange;
      if (note >= 10) return Colors.amber;
      return Colors.red;
    }

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: getNoteColor(valeur),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          valeur.toStringAsFixed(2),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'Non spécifié' : value,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Icon _getEvaluationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'examen':
        return const Icon(Icons.assignment, color: Colors.red);
      case 'devoir':
        return const Icon(Icons.quiz, color: Colors.orange);
      case 'projet':
        return const Icon(Icons.work, color: Colors.blue);
      case 'tp':
        return const Icon(Icons.science, color: Colors.green);
      default:
        return const Icon(Icons.assignment_turned_in, color: Colors.grey);
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  void _showNoteDetails(NoteDTO note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Détails de la note - ${note.nomModule ?? 'Non spécifié'}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailItem('Note', '${note.valeur}/20'),
              _buildDetailItem('Type', note.typeEvaluation ?? 'Non spécifié'),
              _buildDetailItem(
                'Date',
                _formatDate(note.dateEvaluation ?? 'Non spécifié'),
              ),
              _buildDetailItem(
                'Étudiant',
                '${note.prenomEtudiant} ${note.nomEtudiant}',
              ),
              _buildDetailItem(
                'Professeur',
                '${note.prenomProf} ${note.nomProf}',
              ),
              _buildDetailItem('ID Évaluation', note.evaluationId.toString()),
              if (note.id != null)
                _buildDetailItem('ID Note', note.id.toString()),
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

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _showStats() {
    // Implémentez les statistiques ici
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Statistiques des notes'),
        content: const Text('Fonctionnalité de statistiques à implémenter...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }
}
