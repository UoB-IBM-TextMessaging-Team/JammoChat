import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:ar_ai_messaging_client_frontend/screens/user_setting.dart';
import '../app.dart';
import 'package:ar_ai_messaging_client_frontend/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import '../widgets/widgets.dart';
import 'screens.dart';

class UserProfile extends StatefulWidget {
  static Route get route => ZeroDurationRoute(
    builder: (context) => const UserProfile(),
  );

  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String picture = "";
  final useremail = FirebaseAuth.instance.currentUser?.email;
  choosePic() {
    if (picture == "") {
      return const AssetImage('assets/logos/app_logo_bw.jpg');
    } else {
      return CachedNetworkImageProvider(picture);
    }
  }

  ///////UNITY
  late UnityWidgetController unityWidgetController;


  void onUnityMessage(message) {
    print('Received message from unity: ${message.toString()}');
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    unityWidgetController = controller;
    switchToShow();
  }

  void switchToShow(){
    unityWidgetController.postMessage(
      'GameManager',
      'LoadGameScene',
      '1',
    );
  }

  @override
  void dispose() {
    ///////UNITY
    unityWidgetController.dispose();
    ///////UNITY

    super.dispose();
  }

  ///////UNITY

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

  @override
  Widget build(BuildContext context) {
    final user = context.currentUser;
    final borderRadius = BorderRadius.circular(20);
    return Stack(
        children: [
          Container(
            height: 450,
            color: Colors.white10,
            child: UnityWidget(
                onUnityCreated: onUnityCreated,
                onUnityMessage: onUnityMessage,
                //webUrl: 'http://localhost:6080',
                useAndroidViewSurface: false,
                fullscreen: false,
          )),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text('Profile'),
              backgroundColor: Colors.transparent,
              centerTitle: true,
              leading: Center(
                child: IconBackground(
                  icon: Icons.arrow_back_ios_new,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(
                    child: IconBackground(
                        icon: Icons.settings,
                        onTap: () {
                          print('Setting');
                        }),
                  ),
                ),
              ],
            ),
            body: Padding(
              padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.35),
              child: Container(
                padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
                height: double.maxFinite,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor, // 首页列表背景色 <=========
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Hero(
                                tag: 'hero-profile-picture',
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: borderRadius),
                                  child: ClipRRect(
                                    borderRadius: borderRadius,
                                    child: SizedBox.fromSize(
                                      size: Size.fromRadius(32),
                                      child:
                                      //
                                      FutureBuilder(
                                        future: findProfilePic(),
                                        builder: (context, snapshot) {
                                          return CircleAvatar(
                                              radius: 80.0,
                                              backgroundImage: choosePic(),
                                              backgroundColor: Theme.of(context).backgroundColor,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    user?.name ?? 'no name',
                                    style: MyTheme.senderName,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Email: ${useremail}',
                                    style: MyTheme.textTime,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              print('edit profile');

                              Navigator.of(context)
                                  .push(UserSetting.route)
                                  .then((_) => setState(() => {}));
                            },
                            child: const Icon(Icons.arrow_forward_ios_rounded))
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () {
                        print('change avatar');
                      },
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: MyTheme.kPrimaryColor,
                          borderRadius: borderRadius,
                        ),
                        child: Center(
                          child: Text(
                            'Change Avatar',
                            style: MyTheme.buttonText,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: (() {
                        print('change voice');
                      }),
                      child: Container(
                        height: 48,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          /*gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [MyTheme.kPrimaryColor, Colors.black26],
                      ),*/
                          color: MyTheme.kPrimaryColor,
                          borderRadius: borderRadius,
                        ),
                        child: Center(
                          child: Text(
                            'Custom Voice',
                            style: MyTheme.buttonText,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const _SignOutButton()
                  ],
                ),
              ),
            ),
          ),
        ]
    );
  }
}

class _SignOutButton extends StatefulWidget {
  const _SignOutButton({
    Key? key,
  }) : super(key: key);

  @override
  __SignOutButtonState createState() => __SignOutButtonState();
}

class __SignOutButtonState extends State<_SignOutButton> {
  bool _loading = false;

  Future<void> _signOut() async {
    setState(() {
      _loading = true;
    });

    try {
      await StreamChatCore.of(context).client.disconnectUser();
      await firebase.FirebaseAuth.instance.signOut();

      Navigator.of(context).pushReplacement(SplashScreen.route);
    } on Exception catch (e, st) {
      logger.e('Could not sign out', e, st);
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const CircularProgressIndicator()
        : MaterialButton(
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onPressed: _signOut,
      color: Theme.of(context).backgroundColor,
      child: const Text(
        'Sign out',
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:untitled/app_theme.dart';
// import 'package:untitled/screens/user_setting.dart';

// import '../widgets/widgets.dart';

// class UserProfile extends StatefulWidget {
//   const UserProfile({Key? key}) : super(key: key);
//   static Route get route => MaterialPageRoute(
//         builder: (context) => const UserProfile(),
//       );

//   @override
//   State<UserProfile> createState() => _UserProfileState();
// }

// class _UserProfileState extends State<UserProfile> {
//   Future<void> _signOut() async {
//     await FirebaseAuth.instance.signOut();
//   }

//   final useremail = FirebaseAuth.instance.currentUser?.email;
//   String picture = "";
//   // Future findProfilePic() async {
//   //   try {
//   //     await FirebaseFirestore.instance
//   //         .collection("users")
//   //         .doc(useremail)
//   //         .get()
//   //         .then((snapshot) => {picture = snapshot.data()!["profilePicURL"]});
//   //   } catch (e) {
//   //     // ignore: avoid_print
//   //     print(e.toString());
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final borderRadius = BorderRadius.circular(20);
//     return Container(
//       decoration: const BoxDecoration(
//         image: DecorationImage(
//           image: ExactAssetImage('assets/images/image1.jpg'),
//           opacity: 0.9,
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           title: const Text('Profile'),
//           backgroundColor: Colors.transparent,
//           centerTitle: true,
//           leading: Center(
//             child: IconBackground(
//               icon: Icons.arrow_back_ios_new,
//               onTap: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ),
//           actions: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Center(
//                 child: IconBackground(
//                     icon: Icons.settings,
//                     onTap: () {
//                       Text("goto setting");
//                     }),
//               ),
//             ),
//           ],
//         ),
//         body: Padding(
//           padding: EdgeInsets.only(top: 240),
//           child: Container(
//             padding: EdgeInsets.only(top: 32, left: 16, right: 16),
//             height: double.maxFinite,
//             decoration: BoxDecoration(
//               color: Theme.of(context).cardColor, // 首页列表背景色 <=========
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(30),
//                 topRight: Radius.circular(30),
//               ),
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     Expanded(
//                       child: Row(
//                         children: [
//                           Hero(
//                             tag: 'hero-profile-picture',
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   color: Theme.of(context).cardColor,
//                                   borderRadius: borderRadius),
//                               child: ClipRRect(
//                                 borderRadius: borderRadius,
//                                 child: SizedBox.fromSize(
//                                   size: Size.fromRadius(32),
//                                   // child: FutureBuilder(
//                                   //   future: findProfilePic(),
//                                   //   builder: (context, snapshot) {
//                                   //     return CircleAvatar(
//                                   //         radius: 80.0,
//                                   //         backgroundImage: choosePic());
//                                   //   },
//                                   // ),
//                                   // child: Image.asset(
//                                   //   'assets/images/user1.png',
//                                   //   fit: BoxFit.cover,
//                                   // ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               Text(
//                                 'Anna Wang',
//                                 style: MyTheme.senderName,
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 'ID: 12345',
//                                 style: MyTheme.textTime,
//                               )
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     GestureDetector(
//                         onTap: () {
//                           print('edit profile');

//                           Navigator.of(context)
//                               .push(UserSetting.route)
//                               .then((_) => setState(() => {}));
//                           // Navigator.of(context).push(UsersSetting.route);
//                         },
//                         child: Icon(Icons.arrow_forward_ios_rounded))
//                   ],
//                 ),
//                 const Divider(
//                   thickness: 1,
//                 ),
//                 const SizedBox(height: 16),
//                 GestureDetector(
//                   onTap: () {
//                     print('change avatar');
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: MyTheme.kPrimaryColor,
//                       borderRadius: borderRadius,
//                     ),
//                     child: const Center(
//                       child: Text(
//                         'Change Avatar',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 GestureDetector(
//                   onTap: (() {
//                     print('change voice');
//                   }),
//                   child: Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: MyTheme.kPrimaryColor,
//                       borderRadius: borderRadius,
//                     ),
//                     child: const Center(
//                       child: Text(
//                         'Custome Voice',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: 14,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 32),
//                 MaterialButton(
//                   onPressed: () {
//                     _signOut();
//                     Navigator.pop(context);
//                   },
//                   color: Colors.deepPurple[200],
//                   child: Text('sign out'),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   choosePic() {
//     if (picture == "") {
//       return const AssetImage('assets/images/user1.png');
//     } else {
//       return NetworkImage(picture);
//     }
//   }
// }
