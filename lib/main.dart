import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'posts.dart';

void main() => runApp(const MaterialApp(
      home: HomePage(),
    ));

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0b1c26),
      appBar: AppBar(
        backgroundColor: const Color(0xff0b1c26),
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MySchool',
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        color: Color(0xff0fd4fe),
                        fontSize: 30,
                      ),
                    ),
                  ),
                  Image.asset(
                    'lib/assets/images/editedLogo.png', // Corrected image path
                    width: 50,
                    height: 50,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: const PostsPage(),
    );
  }
}
