import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';
import 'Msgs.dart';

Future<void> main() async {
  await optsDatabase();
}

Future<void> optsDatabase() async {
  final server = await ServerSocket.bind('192.168.1.125', 8000);
  print('DB server is running');

  List<Socket> clients = [];

  await for (Socket client in server) {
    print('Connected one client');
    clients.add(client);
    handleClient(client,clients);
  }
}

Future<void> handleClient(Socket client, List clients) async{
  DataBase data1=DataBase();
  await data1.openConnection();
  client.listen(
        (Uint8List data) async {
      List<dynamic> all = jsonDecode(utf8.decode(data));
      if(all[0]=='insert') {
        data1.insertMsgs(all[1], all[2], all[3]);
      }else{
        List<Map<String,String>> staff= await data1.retrieveMsgs(all[0]);
        String jsonpple=jsonEncode(staff);
        print(jsonpple);
        client.write(jsonpple);
      }
    },
    onError: (error) {
      print('Error: $error');
    },
    onDone: () {
      print('Client disconnected: ${client.remoteAddress.address}:${client.remotePort}');
      client.close();
    },
  );
}
