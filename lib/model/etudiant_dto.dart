class EtudiantDTO {
  int? id;
  String? prenom;
  String? nom;
  String? email;
  int? filiereId;
  int? niveauId;
  int? anneeAcademiqueId;
  String? dateInscription;

  EtudiantDTO(
      {this.id,
      this.prenom,
      this.nom,
      this.email,
      this.filiereId,
      this.niveauId,
      this.anneeAcademiqueId,
      this.dateInscription});

  EtudiantDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prenom = json['prenom'];
    nom = json['nom'];
    email = json['email'];
    filiereId = json['filiereId'];
    niveauId = json['niveauId'];
    anneeAcademiqueId = json['anneeAcademiqueId'];
    dateInscription = json['dateInscription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['prenom'] = this.prenom;
    data['nom'] = this.nom;
    data['email'] = this.email;
    data['filiereId'] = this.filiereId;
    data['niveauId'] = this.niveauId;
    data['anneeAcademiqueId'] = this.anneeAcademiqueId;
    data['dateInscription'] = this.dateInscription;
    return data;
  }
}