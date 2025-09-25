import 'package:school_app/model/model_ue.dart';

class Module {
  final int? id;
  final String nomModule;
  final String? nomUE;
  final int volumeHoraire; // Volume horaire du module
  final double creditModule; // Crédits du module
  final DateTime? dateAjout;
  final UE? ue;

  // Constructeur
  Module({
    this.id,
    this.nomUE,
    required this.nomModule,
    required this.volumeHoraire,
    required this.creditModule,
    this.dateAjout,
    this.ue,
  });

  // Factory pour créer un Module à partir d'un JSON
  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'],
      nomModule: json['nomModule'] ?? "Nom inconnu",
      nomUE: json['nomUE'] ?? "Nom inconnu",
      volumeHoraire: json['volumeHoraire'] ?? 0,
      creditModule: json['creditModule'] ?? 0.0,
      dateAjout: json['dateAjout'] != null
          ? DateTime.tryParse(json['dateAjout'])
          : null,
      ue: json['ue'] != null ? UE.fromJson(json['ue']) : null,
    );
  }

  // Convertir un Module en JSON (pour l'envoi au serveur)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomModule': nomModule,
      'volumeHoraire': volumeHoraire,
      'creditModule': creditModule,
      'dateAjout': dateAjout?.toIso8601String(),

      'ue': ue != null
          ? {'id': ue!.id}
          : null, // Envoyer uniquement l'ID de l'UE
    };
  }
}
