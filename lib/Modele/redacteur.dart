class Redacteur {
  // Les attributs du modèle Redacteur
  // 'id' est optionnel car il est auto-incrémenté par la base de données
  int? id;
  String nom;
  String prenom;
  String email;

  // Constructeur principal pour un rédacteur existant (avec un ID)
  Redacteur({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
  });

  // Constructeur pour un nouveau rédacteur (sans ID)
  // Le 'id' sera généré par la base de données lors de l'insertion
  Redacteur.sansId({
    required this.nom,
    required this.prenom,
    required this.email,
  });

  // Méthode pour convertir un objet Redacteur en un Map
  // Utile pour l'insertion dans la base de données
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
    };
  }
}