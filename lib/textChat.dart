import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:semesterprog/databases/Msgs.dart';
import 'msgs.dart';
import 'SendReceive.dart';

void main() => runApp(MaterialApp(
      home: Chat(
        appID: "Halla",
        studentID: "BScICT/22/042",
      ),
    ));

class Chat extends StatefulWidget {
  final String appID;
  final String studentID;
  Chat({required this.appID, required this.studentID});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _msg = TextEditingController();
  final TextEditingController _getID = TextEditingController();
  List<Widget> WidgetList2 = [];
  int i = 0;
  int h = 0;

  late SendReceive send1;

  late DataBase db;
  @override
  void initState() async{
    super.initState();
    db=DataBase();
    await db.openConnection();

    send1 = SendReceive();
    send1.onMessageReceived = (message) {
      Update(message, "recieve");
    };
  }

  void Update(message, type) {
    setState(() {
      WidgetList2.add(
        Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: type == "recieve"
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: 250),
                margin: EdgeInsets.all(0),
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      softWrap: true,
                      style: GoogleFonts.roboto(
                        color: Color(0xffddded9),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '4:00',
                          style: GoogleFonts.roboto(color: Color(0xff41a7cd)),
                        )
                      ],
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: Color(0xff0f212d),
                  border: Border.all(color: Color(0xff0d2230), width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      );
    });
  }

  void insertMSGs(String room, String msg, String type) async{
    await db.insertMsgs(room, msg, type);
  }

  String pos = 'start';
  DateTime now = DateTime.now();
  String partID = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0b1c26),
      appBar: AppBar(
        backgroundColor: const Color(0xff0b1c26),
        elevation: 0.5,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: const Color(0xff00b2fd),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: _getID,
                  decoration: InputDecoration(
                    hintText: "Enter your studentID",
                    hintStyle: GoogleFonts.roboto(
                      color: Color(0xff004e6a),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    counterText: "",
                  ),
                  style: GoogleFonts.roboto(
                    color: Color(0xff00b2fd),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLength: 13,
                ),
              ),
              SizedBox(width: 20),
              Column(children: [
                Text(
                  widget.appID,
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                    ),
                  ),
                ),
                Text(
                  widget.studentID,
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      color: Colors.blue,
                      fontSize: 15,
                    ),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        ...WidgetList2,
                      ]),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.08,
              width: double.infinity,
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Color(0xff0b1c26),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msg,
                      decoration: InputDecoration(
                        labelText: "Enter your message",
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.indigo, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xff00b2fd),
                            width: 1.0,
                          ),
                        ),
                      ),
                      style: GoogleFonts.roboto(
                        color: Color(0xffddded9),
                      ),
                    ),
                  ),
                  SizedBox(width: 2),
                  IconButton(
                    onPressed: () {
                      String msg = _msg.text;
                      send1.send([msg, "BSCICT/22/032"]);
                      Update(msg, "send");
                      insertMSGs("bscict_22_032_bscict_22_042", msg, "send");
                      _msg.clear();
                    },
                    icon: Icon(
                      Icons.send,
                      size: 30,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff0b1c26),
                      foregroundColor: Color(0xff00b2fd),
                      padding: EdgeInsets.all(0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 100),
        child: FloatingActionButton(
          onPressed: () {
            String id = _getID.text;
            if (h == 0) {
              if (id.isEmpty) {
                print("no ID");
              } else {
                setState(() {
                  h = 1;
                  WidgetList2 = [];
                });
                String replaced = (id.replaceAll("/", "_") +
                        "_" +
                        widget.studentID.replaceAll("/", "_"))
                    .toLowerCase();
                //inter(sends, replaced);
              }

            } else {
              setState(() {
                h = 0;
                WidgetList2 = [];
              });
              print("Halla");
            }
          },
          child: Icon(
            Icons.history,
            size: 25,
          ),
          backgroundColor: Color(0xff0f212d),
          foregroundColor: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
