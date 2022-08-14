import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:ar_ai_messaging_client_frontend/app.dart';
import 'package:ar_ai_messaging_client_frontend/screens/screens.dart';
import 'package:ar_ai_messaging_client_frontend/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);//Offline mode on

  final client = StreamChatClient(streamKey);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      MyApp(
        client: client,
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.client,
  }) : super(key: key);

  final StreamChatClient client;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      //themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return StreamChatCore(
          client: client,
          child: ChannelsBloc(
            child: UsersBloc(child: child!),
          ),
        );
      },

      home: const SplashScreen(),
    );
  }
}
