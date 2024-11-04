import 'package:postgres/postgres.dart';

class Onlines {
  late PostgreSQLConnection connection;

  Onlines() {
    connection = PostgreSQLConnection('localhost', 5432, 'Online',
        username: 'postgres', password: 'warge');
  }

  Future<void> openOnline() async {
    try {
      await connection.open();
      print("Database connected");
    } catch (e) {
      print("No connection: $e");
    }
  }

  Future<void> insertAppID(String appID) async {
    try {
      await connection.query('''
      CREATE TABLE IF NOT EXISTS onlinePple(
      appid VARCHAR(100),
      studentID VARCHAR(100)
      );
      ''');

      await connection.query('''INSERT INTO onlinePple(appid)
        VALUES(@appid)''', substitutionValues: {
        'appid': appID
      });
      print("Online updated");
    } catch (e) {
      print("Connection error: $e");
    }
  }

  Future<void> insertUserID(String appID,String studentID) async{
    await connection.query('''
    UPDATE onlinePple 
    SET studentID = @studentid
    WHERE appid=@appid ''',
    substitutionValues: {
      'studentid':studentID,
      'appid':appID
    }
    );
  }

  Future<List<Map<String,String>>> onlineUs() async{
    List<Map<String,String>> People=[];
    try{
      List<List<dynamic>> results = await connection.query('''
      SELECT * FROM onlinePple
      ''');

      for (var row in results){
        People.add({"id":row[0],'studentID':row[1]!=null?row[1]:"no ID"});
      }
    }catch(e){
      print("Cannot: $e");
    }

    return People;
  }

  Future<void> closeConnection() async {
    await connection.close();
    print('Connection closed.');
  }
}

