import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:school_app/dto/evaluation_dto.dart';
import 'package:school_app/model/model_evaluation.dart';
import 'package:school_app/services/all_services.dart';
import 'package:school_app/theme/color.dart';
import 'package:school_app/widgets/evaluation_card.dart';

class EvaluationsPage extends StatefulWidget {
  const EvaluationsPage({Key? key}) : super(key: key);

  @override
  State<EvaluationsPage> createState() => _EvaluationsPageState();
}

class _EvaluationsPageState extends State<EvaluationsPage> {
  late Future<List<EvaluationDTO>> _futureEvaluations;
  final AllServices _apiService = AllServices();

  @override
  void initState() {
    super.initState();
    _futureEvaluations = _apiService.getAllEvaluations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Évaluations'),
        backgroundColor: myblueColor,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<EvaluationDTO>>(
        future: _futureEvaluations,
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
                        _futureEvaluations = _apiService.getAllEvaluations();
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
                  Icon(Icons.assignment, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Aucune évaluation prévue',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          } else {
            final evaluations = snapshot.data!;
            // Trier par date (plus récent en premier)
            evaluations.sort(
              (a, b) =>
                  (a.dateEvaluation ?? '').compareTo(b.dateEvaluation ?? ''),
            );

            return ListView.builder(
              itemCount: evaluations.length,
              itemBuilder: (context, index) {
                return EvaluationCard(evaluation: evaluations[index]);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _futureEvaluations = _apiService.getAllEvaluations();
          });
        },
        backgroundColor: myblueColor,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }
}
