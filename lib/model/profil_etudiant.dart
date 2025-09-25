class ProfilEtudiant {
  final int id;
  final String nom;
  final String prenom;
  final String adresse;
  final String paysDeNaissance;
  final String dateDeNaissance;
  final String imagePath;
  final String cni;
  final String ine;
  final String telephone;
  final String sexe;
  final String email;
  final String role;

  const ProfilEtudiant({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.adresse,
    required this.paysDeNaissance,
    required this.dateDeNaissance,
    required this.imagePath,
    required this.cni,
    required this.ine,
    required this.telephone,
    required this.sexe,
    required this.email,
    required this.role,
  });

  factory ProfilEtudiant.fromJson(Map<String, dynamic> json) {
    return ProfilEtudiant(
      id: json['id'] ?? 0,
      nom: json['nom'] ?? 'Non spécifié',
      prenom: json['prenom'] ?? 'Non spécifié',
      adresse: json['adresse'] ?? 'Non renseignée',
      paysDeNaissance: json['paysDeNaissance'] ?? 'Non spécifié',
      dateDeNaissance: json['dateDeNaissance'] ?? 'Non spécifiée',
      imagePath: json['imagePath'] ?? 'assets/images/avatar.png',
      cni: json['cni'] ?? 'Non renseignée',
      ine: json['ine'] ?? 'Non renseigné',
      telephone: json['telephone'] ?? 'Non renseigné',
      sexe: json['sexe'] ?? 'Non spécifié',
      email: json['email'] ?? 'Non renseigné',
      role: json['role'] ?? 'Étudiant',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'adresse': adresse,
      'paysDeNaissance': paysDeNaissance,
      'dateDeNaissance': dateDeNaissance,
      'imagePath': imagePath,
      'cni': cni,
      'ine': ine,
      'telephone': telephone,
      'sexe': sexe,
      'email': email,
      'role': role,
    };
  }
}
