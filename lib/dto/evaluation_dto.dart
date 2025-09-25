
import 'package:school_app/model/model_note.dart';

class EvaluationDTO {
  int? id;
  String? type;
  String? dateEvaluation;
  int? moduleId;
  int? salleId;
  int? professeurId;
  String? nomModule;
  String? nomProf;
  String? prenomProf;
  String? heureDebut;
  String? heureFin;
  int? anneeAcademiqueId;
  List<Note>? notes;

  EvaluationDTO(
      {this.id,
      this.type,
      this.dateEvaluation,
      this.moduleId,
      this.salleId,
      this.professeurId,
      this.nomModule,
      this.nomProf,
      this.prenomProf,
      this.heureDebut,
      this.heureFin,
      this.anneeAcademiqueId,
      this.notes});

  EvaluationDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    dateEvaluation = json['dateEvaluation'];
    moduleId = json['moduleId'];
    salleId = json['salleId'];
    professeurId = json['professeurId'];
    nomModule = json['nomModule'];
    nomProf = json['nomProf'];
    prenomProf = json['prenomProf'];
    heureDebut = json['heureDebut'];
    heureFin = json['heureFin'];
    anneeAcademiqueId = json['anneeAcademiqueId'];
    if (json['notes'] != null) {
      notes = <Note>[];
      json['notes'].forEach((v) {
        notes!.add(new Note.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['dateEvaluation'] = this.dateEvaluation;
    data['moduleId'] = this.moduleId;
    data['salleId'] = this.salleId;
    data['professeurId'] = this.professeurId;
    data['nomModule'] = this.nomModule;
    data['nomProf'] = this.nomProf;
    data['prenomProf'] = this.prenomProf;
    data['heureDebut'] = this.heureDebut;
    data['heureFin'] = this.heureFin;
    data['anneeAcademiqueId'] = this.anneeAcademiqueId;
    if (this.notes != null) {
      data['notes'] = this.notes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}