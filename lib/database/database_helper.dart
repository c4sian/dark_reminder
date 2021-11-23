import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dark_reminder/model/event.dart';

class EventsDatabase {
  static final EventsDatabase instance = EventsDatabase._init();

  static Database? _database;

  EventsDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';

    await db.execute('''
          CREATE TABLE $tableEvents( 
            ${EventFields.id} $idType, 
            ${EventFields.title} $textType,
            ${EventFields.fromDate} $textType,
            ${EventFields.toDate} $textType,
            ${EventFields.isAllDay} $boolType,
            ${EventFields.description} $textType
            )
            ''');
  }

  Future<Event> create(Event event) async {
    final db = await instance.database;

    final id = await db.insert(tableEvents, event.toJson());
    return event.copy(id: id);
  }

  Future<Event> readEvent(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableEvents,
      columns: EventFields.values,
      where: '${EventFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Event.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Event>> readAllEvents() async {
    final db = await instance.database;

    final orderBy = '${EventFields.fromDate} ASC';

    final result = await db.query(tableEvents, orderBy: orderBy);

    return result.map((json) => Event.fromJson(json)).toList();
  }

  Future<int> update(Event event) async {
    final db = await instance.database;

    return db.update(
      tableEvents,
      event.toJson(),
      where: '${EventFields.id} = ?',
      whereArgs: [event.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableEvents,
      where: '${EventFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
