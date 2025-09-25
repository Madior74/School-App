class Salle {
  int? id;
  String? nomSalle;
  String? equipements;
  bool? occupee;

  Salle({this.id, this.nomSalle, this.equipements,this.occupee});

  Salle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nomSalle = json['nomSalle'];
    equipements = json['equipements'];
    occupee = json['occupee'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nomSalle'] = this.nomSalle;
    data['equipements'] = this.equipements;
    data['occupee'] = this.occupee;
    return data;
  }
}
