import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'msgs.dart';
import 'SendReceive.dart';
import 'databases/MsgsClient.dart';

void main()=>runApp(MaterialApp(
  home: Chat(appID: "Halla",studentID: "BScICT/22/032",),
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
  List<MSG> msgs = [];
  List<Widget> WidgetList2 = [];
  int i = 0;

  late SendReceive send1;
  late Msgs msgs2;
  Msgs sends=Msgs();

  @override
  void initState() {
    super.initState();

    inter(sends);
    sends.onMessageReceived = (message) {
      List<dynamic> allMsgs=jsonDecode(message);
      print(allMsgs.toString());
      for(var msg in allMsgs){
        Update(msg["msg"], msg["type"]);
      }
    };

    send1 = SendReceive();
    send1.onMessageReceived = (message) {
      Update(message, "recieve");
    };
  }

  Future<void> inter(Msgs sends)async{
    await sends.connect();
    List<String> opts=["bscict_22_032_bscict_22_042"];
    String get=jsonEncode(opts);
    sends.send(get);
  }

  void Update(message, type) {
    setState(() {
      WidgetList2.add(
        Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: type == "recieve" ? CrossAxisAlignment.start : CrossAxisAlignment.end,
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
                          '3:00',
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

  void insertMSGs(String room,String msg, String type){
    List<String> message=["insert",room,msg,type];
    String msg2=jsonEncode(message);
    sends.send(msg2);
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
              Icon(
                Icons.account_circle,
                color: const Color(0xff00b2fd),
                size: 30,
                shadows: [
                  Shadow(
                    color: const Color(0xff0b1c26).withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(5, 5),
                  ),
                ],
              ),
              Column(
                children: [

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

              Icon(
                Icons.menu,
                color: const Color(0xff00b2fd),
                size: 30,
                shadows: [
                  Shadow(
                    color: const Color(0xff0b1c26).withOpacity(0.5),
                    blurRadius: 10,
                    offset: const Offset(5, 5),
                  ),
                ],
              ),
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
                      ...WidgetList2,
                    ]
                  ),
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
                          borderSide: BorderSide(color: Colors.indigo, width: 2.0),
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
    );
  }
}
