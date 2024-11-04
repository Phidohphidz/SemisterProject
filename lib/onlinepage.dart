import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';
import 'databases/online.dart';

Future<void> main() async {
  await optsDatabase();
}

Future<void> optsDatabase() async {
  final server = await ServerSocket.bind('192.168.1.125', 4000);
  print('DB server is running');

  Onlines on = Onlines();
  await on.openOnline();
  List<Socket> clients = [];

  await for (Socket client in server) {
    print('Connected one client');
    clients.add(client);

    List<Map<String,String>> staff= await on.onlineUs();
    String jsonpple=jsonEncode(staff);
    print(jsonpple);
    client.write(jsonpple);
    handleClient(client,clients);
  }
}

Future<void> handleClient(Socket client, List clients) async{
  Onlines on = Onlines();
  await on.openOnline();
  client.listen(
        (Uint8List data) async {
      List<dynamic> all = jsonDecode(utf8.decode(data));
      if(all[0]=="appID"){
        await on.insertAppID(all[1]);
      }else if(all[0]=="studentID"){
        await on.insertUserID(all[1], all[2]);
      }else{
        List<Map<String,String>> staff= await on.onlineUs();
        String jsonpple=jsonEncode(staff);
        print(jsonpple);
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
