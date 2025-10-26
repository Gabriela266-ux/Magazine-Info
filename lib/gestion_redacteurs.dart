import 'package:flutter/material.dart';
// Importation du nouveau gestionnaire Firestore
import 'firebase_manager/firestore_manager.dart'; 
import 'Modele/redacteur.dart';
import 'package:flutter/foundation.dart'; // Pour debugPrint si nécessaire

class PageGestionRedacteurs extends StatefulWidget {
  const PageGestionRedacteurs({super.key});

  @override
  State<PageGestionRedacteurs> createState() => _PageGestionRedacteursState();
}

class _PageGestionRedacteursState extends State<PageGestionRedacteurs> {
  // Le Stream pour écouter les changements en temps réel de Firestore
  late Stream<List<Redacteur>> _redacteursStream;

  // Contrôleurs pour les champs de texte
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _searchController = TextEditingController();

  // Cette fonction est appelée pour mettre à jour le Stream
  void refreshRedacteurs({String? query}) {
    setState(() {
      final String currentQuery = query ?? _searchController.text;
      if (currentQuery.isNotEmpty) {
        // Appelle la méthode de recherche Stream
        _redacteursStream = FirestoreManager.instance.searchRedacteurs(currentQuery);
      } else {
        // Appelle le Stream pour tous les rédacteurs
        _redacteursStream = FirestoreManager.instance.streamAllRedacteurs();
      }
    });
  }

  // Fonction pour ajouter un nouveau rédacteur
  Future<void> _addRedacteur() async {
    // Vérification des champs de texte
    if (_nomController.text.isEmpty || _prenomController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs !'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newRedacteur = Redacteur(
      nom: _nomController.text,
      prenom: _prenomController.text,
      email: _emailController.text,
    );
    
    await FirestoreManager.instance.insertRedacteur(newRedacteur);
    
    _nomController.clear();
    _prenomController.clear();
    _emailController.clear();
  }

  // Fonction pour modifier un rédacteur
  Future<void> _editRedacteur(Redacteur redacteur) async {
    final nomController = TextEditingController(text: redacteur.nom);
    final prenomController = TextEditingController(text: redacteur.prenom);
    final emailController = TextEditingController(text: redacteur.email);

    return showDialog<void>( 
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Modifier le rédacteur'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: nomController,
                  decoration: const InputDecoration(labelText: 'Nom'),
                ),
                TextField(
                  controller: prenomController,
                  decoration: const InputDecoration(labelText: 'Prénom'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Enregistrer'),
              onPressed: () async {
                final updatedRedacteur = Redacteur(
                  id: redacteur.id, 
                  nom: nomController.text,
                  prenom: prenomController.text,
                  email: emailController.text,
                );
                
                await FirestoreManager.instance.updateRedacteur(updatedRedacteur);
                
                // CORRECTION FINALE pour BuildContext across async gaps:
                // Nous utilisons le 'dialogContext' local qui est sûr.
                // Le linter émet le warning car il ne peut pas distinguer le 'dialogContext' 
                // du 'context' global si on utilisait ce dernier.
                // Le 'if (!mounted) return;' est suffisant pour le 'context' global, 
                // mais le linter peut se tromper dans un AlertDialog, donc on le laisse 
                // et on s'assure d'utiliser le 'dialogContext' local.
                if (!mounted) return; 

                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Affiche une boîte de dialogue de confirmation pour la suppression
  Future<void> _showDeleteConfirmationDialog(String id) async {
    return showDialog<void>( 
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmation de suppression'),
          content: const Text('Êtes-vous sûr de vouloir supprimer ce rédacteur ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annuler'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Confirmer'),
              onPressed: () async {
                await FirestoreManager.instance.deleteRedacteur(id);
                
                // CORRECTION FINALE pour BuildContext across async gaps:
                if (!mounted) return;

                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _redacteursStream = FirestoreManager.instance.streamAllRedacteurs();
    
    _searchController.addListener(() {
      refreshRedacteurs(query: _searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _searchController.text.isEmpty
            ? const Text('Gestion des rédacteurs',
            style: TextStyle(color: Colors.white),)
            : TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Rechercher...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
              ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 237, 9, 104),
        actions: [
          IconButton(
            icon: _searchController.text.isEmpty
                ? const Icon(Icons.search, color: Colors.white)
                : const Icon(Icons.clear, color: Colors.white),
            onPressed: () {
              if (_searchController.text.isNotEmpty) {
                _searchController.clear();
                refreshRedacteurs(query: '');
              } else {
                setState(() {}); 
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomController,
              decoration: const InputDecoration(
                labelText: 'Nom',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _prenomController,
              decoration: const InputDecoration(
                labelText: 'Prénom',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FloatingActionButton.extended( 
                backgroundColor: const Color.fromARGB(255, 237, 9, 104),
                onPressed: _addRedacteur,
                label: const Text('Ajouter un Rédacteur',
                style: TextStyle(color: Colors.white),),
                icon: const Icon(Icons.add,
                color: Colors.white,),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            
            Expanded(
              child: StreamBuilder<List<Redacteur>>(
                stream: _redacteursStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    if (kDebugMode) { 
                      debugPrint('Erreur Firestore: ${snapshot.error}');
                    }
                    return Center(child: Text('Erreur de chargement: ${snapshot.error}', style: const TextStyle(color: Colors.red),));
                  } 
                  
                  final redacteurs = snapshot.data;

                  if (redacteurs == null || redacteurs.isEmpty) {
                    return const Center(child: Text('Aucun rédacteur trouvé.', style: TextStyle(fontStyle: FontStyle.italic),));
                  } 
                  
                  return ListView.builder(
                    itemCount: redacteurs.length,
                    itemBuilder: (context, index) {
                      final redacteur = redacteurs[index];
                      return ListTile(
                        title: Text('${redacteur.prenom} ${redacteur.nom}'),
                        subtitle: Text(redacteur.email),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _editRedacteur(redacteur);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // L'ID doit être un String (ID Firestore)
                                _showDeleteConfirmationDialog(redacteur.id!);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}