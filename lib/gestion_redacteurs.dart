import 'package:flutter/material.dart';
import 'database_manager.dart';
import 'Modele/redacteur.dart';

class PageGestionRedacteurs extends StatefulWidget {
  const PageGestionRedacteurs({super.key});

  @override
  State<PageGestionRedacteurs> createState() => _PageGestionRedacteursState();
}

class _PageGestionRedacteursState extends State<PageGestionRedacteurs> {
  // Liste pour stocker les rédacteurs
  late Future<List<Redacteur>> _redacteursFuture;

  // Contrôleurs pour les champs de texte
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _searchController = TextEditingController();

  // Cette fonction est appelée pour recharger la liste des rédacteurs
  void refreshRedacteurs({String? query}) {
    setState(() {
      if (query != null && query.isNotEmpty) {
        // Appelle la méthode de recherche dans DatabaseManager
        _redacteursFuture = DatabaseManager.instance.searchRedacteurs(query);
      } else {
        _redacteursFuture = DatabaseManager.instance.getAllRedacteurs();
      }
    });
  }

  // Fonction pour ajouter un nouveau rédacteur
  Future<void> _addRedacteur() async {
    // Vérification des champs de texte
    if (_nomController.text.isEmpty || _prenomController.text.isEmpty || _emailController.text.isEmpty) {
      // Afficher un message d'erreur à l'utilisateur
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez remplir tous les champs !'),
          backgroundColor: Colors.red,
        ),
      );
      return; // Sort de la fonction si les champs sont vides
    }

    final newRedacteur = Redacteur(
      nom: _nomController.text,
      prenom: _prenomController.text,
      email: _emailController.text,
    );
    await DatabaseManager.instance.insertRedacteur(newRedacteur);
    _nomController.clear();
    _prenomController.clear();
    _emailController.clear();
    refreshRedacteurs();
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
                await DatabaseManager.instance.updateRedacteur(updatedRedacteur);
                if (!mounted) return;
                Navigator.of(dialogContext).pop();
                refreshRedacteurs();
              },
            ),
          ],
        );
      },
    );
  }

  // Affiche une boîte de dialogue de confirmation pour la suppression
  Future<void> _showDeleteConfirmationDialog(int id) async {
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
                await DatabaseManager.instance.deleteRedacteur(id);
                if (!mounted) return;
                Navigator.of(dialogContext).pop();
                refreshRedacteurs();
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
    _redacteursFuture = DatabaseManager.instance.getAllRedacteurs();
    _searchController.addListener(() {
      refreshRedacteurs(query: _searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
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
                decoration: InputDecoration(
                  hintText: 'Rechercher...',
                  hintStyle: const TextStyle(color: Colors.white70),
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
              } else {
                setState(() {}); // Affiche la barre de recherche
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
                style: TextStyle(color: Colors.white,
                height: 30,),),
                icon: const Icon(Icons.add,
                color: Colors.white,),
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            Expanded(
              child: FutureBuilder<List<Redacteur>>(
                future: _redacteursFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erreur: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Aucun rédacteur trouvé.'));
                  } else {
                    final redacteurs = snapshot.data!;
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
                                  _showDeleteConfirmationDialog(redacteur.id!);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}