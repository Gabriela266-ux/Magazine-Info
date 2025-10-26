// lib/pages/modifier_redacteur_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/redacteur_model.dart'; // Importation du modèle Redacteur

class ModifierRedacteurPage extends StatefulWidget {
  final Redacteur redacteur; // Rédacteur à modifier, passé en paramètre

  const ModifierRedacteurPage({
    super.key,
    required this.redacteur,
  });

  @override
  State<ModifierRedacteurPage> createState() => _ModifierRedacteurPageState();
}

class _ModifierRedacteurPageState extends State<ModifierRedacteurPage> {
  // Contrôleurs pour gérer les champs de texte
  final _nomController = TextEditingController();
  final _specialiteController = TextEditingController();

  // Instance de Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    // 1. Initialiser les contrôleurs avec les données existantes
    _nomController.text = widget.redacteur.nom;
    _specialiteController.text = widget.redacteur.specialite;
  }

  @override
  void dispose() {
    _nomController.dispose();
    _specialiteController.dispose();
    super.dispose();
  }

  // Fonction pour mettre à jour le document Firestore
  Future<void> _enregistrerModifications() async {
    final nouveauNom = _nomController.text.trim();
    final nouvelleSpecialite = _specialiteController.text.trim();

    // Validation simple
    if (nouveauNom.isEmpty || nouvelleSpecialite.isEmpty) {
      // Afficher un message à l'utilisateur
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir tous les champs.')),
      );
      return;
    }

    // 2. Créer le dictionnaire des modifications
    final modifications = {
      'nom': nouveauNom,
      'specialite': nouvelleSpecialite,
    };

    try {
      // 3. Mettre à jour le document dans Firestore
      await _firestore
          .collection('redacteurs')
          .doc(widget.redacteur.id) // Utilise l'ID du rédacteur actuel
          .update(modifications);

      // 4. Afficher une boîte de dialogue de succès
      if (mounted) {
        _afficherDialogueSucces();
      }
    } catch (e) {
      // Afficher l'erreur dans la console et à l'utilisateur
      print('Erreur lors de la mise à jour: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Échec de l\'enregistrement des modifications.')),
        );
      }
    }
  }

  // Boîte de dialogue de succès
  void _afficherDialogueSucces() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Succès'),
        content: const Text('Les informations du rédacteur ont été mises à jour.'),
        actions: [
          TextButton(
            onPressed: () {
              // Fermer le dialogue
              Navigator.of(ctx).pop();
              // Revenir à la page précédente (GestionRedacteursPage)
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier Rédacteur'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Champ Nom (pré-rempli)
            TextFormField(
              controller: _nomController,
              decoration: const InputDecoration(
                labelText: 'Nom du rédacteur',
                border: OutlineInputBorder(),
              ),
              maxLength: 50,
            ),
            const SizedBox(height: 15),

            // Champ Spécialité (pré-rempli)
            TextFormField(
              controller: _specialiteController,
              decoration: const InputDecoration(
                labelText: 'Spécialité',
                border: OutlineInputBorder(),
              ),
              maxLength: 50,
            ),
            const SizedBox(height: 30),

            // Bouton d'enregistrement
            ElevatedButton.icon(
              onPressed: _enregistrerModifications,
              icon: const Icon(Icons.save),
              label: const Text(
                'Enregistrer les modifications',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
