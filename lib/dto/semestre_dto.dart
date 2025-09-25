class SemestreDTO {
  int? id;
  String? nomSemestre;
  int? niveauId;

  SemestreDTO({this.id, this.nomSemestre, this.niveauId});

  SemestreDTO.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nomSemestre = json['nomSemestre'];
    niveauId = json['niveauId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nomSemestre'] = this.nomSemestre;
    data['niveauId'] = this.niveauId;
    return data;
  }
}