import 'package:give_away/models/message_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';



class DatabaseHelper {
  DatabaseHelper._internal();
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
      try{
        String path = join(await getDatabasesPath(), 'give_away.db');
        return await openDatabase(
          path,
          version: 1,
          onCreate: _onCreate,
        );

      }catch(err){
        throw Exception("Database initialization failed");
      }
  }


  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE messages('
          'id TEXT PRIMARY KEY, '
          'senderId TEXT NOT NULL, '
          'receiverId TEXT NOT NULL, '
          'content TEXT NOT NULL, '
          'timestamp INTEGER NOT NULL)',
    );
  }



  Future<int> insertMessage(MessageModel message) async {
    Database db = await database;
    return await db.insert('messages', message.toMap());
  }

  Future<List<MessageModel>> getMessages(String userId) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where: 'senderId = ? OR receiverId = ?',
      whereArgs: [userId, userId],
      orderBy: 'timestamp DESC',
    );
    return List.generate(maps.length, (i) {
      return MessageModel.fromMap(maps[i]);
    });
  }

  Future<List<String>> getChatList(String currentUserId) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.rawQuery('''
      SELECT DISTINCT otherUserId FROM (
        SELECT fromUserId as otherUserId FROM messages WHERE toUserId = ?
        UNION
        SELECT toUserId as otherUserId FROM messages WHERE fromUserId = ?
      )
    ''', [currentUserId, currentUserId]);

    return List<String>.generate(result.length, (i) {
      return result[i]['otherUserId'] as String;
    });
  }
}



//
// deleteDb()async{
//   Database db = await database;
//   await db.execute('DROP TABLE messages;');
//   print('db delted');
// }
//
// createDB() async{
//   Database db = await database;
//   await db.execute(
//     'CREATE TABLE messages('
//         'id TEXT PRIMARY KEY, '
//         'senderId TEXT NOT NULL, '
//         'receiverId TEXT NOT NULL, '
//         'content TEXT NOT NULL, '
//         'timestamp INTEGER NOT NULL)',
//   );
//   print('db created');
// }
//