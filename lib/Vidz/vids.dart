import 'dart:io';

void main() async {
  // Start the TCP server
  final server = await ServerSocket.bind("localhost", 4040);
  print('Server running on ${server.address.address}:${server.port}');

  // Listen for incoming connections
  await for (final socket in server) {
    print('Client connected: ${socket.remoteAddress.address}:${socket.remotePort}');

    // Handle incoming data
    socket.listen(
          (data) {
        // Process incoming video frame data
        print('Received data of length: ${data.length}');
        // You can further process the data, save it, etc.
      },
      onDone: () {
        print('Client disconnected: ${socket.remoteAddress.address}:${socket.remotePort}');
      },
    );
  }
}
