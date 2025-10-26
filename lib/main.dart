import 'package:activite1/pages/ajouter_redacteur_page.dart';
import 'package:activite1/pages/gestion_redacteurs_page.dart';
import 'package:flutter/material.dart';
// Nouveaux imports nécessaires pour Firebase
import 'package:firebase_core/firebase_core.dart';
// Assurez-vous que ce fichier existe (généré par FlutterFire)
import 'firebase_options.dart'; 


// Fonction principale asynchrone pour l'initialisation de Firebase
void main() async {
  // Assure que les bindings Flutter sont initialisés
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Initialisation de Firebase
  // Remplace l'ancienne initialisation de la base de données SQLite
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Il est crucial d'afficher l'erreur si l'initialisation échoue
    print("Erreur lors de l'initialisation de Firebase: $e");
    // Optionnel: Afficher une erreur à l'utilisateur ici si Firebase est vital
  }
  
  runApp(const MonAppli());
}

class MonAppli extends StatelessWidget {
  const MonAppli({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Magazine',
      debugShowCheckedModeBanner: false,
      home: PageAccueil(),
    );
  }
}

class PageAccueil extends StatelessWidget {
  const PageAccueil({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Magazine Infos', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 239, 7, 84),
        leading: Builder(
          builder: (BuildContext innerContext) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(innerContext).openDrawer(), 
              color: Colors.white,
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
              // Affiche une boîte de dialogue de recherche
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Recherche'),
                    content: const Text('La fonctionnalité de recherche sera bientôt disponible.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ), 
      // Ajout le widget Drawer 
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 239, 7, 84),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('ajouter redacteur'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AjouterRedacteurPage()),
                );
              },
            ),
            // Bouton de navigation vers la page de gestion des rédacteurs
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Gestion des rédacteurs'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GestionRedacteursPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () {
                Navigator.pop(context);
              },
            ), 
          ],
        ),
      ),
      body: SingleChildScrollView( 
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 450.0,
              // Assurez-vous que l'image 'assets/images/image1.jpg' est disponible dans les assets
              child: Image.asset(
                'assets/images/image1.jpg',
                fit: BoxFit.cover,
              ), 
            ),
            const SizedBox(height: 16.0),
            const PartieTitre(), 
            const PartieTexte(),
            const PartieIcone(),
            const PartieRubrique(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Message"),
                content: const Text("Vous avez cliqué !"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.pinkAccent,
        child: const Text('Click'),
      ),
    );
  }
}

class PartieTitre extends StatelessWidget {
  const PartieTitre({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bienvenue au Magazine Infos',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text("Votre Magazine numérique, votre source d'inspiration",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
class PartieTexte extends StatelessWidget {
  const PartieTexte({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: const Text("Magazine Infos est bien plus qu'un simple magazine d'informations. C'est votre passerelle vers le monde , une source inestimable de connaissances et d'actualités soigneusement sélectionnées pour vous éclairer sur des enjeux mondiaux, la culture, la science, la, et voir meme le divertissement(le jeux).",
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}
class PartieIcone extends StatelessWidget {
  const PartieIcone({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionIcon(Icons.phone, "TEL"),
          _buildActionIcon(Icons.mail, "MAIL"),
          _buildActionIcon(Icons.share, "PARTAGE"),
        ],
      ),
    );
  }
  Widget _buildActionIcon(IconData icon, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.pink, size: 30),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(color: Colors.pink),
        ),
      ],
    );
  }
}
class PartieRubrique extends StatelessWidget {
  const PartieRubrique({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              'assets/images/image2.jpg',
              fit: BoxFit.cover,
            ),
          )
          ),
          const SizedBox (width: 20.0),
          Expanded(child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              'assets/images/image3.jpg',
              fit: BoxFit.cover,
            ),
          ) 
          ),
        ],
      ),
    );
  }
}