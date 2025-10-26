// Fichier: lib/pages/gestion_redacteurs_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/redacteur_model.dart';
import 'ajouter_redacteur_page.dart'; // Importation de la page d'ajout
import 'modifier_redacteur_page.dart'; // 💡 NOUVEAU: Importation de la page de modification

class GestionRedacteursPage extends StatelessWidget {
  const GestionRedacteursPage({super.key});

  /// Méthode pour naviguer vers la page d'ajout
  void _naviguerVersAjout(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => const AjouterRedacteurPage(),
      ),
    );
  }

  // 💡 NOUVEAU: Méthode pour naviguer vers la page de modification
  void _naviguerVersModification(BuildContext context, Redacteur redacteur) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ModifierRedacteurPage(redacteur: redacteur), // On passe le rédacteur
      ),
    );
  }

  // 💡 NOUVEAU: Méthode pour afficher une confirmation et supprimer
  Future<void> _confirmerEtSupprimer(
      BuildContext context, Redacteur redacteur) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmation de suppression'),
        content: Text(
            'Êtes-vous sûr de vouloir supprimer le rédacteur ${redacteur.nom} ? Cette action est irréversible.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false), // Annuler
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true), // Confirmer
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        await FirebaseFirestore.instance
            .collection('redacteurs')
            .doc(redacteur.id)
            .delete();
            
        // Afficher un message de succès après la suppression
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Rédacteur ${redacteur.nom} supprimé avec succès.')),
        );
      } catch (e) {
        // Afficher un message d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur lors de la suppression.')),
        );
        print('Erreur de suppression Firestore: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Rédacteurs'),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      // Utilisation d'un StreamBuilder pour écouter les changements en temps réel dans Firestore
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('redacteurs').snapshots(),
        builder: (context, snapshot) {
          // 1. Gestion de l'état de la connexion (chargement)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Gestion des erreurs
          if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement: ${snapshot.error}'));
          }

          // 3. Récupération des données
          final loadedDocs = snapshot.data!.docs;

          // 4. Si la liste est vide
          if (loadedDocs.isEmpty) {
            return Center(
              child: Text(
                'Aucun rédacteur trouvé.\nAjoutez-en un !',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            );
          }

          // 5. Affichage de la liste des rédacteurs
          return ListView.builder(
            itemCount: loadedDocs.length,
            itemBuilder: (ctx, index) {
              // Conversion du DocumentSnapshot en objet Redacteur
              final redacteur = Redacteur.fromFirestore(
                loadedDocs[index].id,
                loadedDocs[index].data(),
              );

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.indigo,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    redacteur.nom,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(redacteur.specialite),

                  // 💡 NOUVEAU: Action au clic pour naviguer vers la modification
                  onTap: () {
                    _naviguerVersModification(context, redacteur);
                  },

                  // Boutons d'action (Modifier et Supprimer)
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Bouton Modifier (Redondant mais utile pour une meilleure UX)
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.amber),
                        onPressed: () {
                          // 💡 IMPLEMENTATION: Navigation vers la page de modification
                          _naviguerVersModification(context, redacteur);
                        },
                      ),
                      // Bouton Supprimer
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // 💡 IMPLEMENTATION: Appel à la fonction de confirmation et suppression
                          _confirmerEtSupprimer(context, redacteur);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      // Bouton flottant pour ajouter un nouveau rédacteur
      floatingActionButton: FloatingActionButton(
        onPressed: () => _naviguerVersAjout(context),
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}