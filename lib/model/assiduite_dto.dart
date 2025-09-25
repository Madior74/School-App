import 'package:school_app/model/etudiant_dto.dart';

class AssiduiteDto {
  int? id;
  int? seanceId;
  EtudiantDTO? etudiantDTO;
  String? statutPresence;
  String? dateCreation;
  String? dateModification;
  String? creerPar;
  String? modifierPar;

  AssiduiteDto(
      {this.id,
      this.seanceId,
      this.etudiantDTO,
      this.statutPresence,
      this.dateCreation,
      this.dateModification,
      this.creerPar,
      this.modifierPar});

  AssiduiteDto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    seanceId = json['seanceId'];
    etudiantDTO = json['etudiantDTO'] != null
        ? new EtudiantDTO.fromJson(json['etudiantDTO'])
        : null;
    statutPresence = json['statutPresence'];
    dateCreation = json['dateCreation'];
    dateModification = json['dateModification'];
    creerPar = json['creerPar'];
    modifierPar = json['modifierPar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['seanceId'] = this.seanceId;
    if (this.etudiantDTO != null) {
      data['etudiantDTO'] = this.etudiantDTO!.toJson();
    }
    data['statutPresence'] = this.statutPresence;
    data['dateCreation'] = this.dateCreation;
    data['dateModification'] = this.dateModification;
    data['creerPar'] = this.creerPar;
    data['modifierPar'] = this.modifierPar;
    return data;
  }
}