import 'dart:async';

import 'package:algolia/algolia.dart';
import 'package:ar_ai_messaging_client_frontend/app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart' as core;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import '../app_theme.dart';
import '../models/user_algolia_profile.dart';
import '../pages/home_list.dart';
import '../theme.dart';
import '../widgets/avatar.dart';
import '../widgets/display_error_message.dart';
import '../widgets/icon_buttons.dart';
import '../widgets/search_bars.dart';

class FriendSearchScreenFb extends StatefulWidget {
  static Route get route => MaterialPageRoute(
        builder: (context) => FriendSearchScreenFb(),
      );

  FriendSearchScreenFb({Key? key}) : super(key: key);

  @override
  State<FriendSearchScreenFb> createState() => FriendSearchScreenFbState();
}

class FriendSearchScreenFbState extends State<FriendSearchScreenFb> {
  TextEditingController controller = TextEditingController();

  final useremail = FirebaseAuth.instance.currentUser?.email;

  List<UserAlgoliaProfile> resultList = [];
  List<String> friendEmails = [];
  final docRef = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.email);

  Future<void> _getSearchResult(String query) async {
    AlgoliaQuery algoliaQuery = AlgoliaClient()
        .algoliaClient
        .instance
        .index("jammoChatUser")
        .query(query);
    AlgoliaQuerySnapshot snapshot = await algoliaQuery.getObjects();
    print("snapshot");
    print(snapshot);
    final rawData = snapshot.toMap()['hits'] as List;
    final result = List<UserAlgoliaProfile>.from(
        rawData.map((data) => UserAlgoliaProfile.fromJson(data)));
    setState(() {
      resultList = result;
    });
  }

  _addUserToFriendList(UserAlgoliaProfile friendToAdd) async {
    // Detect self adding
    String targetEmail = friendToAdd.userEmail;
    if (targetEmail == useremail) return;

    await FirebaseFirestore.instance.collection("users").doc(useremail).set({
      "friendList": {friendToAdd.userEmail: friendToAdd.userName}
    }, SetOptions(merge: true));

    await FirebaseFirestore.instance
        .collection("users")
        .doc(friendToAdd.userEmail)
        .set({
      "friendList": {
        useremail: core.StreamChatCore.of(context).currentUser?.name
      }
    }, SetOptions(merge: true));

    updateFriendList();

    Timer? timer = Timer(Duration(milliseconds: 1000), () {
      Navigator.of(context, rootNavigator: true).pop();
    });
    showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(
          'Friend Added!',
          style: GoogleFonts.openSans(fontSize: 26),
        ),
        content: Text('🥰',
            style: TextStyle(
              fontSize: 40,
            )),
      ),
    ).then((value) {
      // dispose the timer in case something else has triggered the dismiss.
      timer?.cancel();
      timer = null;
    });
  }

  updateFriendList() {
    docRef.get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        var FriList = data['friendList'] as Map<String, dynamic>;
        setState(() {
          friendEmails = FriList.keys.toList();
        });
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  @override
  void initState() {
    updateFriendList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation:0,
        centerTitle: false,
        title: Text(
          'Magic Search',
          style: GoogleFonts.lobster(fontSize: 22),
          textAlign: TextAlign.right,
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Align(
            alignment: Alignment.centerLeft,
            child: IconBackground(
              icon: CupertinoIcons.back,
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor, // 首页列表背景色 <=========
        ),
        padding: const EdgeInsets.only(top: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            SizedBox(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16), // 搜索框与手机边缘的padding
                child: Card(
                  elevation: 0.4,
                  shape: RoundedRectangleBorder(
                    //side: const BorderSide(color: Colors.blueGrey),
                    borderRadius: BorderRadius.circular(
                        16.0), //<-- SEE HERE change radius
                  ),
                  child: Container(
                    height: 40,
                    padding: const EdgeInsets.only(
                      right: 16,
                    ), // 搜索框内部图标和文字于border之间的padding
                    child: TextField(
                      // 文本框+图标
                      controller: controller,
                      onChanged: (String s) {
                        if (s.isNotEmpty) {
                          setState(() {
                            _getSearchResult(s);
                          });
                        }
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          CupertinoIcons.search,
                          size: 24,
                        ),
                        border: InputBorder.none,
                        hintText: 'Search here ...',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          color: AppColors.textFaded,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
                child: (resultList.isEmpty)
                    ? Center(
                        child: Column(
                          children: [
                            SizedBox(height: 70,),
                            Text('🤔🔍',style: TextStyle(fontSize: 40),),
                            SizedBox(height: 20,),
                            Text('Try to type a name?',textAlign: TextAlign.center,),
                          ],
                        ),

                      )
                    : Scrollbar(
                        child: ListView.builder(
                          padding: const EdgeInsets.only(top: 6),
                          itemCount: resultList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              // message bar height
                              height: 80,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 6),

                              // bottom grey line
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey,
                                    width: 0.2,
                                  ),
                                ),
                              ),
                              child: ListTile(
                                  leading: Avatar.small(
                                      url: resultList[index].profilePicURL),
                                  title: Text(resultList[index].userName),
                                  subtitle: Text(
                                    resultList[index].userEmail,
                                    style: TextStyle(
                                        color: Theme.of(context).hintColor),
                                  ),
                                  trailing: Builder(
                                    builder: (BuildContext context) {
                                      if (resultList[index].userEmail ==
                                          useremail) {
                                        return ElevatedButton(
                                          onPressed: () {},
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.grey)),
                                          child: Icon(CupertinoIcons
                                              .person_alt_circle_fill),
                                        );
                                      } else if (friendEmails.contains(
                                          resultList[index].userEmail)) {
                                        return ElevatedButton(
                                          onPressed: () {},
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                      Color>(Colors.grey)),
                                          child: Icon(CupertinoIcons
                                              .check_mark_circled_solid),
                                        );
                                      } else {
                                        return ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      MyTheme.kPrimaryColor)),
                                          onPressed: () {
                                            _addUserToFriendList(
                                                resultList[index]);
                                          },
                                          child: Icon(
                                              CupertinoIcons.person_add_solid),
                                        );
                                      }
                                    },
                                  )),
                            );
                          },
                        ),
                      )),
          ],
        ),
      ),
    );
  }
}
