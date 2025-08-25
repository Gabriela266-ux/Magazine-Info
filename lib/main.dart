import 'package:flutter/material.dart';


void main() {

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
    return  Scaffold(
      appBar: AppBar(
      title: const Text('Magazine Infos', style: TextStyle(color: Colors.white),),
      centerTitle: true,
      backgroundColor: const Color.fromARGB(255, 239, 7, 84),
       leading: Builder( // Enveloppez l'IconButton dans un Builder
    builder: (BuildContext innerContext) {
      return IconButton(
         icon: const Icon(Icons.menu),
        onPressed: () => Scaffold.of(innerContext).openDrawer(), 
        color: Colors.white,
      );
    },
  ),
      actions:  [
  IconButton(
    icon: const Icon(Icons.search),
    color: Colors.white,
    onPressed: () {
      // Affiche une boîte de dialogue
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Recherche'),
            content: const Text('La fonctionnalité de recherche sera bientôt disponible.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Ferme la boîte de dialogue
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
        leading: const Icon(Icons.settings),
        title: const Text('Paramètres'),
        onTap: () {
         // Logique pour naviguer vers les paramètres
         Navigator.pop(context);
       },
     ),
     ListTile(
        leading: const Icon(Icons.person),
       title: const Text('Profil'),
       onTap: () {
            // Logique pour naviguer vers le profil
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
              height: 450.0, // Hauteur de 200 pixels
              child: Image.asset(
                'assets/images/image1.jpg',
                fit: BoxFit.cover,), // L'image remplit le conteneur
          ),
          SizedBox(height: 16.0,),
         PartieTitre(), 
         PartieTexte(),
         PartieIcone(),
         PartieRubrique(),
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
                      Navigator.of(context).pop(); // Ferme la boîte de dialogue
                    },
                    child: const Text("OK"),
                  ),
                ],
              );
            },
            );
        },
        backgroundColor: Colors.pinkAccent,
       child: Text('Click'),
    ),
    
    );
  }
}
class PartieTitre extends StatelessWidget {
  const PartieTitre({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
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
          SizedBox(height: 8,),
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
    return  Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text("Magazine Infos est bien plus qu'un simple magazine d'informations. C'est votre passerelle vers le monde , une source inestimable de connaissances et d'actualités soigneusement sélectionnées pour vous éclairer sur des enjeux mondiaux, la culture, la science, la, et voir meme le divertissement(le jeux).",
      style: TextStyle(fontSize: 16),
      ),
    );
  }
}
class PartieIcone extends StatelessWidget {
  const PartieIcone({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.all(10.0),
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Espacement égal entre les icônes [cite: 105]
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
        Icon(icon, color: Colors.pink, size: 30), // Icône avec une couleur rose 
        const SizedBox(height: 5), // Espace vertical de 5 pixels 
        Text(
          label, // Libellé en majuscules 
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
    return  Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(child: ClipRRect(
           borderRadius: BorderRadiusGeometry.circular(10.0),
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
               fit: BoxFit.cover,),
          ) 
          ),
        ],
      ),
    );
  }
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
