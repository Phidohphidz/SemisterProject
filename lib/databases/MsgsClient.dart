import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:semesterprog/databases/Msgs.dart';

class Msgs {
  Socket? socket;
  Function(String)? onMessageReceived;

  Msgs({this.onMessageReceived}) {
    connect();
  }

  Future<void> connect() async {
    try {
      socket = await Socket.connect('192.168.1.125', 8000);
      print("Connected to the server messages");

      socket!.listen(
            (Uint8List data) {
          String message = String.fromCharCodes(data).trim();
          if (onMessageReceived != null) {
            onMessageReceived!(message);
          }
        },
        onError: (error) {
          print('Error: $error');
          _closeSocket();
        },
        onDone: () {
          print('Connection closed by the server.');
          _closeSocket();
        },
      );
    } catch (e) {
      print('Connection failed: $e');
    }
  }

  void send(String message) {
    if (socket != null) {
      socket!.write(message);
      print("Message sent: $message");
    } else {
      print("Error: Socket is not connected.");
    }
  }

  void _closeSocket() {
    socket?.destroy();
    print("Socket closed.");
  }
}



Future<void> main() async{
  sendMan();
}

Future<void> sendMan() async{

  Msgs sends=Msgs();
  await sends.connect();
  List<String> opts=["bscict_22_032_bscict_22_042"];
  String get=jsonEncode(opts);
  sends.send(get);

  sends.onMessageReceived = (message) {
    print(message);
  };
}