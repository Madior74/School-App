class NoteDTO {
  int? id;
  double valeur;
  int etudiantId;
  int evaluationId;
  String? typeEvaluation;
  String? nomModule;
  String? dateEvaluation;
  String? nomEtudiant;
  String? prenomEtudiant;
  String? nomProf;
  String? prenomProf;

  NoteDTO({
    this.id,
    required this.valeur,
    required this.etudiantId,
    required this.evaluationId,
    this.nomEtudiant,
    this.prenomEtudiant,
    this.nomProf,
    this.prenomProf,
    this.typeEvaluation,
    this.nomModule,
    this.dateEvaluation,
  });

  factory NoteDTO.fromJson(Map<String, dynamic> json) => NoteDTO(
    id: json["id"],
    valeur: json["valeur"],
    etudiantId: json["etudiantId"],
    evaluationId: json["evaluationId"],
    nomEtudiant: json["nomEtudiant"],
    prenomEtudiant: json["prenomEtudiant"],
    nomProf: json["nomProf"],
    prenomProf: json["prenomProf"],
    typeEvaluation: json["typeEvaluation"],
    nomModule: json["nomModule"],
    dateEvaluation: json["dateEvaluation"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "valeur": valeur,
    "etudiantId": etudiantId,
    "evaluationId": evaluationId,
    "nomEtudiant": nomEtudiant,
    "prenomEtudiant": prenomEtudiant,
    "nomProf": nomProf,
    "prenomProf": prenomProf,
    "typeEvaluation": typeEvaluation,
    "nomModule": nomModule,
    "dateEvaluation": dateEvaluation,
  };
}
