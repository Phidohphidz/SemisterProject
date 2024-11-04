import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

class SendReceive {
  Socket? socket;
  Function(String)? onMessageReceived;

  SendReceive({this.onMessageReceived}) {
    _connect();
  }

  Future<void> _connect() async {
    try {
      socket = await Socket.connect('192.168.1.125', 3000);
      print("Connected to the server");

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

  void send(List<String> message) {
    if (socket != null) {
      String jsonMsg=jsonEncode(message);
      socket!.write(jsonMsg);
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
