//Seances
class SeanceDTO {
  int? id;
  String? dateSeance;
  String? heureDebut;
  String? heureFin;
  bool? estEnLigne;
  bool? estAnnulee;
  int? salleId;
  String? nomSalle;
  int? moduleId;
  String? nomModule;
  String? nomProf;
  String? prenomProf;
  int? professeurId;
  int? anneeAcademiqueId;
  String? dateCreation;

  SeanceDTO({
    this.id,
    this.dateSeance,
    this.heureDebut,
    this.heureFin,
    this.estEnLigne,
    this.estAnnulee,
    this.salleId,
    this.moduleId,
    this.nomModule,
    this.nomProf,
    this.prenomProf,
    this.professeurId,
    this.anneeAcademiqueId,
    this.dateCreation,
    this.nomSalle,
  });

  SeanceDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dateSeance = json['dateSeance'];
    heureDebut = json['heureDebut'];
    heureFin = json['heureFin'];
    estEnLigne = json['estEnLigne'];
    estAnnulee = json['estAnnulee'];
    salleId = json['salleId'];
    moduleId = json['moduleId'];
    nomModule = json['nomModule'];
    nomProf = json['nomProf'];
    prenomProf = json['prenomProf'];
    professeurId = json['professeurId'];
    anneeAcademiqueId = json['anneeAcademiqueId'];
    dateCreation = json['dateCreation'];
    nomSalle = json['nomSalle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dateSeance'] = this.dateSeance;
    data['heureDebut'] = this.heureDebut;
    data['heureFin'] = this.heureFin;
    data['estEnLigne'] = this.estEnLigne;
    data['estAnnulee'] = this.estAnnulee;
    data['salleId'] = this.salleId;
    data['moduleId'] = this.moduleId;
    data['nomModule'] = this.nomModule;
    data['nomSalle'] = this.nomSalle;
    data['nomProf'] = this.nomProf;
    data['prenomProf'] = this.prenomProf;
    data['professeurId'] = this.professeurId;
    data['anneeAcademiqueId'] = this.anneeAcademiqueId;
    data['dateCreation'] = this.dateCreation;
    return data;
  }
}
