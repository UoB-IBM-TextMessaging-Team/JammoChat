import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart' as core;
import '../app.dart';
import 'package:ar_ai_messaging_client_frontend/app_theme.dart';
import 'package:ar_ai_messaging_client_frontend/pages/pages.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:ar_ai_messaging_client_frontend/screens/screens.dart';
import 'package:ar_ai_messaging_client_frontend/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:ar_ai_messaging_client_frontend/widgets/search_bars.dart';

import 'friend_search_screen_firebase.dart';

class HomePage extends StatefulWidget {
  static Route get route => MaterialPageRoute(
        builder: (context) => HomePage(),
      );

  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final items = [
    FloatingNavbarItem(icon: CupertinoIcons.ellipses_bubble),
    FloatingNavbarItem(icon: CupertinoIcons.list_bullet),
  ];
  int currentIndex = 0;
  final pageController = PageController();
  final useremail = FirebaseAuth.instance.currentUser?.email;
  String picture = "";

  @override
  void initState() {
    super.initState();
  }

  void onTap(int index) {
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  Future findProfilePic() async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(useremail)
          .get()
          .then((snapshot) => {picture = snapshot.data()!["profilePicURL"]});
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  choosePic() {
    if (picture == "") {
      return const AssetImage('assets/logos/app_logo.jpg');
    } else {
      return NetworkImage(picture);
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,

        // Top App Bar
        appBar: AppBar(
          toolbarHeight: 100,
          iconTheme: Theme.of(context).iconTheme,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          // App title
          title: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Jammo',
                  style: MyTheme.kAppTitle,
                ),
                Text(
                  'Chat',
                  style: MyTheme.kAppTitle,
                ),
              ],
            ),
          ),

          //top-left add button
          leadingWidth: 60,
          leading: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Align(
              alignment: Alignment.centerRight,
              child: IconPure(
                icon: CupertinoIcons.plus_app,
                onTap: () {
                  Navigator.of(context).push(
                    FriendSearchScreenFb.route
                  );
                },
              ),
            ),
          ),

          // top-right user image
          actions: [
            Hero(
              tag: 'hero-profile-picture',
              child: Padding(
                padding: const EdgeInsets.only(right: 24, top: 12),
                // child: CircleAvatar(
                //   radius: 26,
                //   backgroundColor: Color.fromARGB(255, 222, 187, 83),
                //   child: Avatar.small(
                //     url: context.currentUserImage,
                //     onTap: () {
                //       Navigator.of(context).push(UserProfile.route);
                //     },
                //   ),
                // ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .push(UserProfile.route)
                        .then((_) => setState(() {}));
                  },
                  child: FutureBuilder(
                      future: findProfilePic(),
                      builder: (context, snapshot) {
                        return CircleAvatar(
                          radius: 30,
                          backgroundImage: choosePic(),
                          backgroundColor: Theme.of(context).backgroundColor,
                        );
                      }),
                ),
              ),
            ),
          ],
        ),

        // 背景色
        backgroundColor: MyTheme.AppBarTheme, // 决定主页背景色 《======

        // body pages
        body: Ink(
          height: double.maxFinite,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor, // 首页列表背景色 <=========
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: PageView(
            scrollDirection: Axis.horizontal,
            controller: pageController,
            onPageChanged: onPageChanged,
            children: [
              HomeChat(),
              ContactsPage(),
            ],
          ),
        ),

        // Bottom Nav bar
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: FloatingNavbar(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            backgroundColor: Colors.black.withOpacity(0.5),
            width: 200,
            borderRadius: 50,
            itemBorderRadius: 50,
            currentIndex: currentIndex,
            onTap: onTap,
            items: items,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
