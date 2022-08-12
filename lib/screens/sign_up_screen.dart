// import 'dart:io';

// import 'package:cloud_functions/cloud_functions.dart';
// import 'package:firebase_auth/firebase_auth.dart' as firebase;
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

// import '../app.dart';
// import 'home_screen.dart';

// class SignUpScreen extends StatefulWidget {
//   static Route get route => MaterialPageRoute(
//         builder: (context) => const SignUpScreen(),
//       );
//   const SignUpScreen({Key? key}) : super(key: key);

//   @override
//   State<SignUpScreen> createState() => _SignUpScreenState();
// }

// class _SignUpScreenState extends State<SignUpScreen> {
//   final auth = firebase.FirebaseAuth.instance;
//   final functions = FirebaseFunctions.instance;

//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _profilePictureController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();

//   final _emailRegex = RegExp(
//       r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

//   bool _loading = false;

//   //gallery image picker
//   File? image;
//   Future pickImage() async {
//     try {
//       final image = await ImagePicker().pickImage(source: ImageSource.gallery);
//       if (image == null) return;

//       final imageTemporary = File(image.path);
//       setState(() => this.image = imageTemporary);
//     } on PlatformException catch (e) {
//       print('Failed to pick image: ${e}');
//     }
//   }

//   Future<void> _signUp() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _loading = true;
//       });
//       try {
//         // Authenticate with Firebase
//         final creds =
//             await firebase.FirebaseAuth.instance.createUserWithEmailAndPassword(
//           email: _emailController.text,
//           password: _passwordController.text,
//         );
//         final user = creds.user;
//         if (user == null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('User is empty')),
//           );
//           return;
//         }

//         // Set Firebase display name and profile picture
//         List<Future<void>> futures = [
//           creds.user!.updateDisplayName(_nameController.text),
//           if (_profilePictureController.text.isNotEmpty)
//             creds.user!.updatePhotoURL(_profilePictureController.text)
//         ];

//         await Future.wait(futures);

//         // Create Stream user and get token using Firebase Functions
//         final callable = functions.httpsCallable('createStreamUserAndGetToken');
//         final results = await callable();

//         // Connect user to Stream and set user data
//         final client = StreamChatCore.of(context).client;
//         await client.connectUser(
//           User(
//             id: creds.user!.uid,
//             name: _nameController.text,
//             image: _profilePictureController.text,
//           ),
//           results.data,
//         );

//         // Navigate to home screen
//         await Navigator.of(context).pushReplacement(HomePage.route);
//       } on firebase.FirebaseAuthException catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(e.message ?? 'Auth error')),
//         );
//       } catch (e, st) {
//         logger.e('Sign up error', e, st);
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('An error occured')),
//         );
//       }
//       setState(() {
//         _loading = false;
//       });
//     }
//   }

//   String? _nameInputValidator(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Cannot be empty';
//     }
//     return null;
//   }

//   String? _emailInputValidator(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Cannot be empty';
//     }
//     if (!_emailRegex.hasMatch(value)) {
//       return 'Not a valid email';
//     }
//     return null;
//   }

//   String? _passwordInputValidator(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Cannot be empty';
//     }
//     if (value.length <= 6) {
//       return 'Password needs to be longer than 6 characters';
//     }
//     return null;
//   }

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     _profilePictureController.dispose();
//     _nameController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'CHATTER',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 17,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       backgroundColor: Theme.of(context).cardColor,
//       body: (_loading)
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       image != null
//                           ? Image.file(
//                               image!,
//                               width: 50,
//                               height: 50,
//                             )
//                           : FlutterLogo(),

//                       /*const Padding(
//                         padding: EdgeInsets.only(top: 24, bottom: 24),
//                         child: Text(
//                           'Register',
//                           style: TextStyle(
//                               fontSize: 26, fontWeight: FontWeight.w800),
//                         ),
//                       ), */
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: TextFormField(
//                           controller: _nameController,
//                           validator: _nameInputValidator,
//                           decoration: const InputDecoration(hintText: 'name'),
//                           keyboardType: TextInputType.name,
//                           autofillHints: const [
//                             AutofillHints.name,
//                             AutofillHints.username
//                           ],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: TextFormField(
//                           controller: _profilePictureController,
//                           decoration:
//                               const InputDecoration(hintText: 'picture URL'),
//                           keyboardType: TextInputType.url,
//                         ),
//                       ),
//                       TextButton(
//                         onPressed: () => pickImage(),
//                         child: const Text('Pick Gallery'),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: TextFormField(
//                           controller: _emailController,
//                           validator: _emailInputValidator,
//                           decoration: const InputDecoration(hintText: 'email'),
//                           keyboardType: TextInputType.emailAddress,
//                           autofillHints: const [AutofillHints.email],
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: TextFormField(
//                           controller: _passwordController,
//                           validator: _passwordInputValidator,
//                           decoration: const InputDecoration(
//                             hintText: 'password',
//                           ),
//                           obscureText: true,
//                           enableSuggestions: false,
//                           autocorrect: false,
//                           keyboardType: TextInputType.visiblePassword,
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: ElevatedButton(
//                           onPressed: _signUp,
//                           child: const Text('Sign up'),
//                         ),
//                       ),
//                       const Padding(
//                         padding: EdgeInsets.symmetric(vertical: 16.0),
//                         child: Divider(),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text('Already have an account?',
//                               style: Theme.of(context).textTheme.subtitle2),
//                           const SizedBox(width: 8),
//                           TextButton(
//                             onPressed: () {
//                               Navigator.of(context).pop();
//                             },
//                             child: const Text('Sign in'),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }
// }

import 'dart:io';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart' as core;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../app.dart';
import '../app_theme.dart';
import 'home_screen.dart';

class SignUpScreen extends StatefulWidget {
  static Route get route => MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      );
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final auth = firebase.FirebaseAuth.instance;
  final functions = FirebaseFunctions.instance;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _profilePictureController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  final _emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  bool _loading = false;
  // final user = FirebaseAuth.instance.currentUser?.email;
  // final useremail = FirebaseAuth.instance.currentUser?.email;

  //gallery image picker

  Future<void> _signUp() async {
    if (_photo == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Oops!'),
          content: const Text('Please select your profile photo.'),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
      return;
    }
    //storage

    /*

    // Compress the image
    String dir = (await getTemporaryDirectory()).path;
    File compressFile = new File('$dir/lastProfileCompressed.jpeg');
    await FlutterImageCompress.compressAndGetFile(
      _photo!.path, compressFile.path,format: CompressFormat.jpeg,
      quality: 5,
    );
    */

    final destination = 'profilePicture/${_nameController.text}';
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('${_nameController.text.trim()}_profile_Picture/');
      await ref.putFile(_photo!);
    } catch (e) {
      // ignore: avoid_print
      print('error occured');
    }

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('${_nameController.text.trim()}_profile_Picture/');
      final String downloadUrl = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_emailController.text.trim())
          .set({
        "profilePicURL": downloadUrl,
        "friendList": {
          ' ': 'Occupation for avoid getstream.io service query error'
        },
        "userName": _nameController.text,
        "userEmail": _emailController.text
      });
    } catch (e) {
      // ignore: avoid_print
      print('error occured');
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });
      try {
        // Authenticate with Firebase
        final creds =
            await firebase.FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        final user = creds.user;
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User is empty')),
          );
          return;
        }

        // Set Firebase display name and profile picture
        List<Future<void>> futures = [
          creds.user!.updateDisplayName(_nameController.text),
          if (_profilePictureController.text.isNotEmpty)
            creds.user!.updatePhotoURL(_photo?.path)
        ];

        await Future.wait(futures);

        // Create Stream user and get token using Firebase Functions
        final callable = functions.httpsCallable('createStreamUserAndGetToken');
        final results = await callable();

        // Connect user to Stream and set user data
        final client = core.StreamChatCore.of(context).client;
        final ref = firebase_storage.FirebaseStorage.instance
            .ref(destination)
            .child('${_nameController.text.trim()}_profile_Picture/');
        final String downloadUrl = await ref.getDownloadURL();
        await client.connectUser(
          core.User(
            id: creds.user!.uid,
            name: _nameController.text,
            image: downloadUrl,
          ),
          results.data,
        );

        // Navigate to home screen
        //await Navigator.of(context).pushReplacement(HomePage.route);
        await Navigator.of(context).pushAndRemoveUntil(
            HomePage.route, (Route<dynamic> route) => false);
      } on firebase.FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Auth error')),
        );
      } catch (e, st) {
        logger.e('Sign up error', e, st);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occured')),
        );
      }
      setState(() {
        _loading = false;
      });
    }
  }

  String? _nameInputValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Cannot be empty';
    }
    return null;
  }

  String? _emailInputValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Cannot be empty';
    }
    if (!_emailRegex.hasMatch(value)) {
      return 'Not a valid email';
    }
    return null;
  }

  String? _passwordInputValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Cannot be empty';
    }
    if (value.length <= 6) {
      return 'Password needs to be longer than 6 characters';
    }
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _profilePictureController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,

      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(
              fontWeight: FontWeight.normal, fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: MyTheme.AppBarTheme,
        elevation: 0,
      ),
      // backgroundColor: Theme.of(context).cardColor,
      body: (_loading)
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Your Jammo bot is birthing...'),
                  SizedBox(height: 20),
                  CircularProgressIndicator()
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      imageProfile(),

                      /*const Padding(
                        padding: EdgeInsets.only(top: 24, bottom: 24),
                        child: Text(
                          'Register',
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.w800),
                        ),
                      ), */
                      SizedBox(height: 20),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).bottomAppBarColor,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black),
                                controller: _nameController,
                                validator: _nameInputValidator,
                                decoration: const InputDecoration(
                                    hintStyle: TextStyle(
                                        fontSize: 20.0, color: Colors.grey),
                                    hintText: 'Name',
                                    border: InputBorder.none),
                                keyboardType: TextInputType.name,
                                autofillHints: const [
                                  AutofillHints.name,
                                  AutofillHints.username
                                ],
                              ),
                            ),
                          )),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).bottomAppBarColor,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: TextFormField(
                                style: TextStyle(color: Colors.black),
                                controller: _emailController,
                                validator: _emailInputValidator,
                                decoration: const InputDecoration(
                                    hintStyle: TextStyle(
                                        fontSize: 20.0, color: Colors.grey),
                                    hintText: 'Email',
                                    border: InputBorder.none),
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                              ),
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).bottomAppBarColor,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              style: TextStyle(color: Colors.black),
                              controller: _passwordController,
                              validator: _passwordInputValidator,
                              decoration: const InputDecoration(
                                hintText: 'password',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    fontSize: 20.0, color: Colors.grey),
                              ),
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              keyboardType: TextInputType.visiblePassword,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: MyTheme.kPrimaryColor, // background
                            onPrimary: Colors.white, // foreground
                            fixedSize: Size(120, 20),
                          ),
                          onPressed: _signUp,
                          child: const Text(
                            'Sign up',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Divider(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: TextStyle(
                                //color: Colors.black,
                                fontWeight: FontWeight.bold),
                            // style: Theme.of(context).textTheme.subtitle2),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Sign in',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget imageProfile() {
    return Center(
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            radius: 80.0,
            backgroundImage: choosePic(),
            backgroundColor: Theme.of(context).backgroundColor,
          ),
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
      imageQuality: 10,
    );
    // the picture in the gallery or camera store in _photo
    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        // uploadFile();
      } else {
        // ignore: avoid_print
        print('No image selected');
      }
    });
  }

  choosePic() {
    print(_photo);
    //沒upload，之前也沒換過照片
    if (_photo == null) {
      return const AssetImage('assets/logos/app_logo.jpg');
    } else {
      //新upload到照片
      return FileImage(File(_photo!.path));
    }
  }
}
