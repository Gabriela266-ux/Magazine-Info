// lib/models/redacteur_model.dart


class Redacteur {
  final String id;
  final String nom;
  final String specialite;

  const Redacteur({
    required this.id,
    required this.nom,
    required this.specialite,
  });

  // 💡 Mettre à jour la méthode fromFirestore pour gérer les valeurs nulles
  factory Redacteur.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    // Utiliser l'opérateur ?? pour fournir une valeur par défaut
    // (une chaîne vide '') si 'nom' ou 'specialite' est null ou absent.
    final nom = data['nom'] as String? ?? ''; 
    final specialite = data['specialite'] as String? ?? '';

    return Redacteur(
      id: id,
      nom: nom,
      specialite: specialite,
    );
  }

  // Méthode pour convertir l'objet en Map pour Firestore (utile pour l'ajout/modification)
  Map<String, dynamic> toFirestore() {
    return {
      'nom': nom,
      'specialite': specialite,
    };
  }
}
