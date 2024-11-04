import 'package:postgres/postgres.dart';

class DataBase {
  late PostgreSQLConnection connection;

  DataBase() {
    connection = PostgreSQLConnection(
      'localhost',
      5432,
      'Messages',
      username: 'postgres',
      password: 'warge',
    );
  }

  Future<void> openConnection() async {
    try {
      await connection.open();
      print('Connected to the database!');
    } catch (e) {
      print('Connection failed: $e');
    }
  }

  Future<void> insertMsgs(String room, String msg, String type) async {
    try {
      await connection.query('''
        CREATE TABLE IF NOT EXISTS $room (
          id SERIAL PRIMARY KEY,
          msg VARCHAR(100),
          type VARCHAR(100)
        );
      ''');

      await connection.query('''
        INSERT INTO $room (msg, type)
        VALUES (@msg, @type)
      ''', substitutionValues: {
        "msg": msg,
        "type": type,
      });

      print("Data inserted successfully.");
    } catch (e) {
      print('Insertion failed: $e');
    }
  }

  Future<List<Map<String, String>>> retrieveMsgs(String room) async {
    List<Map<String, String>> messages = [];

    try {
      List<List<dynamic>> results = await connection.query('SELECT msg, type FROM $room;');
      for (final row in results) {
        messages.add({
          'msg': row[0],
          'type': row[1],
        });
      }
      print("Data retrieved successfully.");
    } catch (e) {
      print('Retrieval failed: $e');
    }

    return messages;
  }

  Future<void> closeConnection() async {
    await connection.close();
    print('Connection closed.');
  }
}

Future<void> main() async {
  DataBase db = DataBase();

  await db.openConnection();
  List<Map<String, String>> messages = await db.retrieveMsgs("Bs");
  print(messages);

  await db.closeConnection();
}
