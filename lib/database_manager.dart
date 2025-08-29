import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'Modele/redacteur.dart'; // Importe la classe Redacteur que nous avons créée

class DatabaseManager {
  // Crée un constructeur privé pour s'assurer qu'il n'y a qu'une seule instance de cette classe
  DatabaseManager._();

  // Crée une instance unique (singleton) de la classe DatabaseManager
  static final DatabaseManager instance = DatabaseManager._();

  // Variable pour stocker l'objet de la base de données
  static Database? _database;

  // Méthode pour obtenir la base de données
  Future<Database> get database async {
    // Si la base de données existe déjà, la retourne
    if (_database != null) {
      return _database!;
    }
    // Sinon, l'initialise et la retourne
    _database = await _initDB('redacteurs_db.db');
    return _database!;
  }

  // Méthode pour initialiser la base de données
  Future<Database> _initDB(String filePath) async {
    // Obtient le chemin du document de la base de données
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Ouvre la base de données et crée la table 'redacteurs'
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  // Méthode pour créer la table de la base de données
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE redacteurs(
        id $idType,
        nom $textType,
        prenom $textType,
        email $textType
      )
    ''');
  }

  // Méthode pour insérer un nouveau rédacteur dans la base de données
  Future<int> insertRedacteur(Redacteur redacteur) async {
    final db = await instance.database;
    return await db.insert('redacteurs', redacteur.toMap());
  }

  // Méthode pour obtenir tous les rédacteurs de la base de données
  Future<List<Redacteur>> getAllRedacteurs() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query('redacteurs');

    return List.generate(maps.length, (i) {
      return Redacteur(
        id: maps[i]['id'],
        nom: maps[i]['nom'],
        prenom: maps[i]['prenom'],
        email: maps[i]['email'],
      );
    });
  }

  // Méthode pour rechercher des rédacteurs par nom, prénom ou email
  Future<List<Redacteur>> searchRedacteurs(String query) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'redacteurs',
      where: 'nom LIKE ? OR prenom LIKE ? OR email LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );

    return List.generate(maps.length, (i) {
      return Redacteur(
        id: maps[i]['id'],
        nom: maps[i]['nom'],
        prenom: maps[i]['prenom'],
        email: maps[i]['email'],
      );
    });
  }

  // Méthode pour mettre à jour un rédacteur existant
  Future<int> updateRedacteur(Redacteur redacteur) async {
    final db = await instance.database;
    return await db.update(
      'redacteurs',
      redacteur.toMap(),
      where: 'id = ?',
      whereArgs: [redacteur.id],
    );
  }

  // Méthode pour supprimer un rédacteur
  Future<int> deleteRedacteur(int id) async {
    final db = await instance.database;
    return await db.delete(
      'redacteurs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
