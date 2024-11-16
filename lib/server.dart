import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:math';
import 'package:semesterprog/databases/online.dart';
Future<void> main() async {
  final server = await ServerSocket.bind("192.168.1.125", 3000);
  print('Server is running on: ${server.address.address}:${server.port}');

  Map<String,Socket> clients = {};
  Random rand=Random();

  Onlines online = Onlines();

  await online.openOnline();

  await for (Socket client in server) {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    String clientID=List.generate(10, (index) => characters[rand.nextInt(characters.length)]).join();
    clients[clientID.toString()]=client;
    print('Client connected: ${client.remoteAddress.address}:${client.port}');
    online.insertAppID(clientID);
    handleClient(client, clients);
  }
}

void handleClient(Socket client, Map<String,Socket> clients) {
  final buffer = <int>[];
  int expectedBytes = 0;
  client.listen(
    (Uint8List data) {
        List<dynamic> all=jsonDecode(utf8.decode(data));
        String message=all[0];
        print(message);
        String to=all[1];
        for (var c in clients.keys) {
          if (clients[c] != client) {
            clients[c]?.write('$message');
          }else{
            print('sender ${c}');
          }
        }
    },
    onError: (error) {
      print('Error: $error');
      clients.remove(client);
      client.close();
    },
    onDone: () {
      print(
          'Client disconnected: ${client.remoteAddress.address}:${client.port}');
      clients.remove(client);
      client.close();
    },
  );
}
