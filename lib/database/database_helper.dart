import 'dart:async';
import 'package:agendador_bronzeamento/database/exceptions/unique_constraint_exception.dart';
import 'package:agendador_bronzeamento/database/models/bronze.dart';
import 'package:agendador_bronzeamento/database/models/client.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() => _instance;

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('''
      PRAGMA foreign_keys = ON;
      CREATE TABLE Client (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE,
        phoneNumber TEXT,
        since TIMESTAMP,
        bronzes INTEGER,
        observations TEXT NULL,
        picture BLOB NULL
      );
      CREATE TABLE Bronze (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        clientId INTEGER,
        turnArounds INTEGER,
        totalSecs INTEGER,
        price TEXT,
        timestamp TIMESTAMP, 
        FOREIGN KEY (clientId) REFERENCES Client(id) ON DELETE CASCADE
      );
    ''');
  }

  Future<int> _insert(String table, Map<String ,dynamic> row) async {
    final db = await database;
    return await db!.insert(table, row);
  }

  Future<List<Map<String, dynamic>>> _selectAll(String table) async {
    final db = await database;
    return await db!.query(table);
  }

  Future<Map<String, dynamic>> _selectId(String table, int id) async {
    final db = await database;
    return (await db!.query(table, where: 'id = ?', whereArgs: [id])).first;
  }

  Future<int> _deleteWhere(String table, String where, List<Object?> whereArgs) async {
    final db = await database;
    return await db!.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<int> _updateWhere(String table, Map<String, Object?> values, String where, List<Object?> whereArgs) async {
    final db = await database;
    return await db!.update(table, values, where: where, whereArgs: whereArgs);
  }

  Future<int> insertBronze(Bronze bronze) async {
    Client client = Client.fromMap(await _selectId('Client', bronze.clientId));
    client.bronzes++;
    await _updateWhere('Client', client.toMap(), 'id = ?', [bronze.clientId]);
    return await _insert('Bronze', bronze.toMap());
  }

  Future<int> insertClient(Client client) async {
    int result = await _insert('Client', client.toMap());
    if (result == -1) {
      throw UniqueConstraintException('name');
    }
    return result;
  }

  Future<List<Bronze>> selectAllBronzes() async {
    List<Map<String, dynamic>> mapList = await _selectAll('Bronze');
    return mapList.map((map) => Bronze.fromMap(map)).toList();
  }

  Future<List<Client>> selectAllClients() async {
    List<Map<String, dynamic>> mapList = await _selectAll('Client');
    return mapList.map((map) => Client.fromMap(map)).toList();
  }

  Future<int> deleteClient(Client client) async {
    return _deleteWhere('Client', 'id = ?', [client.id]);
  }

  Future<int> updateClient(Client client) async {
    return _updateWhere('Client', client.toMap(), 'id = ?', [client.id]);
  }
}
