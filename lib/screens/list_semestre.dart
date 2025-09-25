import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:school_app/dto/semestre_dto.dart';
import 'package:school_app/screens/ue_by_semestre.dart';
import 'package:school_app/services/all_services.dart';
import 'package:school_app/widgets/semestre_card.dart';

class ListSemestre extends StatefulWidget {
  const ListSemestre({super.key});

  @override
  State<ListSemestre> createState() => _ListSemestreState();
}

class _ListSemestreState extends State<ListSemestre> {
  late Future<List<SemestreDTO>> _semestresFuture;
  int? _selectedSemestreId;

  // Remplace par ton URL réel

  @override
  void initState() {
    super.initState();
    _semestresFuture = AllServices().getAllMySemestres();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes Semestres'), centerTitle: true),
      body: FutureBuilder<List<SemestreDTO>>(
        future: _semestresFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Erreur : ${snapshot.error.toString()}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _semestresFuture = AllServices().getAllMySemestres();
                      });
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Aucun semestre trouvé.'));
          } else {
            final semestres = snapshot.data!;
            return ListView.builder(
              itemCount: semestres.length,
              itemBuilder: (context, index) {
                final semestre = semestres[index];
                final isSelected = _selectedSemestreId == semestre.id;

                return SemestreCard(
                  semestre: semestre,
                  isSelected: isSelected,
                  onTap: () {
                    if (!isSelected) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UeBySemestre(semestre: semestre),
                        ),
                      );
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
