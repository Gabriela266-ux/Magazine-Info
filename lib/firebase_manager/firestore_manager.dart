import 'package:cloud_firestore/cloud_firestore.dart';
import '../Modele/redacteur.dart'; // Importation du modèle Redacteur

// Définition du nom de la collection Firestore pour la clarté et la réutilisation
const String REDACTEURS_COLLECTION = 'redacteurs';

class FirestoreManager {
  // 1. Singleton Pattern (assure une seule instance du manager)
  FirestoreManager._();
  static final FirestoreManager instance = FirestoreManager._();

  // 2. Référence à la base de données Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Propriété pour obtenir la référence de la collection 'redacteurs'
  CollectionReference<Map<String, dynamic>> get _redacteursRef => 
      _firestore.collection(REDACTEURS_COLLECTION);

  // Méthode pour ajouter un nouveau rédacteur
  Future<void> insertRedacteur(Redacteur redacteur) async {
    // Convertit le modèle en Map (toMap() exclut l'ID, qui est généré par Firestore)
    final data = redacteur.toMap();
    
    // Ajoute un nouveau document. Firestore lui assigne automatiquement un ID.
    await _redacteursRef.add(data);
  }

  // Méthode pour obtenir TOUS les rédacteurs en temps réel
  // Retourne un Stream qui émet une nouvelle liste à chaque changement dans la collection.
  Stream<List<Redacteur>> streamAllRedacteurs() {
    // Écoute les snapshots de la collection
    return _redacteursRef.snapshots().map((snapshot) {
      // Mappe chaque document (doc) dans le snapshot vers un objet Redacteur
      return snapshot.docs.map((doc) {
        return Redacteur.fromFirestore(doc);
      }).toList(); // Convertit le résultat en List<Redacteur>
    });
  }

  // Méthode pour filtrer les rédacteurs en temps réel (recherche)
  Stream<List<Redacteur>> searchRedacteurs(String query) {
    if (query.isEmpty) {
      // Si la requête est vide, retourne le stream de tous les rédacteurs
      return streamAllRedacteurs();
    }
    
    final lowerCaseQuery = query.toLowerCase();

    // Dans cet exemple, nous récupérons tous les documents et filtrons côté client.
    // Pour les grandes bases de données, il serait préférable d'utiliser Firestore Query:
    // Ex: _redacteursRef.where('nom', isGreaterThanOrEqualTo: query)...
    return _redacteursRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Redacteur.fromFirestore(doc)).where((redacteur) {
        // Applique la logique de recherche sur les champs (Nom, Prénom, Email)
        return redacteur.nom.toLowerCase().contains(lowerCaseQuery) ||
               redacteur.prenom.toLowerCase().contains(lowerCaseQuery) ||
               redacteur.email.toLowerCase().contains(lowerCaseQuery);
      }).toList();
    });
  }

  // Méthode pour mettre à jour un rédacteur existant
  Future<void> updateRedacteur(Redacteur redacteur) async {
    if (redacteur.id == null) {
      throw ArgumentError("L'ID du rédacteur ne peut pas être nul pour la mise à jour Firestore.");
    }
    
    // Utilise la méthode update() sur le document ciblé par son ID.
    // toMap() fournit les champs à mettre à jour.
    await _redacteursRef.doc(redacteur.id).update(redacteur.toMap());
  }

  // Méthode pour supprimer un rédacteur
  Future<void> deleteRedacteur(String id) async {
    // Supprime le document correspondant à l'ID
    await _redacteursRef.doc(id).delete();
  }
}