import 'dart:async';
import 'package:agendador_bronzeamento/database/exceptions/unique_constraint_exception.dart';
import 'package:agendador_bronzeamento/database/models/bronze.dart';
import 'package:agendador_bronzeamento/database/models/client.dart';
import 'package:agendador_bronzeamento/database/models/config.dart';
import 'package:decimal/decimal.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
    final path = await getDatabasesPath();
    final finalPath = join(path, 'base_de_dados.db');
    return await openDatabase(
      finalPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(enableForeignKeys);
        await db.execute(clientTable);
        await db.execute(bronzeTable);
        await db.execute(configTable);
      },
      onOpen: (db) {
        db.execute(enableForeignKeys);
      },
    );
  }

  Future<bool> isValidDatabase(String dbPath) async {
    Database db = await openDatabase(dbPath);
    List<Map<String, Object?>> clientInfo = await db.rawQuery('PRAGMA table_info(Client);');
    List<Map<String, Object?>> bronzeInfo = await db.rawQuery('PRAGMA table_info(Bronze);');
    String clientInfoStr = '[{cid: 0, name: id, type: INTEGER, notnull: 0, dflt_value: null, pk: 1}, {cid: 1, name: name, type: TEXT, notnull: 0, dflt_value: null, pk: 0}, {cid: 2, name: phoneNumber, type: TEXT, notnull: 0, dflt_value: null, pk: 0}, {cid: 3, name: since, type: TIMESTAMP, notnull: 0, dflt_value: null, pk: 0}, {cid: 4, name: bronzes, type: INTEGER, notnull: 0, dflt_value: null, pk: 0}, {cid: 5, name: observations, type: TEXT, notnull: 0, dflt_value: null, pk: 0}, {cid: 6, name: picture, type: BLOB, notnull: 0, dflt_value: null, pk: 0}]';
    String bronzeInfoStr = '[{cid: 0, name: id, type: INTEGER, notnull: 0, dflt_value: null, pk: 1}, {cid: 1, name: clientId, type: INTEGER, notnull: 0, dflt_value: null, pk: 0}, {cid: 2, name: turnArounds, type: INTEGER, notnull: 0, dflt_value: null, pk: 0}, {cid: 3, name: totalSecs, type: INTEGER, notnull: 0, dflt_value: null, pk: 0}, {cid: 4, name: price, type: TEXT, notnull: 0, dflt_value: null, pk: 0}, {cid: 5, name: timestamp, type: TIMESTAMP, notnull: 0, dflt_value: null, pk: 0}]';
    return clientInfo.toString() == clientInfoStr && bronzeInfo.toString() == bronzeInfoStr;
  }

  Future<void> migrateDatabase(String dbPath) async {
    print('MIGRATING...');
  }

  static const clientTable = '''
    CREATE TABLE IF NOT EXISTS Client (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT UNIQUE,
      phoneNumber TEXT,
      since TIMESTAMP,
      bronzes INTEGER,
      observations TEXT NULL,
      picture BLOB NULL
    );''';

  static const enableForeignKeys = 'PRAGMA foreign_keys = ON;';
  
  static const bronzeTable = '''
    CREATE TABLE IF NOT EXISTS Bronze (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      clientId INTEGER,
      turnArounds INTEGER,
      totalSecs INTEGER,
      price TEXT,
      timestamp TIMESTAMP, 
      FOREIGN KEY (clientId) REFERENCES Client(id) ON DELETE CASCADE
    );
  ''';

  static const configTable = '''
    CREATE TABLE IF NOT EXISTS Config (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      totalSecs INTEGER,
      turnArounds INTEGER,
      price TEXT
    );
  ''';

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

  Future<Config> selectConfig() async {
    List<Map<String, Object?>> mapList = await _selectAll('Config');
    if (mapList.isEmpty) {
      return await insertConfig(await DatabaseHelper().insertConfig(
        Config.toSave(
          defaultHours: 0,
          defaultMins: 0,
          defaultSecs: 1, 
          turnArounds: 1, 
          price: Decimal.ten
        )
      ));
    }
    return Config.fromMap(mapList[0]);
  }

  Future<Config> insertConfig(Config config) async {
    await _insert('Config', config.toMap());
    return await selectConfig();
  }

  Future<int> updateConfig(Config config) async {
    return await _updateWhere('Config', config.toMap(), 'id = ?', [config.id]);
  }

  Future<int> deleteClient(Client client) async {
    return _deleteWhere('Client', 'id = ?', [client.id]);
  }

  Future<int> updateClient(Client client) async {
    return _updateWhere('Client', client.toMap(), 'id = ?', [client.id]);
  }

  Future<int> deleteBronzes(List<Bronze> bronzes) async {
    int lastDeleted = -1;
    for (Bronze bronze in bronzes) {
      lastDeleted = await _deleteWhere('Bronze', 'id = ?', [bronze.id]);
    }
    return lastDeleted;
  }
}
