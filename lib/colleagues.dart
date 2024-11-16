import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'textChat.dart';
import 'databases/online.dart';


void main() => runApp(MaterialApp(
  onGenerateRoute: (settings) {
    if (settings.name == '/inbox') {
            final args = settings.arguments as Map<String, dynamic>;
            print(args.toString());
      return MaterialPageRoute(
        builder: (context) {
          return Chat(
            appID: args['appID'] ?? "halm",
            studentID: args['studentID'] ?? "No ID",
          );
        },
      );
    }
    return MaterialPageRoute(builder: (context) => Colls());
  },
));


class Colls extends StatefulWidget {
  const Colls({super.key});

  @override
  State<Colls> createState() => _CollsState();
}

class _CollsState extends State<Colls> {
  List<Widget> coll = [];
  late Onlines send1;

  @override
  void initState() {
    super.initState();
    send1=Onlines();
    Update();
  }
  void Update() async{
    await send1.openOnline();
    List<dynamic> ppleList=await send1.onlineUs();
    print(ppleList.toString());
    for (var hi in ppleList) {
      setState(() {
        coll.add(
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed("/inbox", arguments: {"appID": hi["id"]!=null?hi["id"]:"no ID", "studentID": hi["studentID"]!=null?hi["studentID"]:"no ID"});
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.person),
                    color: Color(0xff0fd4fe),
                  ),
                  Column(children: [
                    Text(
                      hi["id"],
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                          color: Color(0xff0fd4fe),
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Text(
                      hi["studentID"] ?? "unknown",
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                          color: Color(0xff0fd4fe),
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ]),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.menu,
                      color: Color(0xff2d87af),
                      size: 25,
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xff0f6c92)),
                  top: BorderSide(color: Color(0xff0f6c92)),
                ),
              ),
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0b1c26),
      appBar: AppBar(
        backgroundColor: const Color(0xff0b1c26),
        title: Text(
          "Online",
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
              color: Color(0xff0fd4fe),
              fontSize: 30,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [...coll],
          ),
        ),
      ),
    );
  }
}
