import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:ar_ai_messaging_client_frontend/app.dart';
import 'package:ar_ai_messaging_client_frontend/app_theme.dart';
import 'package:ar_ai_messaging_client_frontend/theme.dart';
import 'package:ar_ai_messaging_client_frontend/widgets/widgets.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../widgets/animated_dialog.dart';

class ChateScreen extends StatefulWidget {
  /*
  static Route routeWithChannel(Channel channel) => MaterialPageRoute(
        builder: (context) => StreamChannel(
          channel: channel,
          child: const ChateScreen(),
        ),
      );
   */

  /*
  static Route routeWithChannel(Channel channel) => PageRouteBuilder(
      pageBuilder: (context,animation, secondaryAnimation) => StreamChannel(
        channel: channel,
        child: const ChateScreen(),
      ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
*/

  static Route routeWithChannel(Channel channel) => ZeroDurationRoute(
        builder: (context) => StreamChannel(
          channel: channel,
          child: const ChateScreen(),
        ),
      );

  const ChateScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ChateScreen> createState() => _ChateScreenState();
}

class _ChateScreenState extends State<ChateScreen> {
  late StreamSubscription<int> unreadCountSubscription;
  late var newMessageSubscription;
  final TextEditingController controller = TextEditingController();
  late OverlayEntry _popupDialog;

  Future<void> _sendMessage(String text) async {
    setState(() {
      if (text.isNotEmpty) {
        print(text);
        StreamChannel.of(context).channel.sendMessage(Message(text: text));
        FocusScope.of(context).unfocus();
      }
    });
  }

  _startRec() {
    print('_startRec()');
  }

  _stopRec() {
    print('_stopRec()');
  }

  ///////UNITY
  late UnityWidgetController unityWidgetController;

  void sendUnityPlay(String? TextToUnity) {
    if (TextToUnity != null && TextToUnity.isNotEmpty) {
      unityWidgetController.postMessage(
          'main_control', 'StartPlayMessage', TextToUnity);
    }
  }

  void placeObject() {
    unityWidgetController.postMessage('main_control', 'on_place_btn', '');
  }

  void onUnityMessage(message) {
    print('Received message from unity: ${message.toString()}');
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    this.unityWidgetController = controller;
    switchToMainAR();
  }

  void switchToMainAR() {
    unityWidgetController.postMessage(
      'GameManager',
      'LoadGameScene',
      '0',
    );
  }

  ///////UNITY

  @override
  void initState() {
    super.initState();

    unreadCountSubscription = StreamChannel.of(context)
        .channel
        .state!
        .unreadCountStream
        .listen(_unreadCountHandler);

    ///////UNITY
    newMessageSubscription = StreamChannel.of(context)
        .channel
        .on("message.new")
        .listen((Event event) {
      if (event.message?.user?.id != context.currentUser?.id) {
        // TODO
        // Trigger the AR scene
        sendUnityPlay(event.message?.text);
        print("Receive Message: ${event.message?.text}");
      }
    });
    ///////UNITY
  }

  Future<void> _unreadCountHandler(int count) async {
    if (count > 0) {
      await StreamChannel.of(context).channel.markRead();
    }
  }

  @override
  void dispose() {
    unreadCountSubscription.cancel();
    newMessageSubscription.cancel();

    ///////UNITY
    unityWidgetController.dispose();
    ///////UNITY

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(children: <Widget>[
        UnityWidget(
          onUnityCreated: onUnityCreated,
          onUnityMessage: onUnityMessage,
          //webUrl: 'http://localhost:6080',
          useAndroidViewSurface: false,
          fullscreen: false,
        ),
        Container(
          child: Scaffold(
            //extendBodyBehindAppBar: true,
            backgroundColor: Colors
                .transparent, // Make AppBar transparent and show background image which is set to whole screen <====
            // app bar
            appBar: AppBar(
              backgroundColor:
                  Theme.of(context).backgroundColor.withOpacity(0.3),
              iconTheme: Theme.of(context).iconTheme,
              centerTitle: false,
              title: const AppBarTitle(),
              leading: Padding(
                padding: const EdgeInsets.only(left: 16),
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
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Center(
                    child: IconBackground(
                        icon: Icons.more_vert,
                        onTap: () {
                          print('Check More.');
                        }),
                  ),
                ),
              ],
            ),

            // body
            body: Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .cardColor
                      .withOpacity(0.2), // 首页列表背景色 <=========
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: MessageListCore(
                          loadingBuilder: (context) {
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                          emptyBuilder: (context) => const SizedBox.shrink(),
                          errorBuilder: (context, error) =>
                              DisplayErrorMessage(error: error),
                          messageListBuilder: (context, messages) =>
                              _MessageList(messages: messages),
                        ),
                      ),
                      SafeArea(
                        bottom: true,
                        top: false,
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 20, left: 10, right: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(18),
                              topRight: Radius.circular(18),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                //使用expanded将输入框的长度延伸到全屏幕的宽度
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  height: 40,
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).backgroundColor,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Row(
                                    children: [
                                      GestureDetector(
                                        onLongPressStart: (details) {
                                          _popupDialog = _createPopupDialog();
                                          Overlay.of(context)
                                              ?.insert(_popupDialog);
                                          _startRec();
                                        }, // start recording when long pressed
                                        onLongPressUp: () {
                                          _stopRec();
                                          _popupDialog?.remove();
                                        },
                                        child: Icon(
                                          Icons.settings_voice_rounded,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: TextField(
                                            controller: controller,
                                            onChanged: (val) {
                                              StreamChannel.of(context)
                                                  .channel
                                                  .keyStroke();
                                            },
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              //hintText: 'Type your message here ...',
                                              //hintStyle: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold),
                                            ),
                                            onSubmitted: (String s) =>
                                                setState(() {
                                              _sendMessage(s);
                                            }),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Icon(
                                        Icons.attach_file,
                                        color: Colors.grey[500],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    placeObject();
                                  });
                                },
                                child: CircleAvatar(
                                  backgroundColor: Theme.of(context).cardColor,
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.only(left: 2, bottom: 2),
                                    child: Icon(
                                      CupertinoIcons.viewfinder,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      /*
                        _ActionBar(
                          onEnterPress: (String s){
                            setState(() {
                              _sendMessage(s);
                            });
                          },
                          onIdentityPress: (){
                            setState(() {
                              placeObject();
                            });
                          },
                        ),

                         */
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }
}

/*Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage('assets/images/image0.png'),
            opacity: 0.9,
            fit: BoxFit.cover,
          ),
        ),) */
class _MessageList extends StatelessWidget {
  const _MessageList({
    Key? key,
    required this.messages,
  }) : super(key: key);

  final List<Message> messages;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.separated(
        itemCount: messages.length + 1,
        reverse: true,
        separatorBuilder: (context, index) {
          if (index == messages.length - 1) {
            return _DateLabel(dateTime: messages[index].createdAt);
          }
          if (messages.length == 1) {
            return const SizedBox.shrink();
          } else if (index >= messages.length - 1) {
            return const SizedBox.shrink();
          } else if (index <= messages.length) {
            final message = messages[index];
            final nextMessage = messages[index + 1];
            if (!Jiffy(message.createdAt.toLocal())
                .isSame(nextMessage.createdAt.toLocal(), Units.DAY)) {
              return _DateLabel(
                dateTime: message.createdAt,
              );
            } else {
              return const SizedBox.shrink();
            }
          } else {
            return const SizedBox.shrink();
          }
        },
        itemBuilder: (context, index) {
          if (index < messages.length) {
            final message = messages[index];
            if (message.user?.id == context.currentUser?.id) {
              return _MessageOwnTile(message: message);
            } else {
              return _MessageTile(message: message);
            }
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class _DateLabel extends StatefulWidget {
  const _DateLabel({
    Key? key,
    required this.dateTime,
  }) : super(key: key);

  final DateTime dateTime;

  @override
  State<_DateLabel> createState() => _DateLabelState();
}

class _DateLabelState extends State<_DateLabel> {
  late String dayInfo;

  @override
  void initState() {
    final createdAt = Jiffy(widget.dateTime);
    final now = DateTime.now();

    if (Jiffy(createdAt).isSame(now, Units.DAY)) {
      dayInfo = 'TODAY';
    } else if (Jiffy(createdAt)
        .isSame(now.subtract(const Duration(days: 1)), Units.DAY)) {
      dayInfo = 'YESTERDAY';
    } else if (Jiffy(createdAt).isAfter(
      now.subtract(const Duration(days: 7)),
      Units.DAY,
    )) {
      dayInfo = createdAt.EEEE;
    } else if (Jiffy(createdAt).isAfter(
      Jiffy(now).subtract(years: 1),
      Units.DAY,
    )) {
      dayInfo = createdAt.MMMd;
    } else {
      dayInfo = createdAt.MMMd;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withOpacity(0.8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
            child: Text(
              dayInfo,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.textFaded,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageOwnTile extends StatelessWidget {
  const _MessageOwnTile({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  static const _borderRadius = 18.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 12, left: 12, right: 12),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withOpacity(0.9),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(_borderRadius),
                  topRight: Radius.circular(_borderRadius),
                  bottomRight: Radius.circular(6),
                  bottomLeft: Radius.circular(_borderRadius),
                ),
              ),
              child: Text(
                message.text ?? '',
                style: MyTheme.bodyTextMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageTile extends StatelessWidget {
  const _MessageTile({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  static const _borderRadius = 18.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              //margin: EdgeInsets.only(top: 8),
              padding: const EdgeInsets.only(
                  top: 10, bottom: 12, left: 12, right: 12),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.6),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(_borderRadius),
                  bottomRight: Radius.circular(_borderRadius),
                  bottomLeft: Radius.circular(_borderRadius),
                ),
              ),
              child: Text(
                message.text ?? '',
                style: MyTheme.bodyTextMessage,
              ),
            )
          ],
        ),
      ),
    );
  }
}

OverlayEntry _createPopupDialog() {
  return OverlayEntry(
    builder: (context) => AnimatedDialog(
      child: _createPopupContent(),
    ),
  );
}

Widget _createPopupContent() => Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SpinKitRipple(
                  color: Color.fromARGB(255, 147, 88, 241),
                  size: 350.0,
                ),
                Image.asset('assets/images/watson_logo_v2_3.webp'),
              ],
            ),
            /*
            Image.asset('assets/images/watson_logo_v2_3.webp'),
            SizedBox(
              height: 10,
            ),
            SpinKitRipple(
              color: Color.fromARGB(255, 147, 88, 241),
              size: 90.0,
            ),
            SizedBox(
              height: 20,
            ),

             */
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Text(
                'Speech converting...',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );

/*
class _ActionBar extends StatefulWidget {
  _ActionBar({Key? key}) : super(key: key);


  @override
  State<_ActionBar> createState() => _ActionBarState();
}
*/
/*
class _ActionBar extends StatelessWidget {

  _ActionBar({this.onEnterPress,required this.onIdentityPress});

  final TextEditingController controller = TextEditingController();
  final Function(String)? onEnterPress;
  final VoidCallback onIdentityPress;


/*
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
*/
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Container(
        padding:
            const EdgeInsets.only(top: 10, bottom: 20, left: 10, right: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              //使用expanded将输入框的长度延伸到全屏幕的宽度
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 40,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: TextField(
                          controller: controller,
                          onChanged: (val) {
                            StreamChannel.of(context).channel.keyStroke();
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            //hintText: 'Type your message here ...',
                            //hintStyle: TextStyle(color: Colors.grey[500], fontWeight: FontWeight.bold),
                          ),
                          onSubmitted: (String s)=>onEnterPress!(s),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      Icons.attach_file,
                      color: Colors.grey[500],
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: onIdentityPress,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).cardColor,
                child: const Padding(
                  padding: EdgeInsets.only(left: 2, bottom: 2),
                  child: Icon(
                    CupertinoIcons.viewfinder,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
