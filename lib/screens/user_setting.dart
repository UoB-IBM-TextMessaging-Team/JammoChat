// import 'package:firebase_auth/firebase_auth.dart';
import 'package:ar_ai_messaging_client_frontend/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart' as core;
import 'package:ar_ai_messaging_client_frontend/app.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';
import 'package:ar_ai_messaging_client_frontend/app.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:cloud_firestore/cloud_firestore.dart';

class UserSetting extends StatefulWidget {
  const UserSetting({Key? key}) : super(key: key);
  static Route get route => MaterialPageRoute(
    builder: (context) => const UserSetting(),
  );
  @override
  State<UserSetting> createState() => _UserSettingState();
}

class _UserSettingState extends State<UserSetting> {
  File? _photo;
  final ImagePicker _picker = ImagePicker();
  String picture =
      ""; // picture in the firebase store (defalut: picture is empty)
  bool change = false;
  final useremail = FirebaseAuth.instance.currentUser?.email;
  final user = FirebaseAuth.instance.currentUser?.email;
  //find the picture in the firebase store
  // Future findProfilePic() async {
  //   try {
  //     picture = context.currentUserImage!;
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print(e.toString());
  //   }
  // }
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
  void initState() {
    super.initState();
    findProfilePic();
  }

  //upload picture to the firebase store and storage
  Future uploadFile() async {
    if (_photo == null) return;
    final destination = 'profilePicture/$user';

    /*
    // Compress the image
    String dir = (await getTemporaryDirectory()).path;
    File compressFile = new File('$dir/lastProfileCompressed.jpeg');;
    await FlutterImageCompress.compressAndGetFile(
      _photo!.path, compressFile.path,format: CompressFormat.jpeg,
      quality: 5,
    );


     */
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('${user}_profile_Picture/');
      await ref.putFile(_photo!);
    } catch (e) {
      // ignore: avoid_print
      print('error occured');
    }

    try {
      // Firestore Update
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('${user}_profile_Picture/');
      final String downloadUrl = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection("users")
          .doc(useremail)
          .update({"profilePicURL": downloadUrl});

      // Stream Update
      final client = core.StreamChatCore.of(context).client;
      final curUser = core.StreamChatCore.of(context).currentUser;
      await client.partialUpdateUser(curUser!.id,set: {"image": downloadUrl});

    } catch (e) {
      // ignore: avoid_print
      print('error occured');
    }


  }

  @override
  Widget build(BuildContext context) {
    final userImage = context.currentUserImage;
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        title: const Text(
          "User Setting",
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: MyTheme.AppBarTheme,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 140,
            ),
            imageProfile(),
            // const SizedBox(
            //   height: 50,
            // ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                      primary: MyTheme.kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.fromLTRB(
                          20, 10, 20, 10) // Background color
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    uploadFile();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: MyTheme.kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10)
                    // Background color
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: <Widget>[
          FutureBuilder(
              future: findProfilePic(),
              builder: (context, snapshot) {
                return CircleAvatar(
                    radius: 80.0,
                    backgroundImage: choosePic(),
                    backgroundColor: Theme.of(context).backgroundColor,
                );
              }),
          Positioned(
            bottom: 20.0,
            right: 20.0,
            child: InkWell(
              onTap: () {
                //出現列表
                showModalBottomSheet(
                  context: this.context,
                  builder: ((builder) => bottomSheet()),
                );
              },
              child: const Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 28.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(this.context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Choose Profile photo",
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //camer or gallery
              TextButton.icon(
                icon: const Icon(Icons.camera),
                onPressed: () {
                  takePhoto(ImageSource.camera);
                  Navigator.of(context).pop();
                },
                label: const Text("Camera"),
              ),
              TextButton.icon(
                icon: const Icon(Icons.image),
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
                label: const Text("Gallery"),
              )
            ],
          )
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 10
    );
    // the picture in the gallery or camera store in _photo
    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
      } else {
        // ignore: avoid_print
        print('No image selected');
      }
    });
  }

  choosePic() {
    //沒upload，之前也沒換過照片
    if (picture == "" && _photo == null) {
      return const AssetImage('assets/logos/app_logo_bw.jpg');
    } else if (_photo == null) {
      // 沒upload照片 從firebase store找之前的
      return NetworkImage(picture);
    } else {
      //新upload到照片
      return FileImage(File(_photo!.path));
    }
  }
}
