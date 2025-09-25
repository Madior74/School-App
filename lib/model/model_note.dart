

class Note {
  final int? id;
  final double valeur;
  // final Evaluation? evaluation;
  // final Etudiant? etudiant;

  Note({
    required this.valeur,
    this.id,
    // required this.evaluation,
    // required this.etudiant,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      valeur: json['valeur'],
      // etudiant:
      //     json['etudiant'] != null ? Etudiant.fromJson(json['etudiant']) : null,
      // evaluation: json['evaluation'] != null
      //     ? Evaluation.fromJson(json['evaluation'])
      //     : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'valeur': valeur,
      // 'etudiant': etudiant?.toJson(),
      // 'evaluation': evaluation?.toJson()
    };
  }
}
