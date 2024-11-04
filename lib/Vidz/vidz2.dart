import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MaterialApp(home: VideoStream(camera: cameras.first)));
}

class VideoStream extends StatefulWidget {
  final CameraDescription camera;

  const VideoStream({required this.camera});

  @override
  _VideoStreamState createState() => _VideoStreamState();
}

class _VideoStreamState extends State<VideoStream> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late Socket _socket;

  @override
  void initState() {
    super.initState();

    // Initialize the camera
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();

    // Connect to the TCP server
    _connectToServer();
  }

  void _connectToServer() async {
    try {
      // Connect to the server (ensure the IP and port match your server)
      _socket = await Socket.connect('localhost', 4040); // Use your server IP
      print('Connected to server');

      // Start streaming video frames
      _startVideoStream();
    } catch (e) {
      print('Error connecting to server: $e');
    }
  }

  void _startVideoStream() {
    // Start image stream
    _controller.startImageStream((CameraImage image) {
      // Convert the image to bytes
      List<int> bytes = _convertYUV420toBytes(image);

      // Send the byte data to the server
      _socket.add(Uint8List.fromList(bytes));
    });
  }

  // Convert CameraImage (YUV420) to a byte array
  List<int> _convertYUV420toBytes(CameraImage image) {
    // Just sending the Y plane for simplicity
    final List<Plane> planes = image.planes;
    return planes[0].bytes; // Return the byte array from the Y plane
  }

  @override
  void dispose() {
    // Stop image stream and dispose of the controller when the widget is disposed
    _controller.stopImageStream();
    _controller.dispose();
    _socket.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Video Stream')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
