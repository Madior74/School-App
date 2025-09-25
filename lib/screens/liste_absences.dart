import 'package:flutter/material.dart';
import 'package:school_app/dto/seance_dto.dart';
import 'package:school_app/services/all_services.dart';
import 'package:school_app/theme/color.dart';
import 'package:school_app/widgets/seance_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MesAbsencesPage extends StatefulWidget {
  const MesAbsencesPage({Key? key}) : super(key: key);

  @override
  State<MesAbsencesPage> createState() => _MesAbsencesPageState();
}

class _MesAbsencesPageState extends State<MesAbsencesPage> {
  late Future<List<SeanceDTO>> _futureSeances;
  final AllServices _apiService = AllServices();

  @override
  void initState() {
    super.initState();
    _futureSeances = _apiService.getAllAbsentes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Absences'),
        backgroundColor: myblueColor,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<SeanceDTO>>(
        future: _futureSeances,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Erreur: ${snapshot.error}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _futureSeances = _apiService.getAllAbsentes();
                      });
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: Colors.green,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aucune absence trouvée',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          } else {
            final seances = snapshot.data!;
            return ListView.builder(
              itemCount: seances.length,
              itemBuilder: (context, index) {
                return AbsenceCard(seance: seances[index]);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _futureSeances = _apiService.getAllAbsentes();
          });
        },
        backgroundColor: myblueColor,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}
