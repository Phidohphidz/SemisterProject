import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'post.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  Future<void> loadPosts() async {
    final String response =
        await rootBundle.loadString('lib/assets/posts/data.json');
    final List<dynamic> data = json.decode(response);

    setState(() {
      posts = data.map((json) => Post.fromJson(json)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0b1c26),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: posts.map((post) {
            return Container(
              decoration: const BoxDecoration(
                  color: Color(0xff08161c),
                  border: Border(
                      top: BorderSide(color: Color(0xff3a474e), width: 2))),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Icons.person,
                            color: Color(0xff00b2fd),
                            size: 30,
                            shadows: [
                              Shadow(
                                  color: Color(0xff0b1c26).withOpacity(0.5),
                                  blurRadius: 10,
                                  offset: Offset(5, 5))
                            ],
                          ),
                          Text(
                            post.Id + '  @' + post.name,
                            style: GoogleFonts.roboto(
                                textStyle: TextStyle(
                              color: Colors.blue,
                              fontSize: 15,
                            )),
                          ),
                          Icon(
                            Icons.menu,
                            color: Color(0xff00b2fd),
                            size: 30,
                            shadows: [
                              Shadow(
                                  color: Color(0xff0b1c26).withOpacity(0.5),
                                  blurRadius: 10,
                                  offset: Offset(5, 5))
                            ],
                          ),
                        ]),
                  ),
                  Padding(
                    padding: EdgeInsets.all(0),
                    child: Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                            left: 3, top: 0, right: 0, bottom: 5),
                        child: Column(
                          children: [
                            post.post['text'] != 'none'
                                ? Text(
                                    post.post['text'],
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                      color: Color(0xfff8eef0),
                                      fontSize: 20,
                                    )),
                                  )
                                : Text(''),
                            post.post['media']['image'] != 'none'
                                ? Center(
                                    child: Image.network(
                                      width: double.infinity,
                                      post.post['media']['image'],
                                    ),
                                  )
                                : Text(''),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                    onPressed: () {},
                                    child: Row(
                                      children: [
                                        Icon(Icons.thumb_up),
                                        SizedBox(width: 5),
                                        Text(post.post['reactions']['Likes'])
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xff0b1c26),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 20))),
                                ElevatedButton(
                                    onPressed: () {},
                                    child: Row(
                                      children: [
                                        Icon(Icons.comment),
                                        SizedBox(width: 5),
                                        Text(post.post['reactions']['Comments'])
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xff0b1c26),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 20))),
                                ElevatedButton(
                                    onPressed: () {},
                                    child: Row(
                                      children: [
                                        Icon(Icons.share_outlined),
                                        SizedBox(width: 5),
                                        Text(post.post['reactions']['Share'])
                                      ],
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xff0b1c26),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 5, horizontal: 20))),
                              ],
                            )
                          ],
                        )),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
