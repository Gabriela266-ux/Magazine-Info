import 'package:cloud_firestore/cloud_firestore.dart';

// Définition de la classe Redacteur pour modéliser les données de nos rédacteurs.
class Redacteur {
  // L'ID est maintenant de type String (ID de document Firestore)
  // Il est optionnel lors de la création et fourni lors de la lecture/modification
  final String? id; 
  final String nom;
  final String prenom;
  final String email;

  // Constructeur principal, adapté pour gérer l'ID String de Firestore.
  const Redacteur({
    this.id, // L'ID Firestore est un String
    required this.nom,
    required this.prenom,
    required this.email,
  });

  // Convertit un objet Redacteur en Map pour l'insérer/mettre à jour dans Firestore.
  Map<String, dynamic> toMap() {
    return {
      'nom': nom,
      'prenom': prenom,
      'email': email,
    };
  }

  // Crée une nouvelle instance de Redacteur à partir d'un DocumentSnapshot Firestore.
  // C'est essentiel pour lire les données de la base.
  factory Redacteur.fromFirestore(DocumentSnapshot doc) {
    // Cast sécurisé des données du document
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Redacteur(
      // L'ID du document Firestore est utilisé comme ID du rédacteur
      id: doc.id, 
      nom: data['nom'] as String,
      prenom: data['prenom'] as String,
      email: data['email'] as String,
    );
  }

  // Redéfinition de toString pour un débogage facile.
  @override
  String toString() {
    return 'Redacteur{id: $id, nom: $nom, prenom: $prenom, email: $email}';
  }
}