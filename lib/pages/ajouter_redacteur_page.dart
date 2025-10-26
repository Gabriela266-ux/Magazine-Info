// Fichier: lib/pages/ajouter_redacteur_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/redacteur_model.dart'; // Pour utiliser la méthode toFirestore

class AjouterRedacteurPage extends StatefulWidget {
  const AjouterRedacteurPage({super.key});

  @override
  State<AjouterRedacteurPage> createState() => _AjouterRedacteurPageState();
}

class _AjouterRedacteurPageState extends State<AjouterRedacteurPage> {
  // Clé pour identifier le formulaire et valider son état
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour récupérer les valeurs des champs de texte
  final _nomController = TextEditingController();
  final _specialiteController = TextEditingController();

  // Instance de Firestore pour l'écriture des données
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String collectionName = 'redacteurs';

  /// Méthode pour enregistrer le nouveau rédacteur dans Firestore
  Future<void> _enregistrerRedacteur() async {
    // 1. Validation du formulaire
    if (_formKey.currentState!.validate()) {
      // Affiche un indicateur de chargement
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        );
      }

      // 2. Création de l'objet Redacteur temporaire
      final nouveauRedacteur = Redacteur(
        // L'ID est temporaire ici (on utilisera l'ID généré par Firestore)
        id: '', 
        nom: _nomController.text.trim(),
        specialite: _specialiteController.text.trim(),
      );

      try {
        // 3. Enregistrement dans Firestore
        await _firestore.collection(collectionName).add(
          nouveauRedacteur.toFirestore(),
        );

        // 4. Confirmation et navigation
        if (mounted) {
          // Ferme l'indicateur de chargement
          Navigator.of(context).pop(); 
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Rédacteur ajouté avec succès !')),
          );
          // Retour à la page précédente (GestionRedacteursPage)
          Navigator.of(context).pop();
        }
      } catch (e) {
        // 5. Gestion des erreurs d'écriture
        if (mounted) {
          // Ferme l'indicateur de chargement en cas d'erreur
          Navigator.of(context).pop(); 

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors de l\'ajout : $e')),
          );
        }
        print('Erreur Firestore: $e');
      }
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _specialiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un Nouveau Rédacteur'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Champ pour le Nom
              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(
                  labelText: 'Nom du Rédacteur',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez entrer le nom du rédacteur.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Champ pour la Spécialité
              TextFormField(
                controller: _specialiteController,
                decoration: InputDecoration(
                  labelText: 'Spécialité (Ex: Sport, Technologie)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.work),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Veuillez entrer une spécialité.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Bouton d'enregistrement
              ElevatedButton.icon(
                onPressed: _enregistrerRedacteur,
                icon: const Icon(Icons.save),
                label: const Text(
                  'Enregistrer le Rédacteur',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
