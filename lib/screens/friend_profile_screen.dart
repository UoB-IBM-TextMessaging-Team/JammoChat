import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:ar_ai_messaging_client_frontend/app.dart';
import 'package:ar_ai_messaging_client_frontend/app_theme.dart';
import '../helpers.dart';
import '../widgets/widgets.dart';
import '../screens/screens.dart';

class FriendProfile extends StatelessWidget {
  static Route routeWithChannel(Channel channel) => MaterialPageRoute(
        builder: (context) => StreamChannel(
          channel: channel,
          child: const FriendProfile(),
        ),
      );
  const FriendProfile({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    final borderRadius = BorderRadius.circular(20);
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage('assets/images/image1.jpg'),
          opacity: 0.9,
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
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
              EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.6),
          child: Container(
            padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
            height: double.maxFinite,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor, // 列表背景色 <=========
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: borderRadius),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: borderRadius),
                            child: ClipRRect(
                              borderRadius: borderRadius,
                              child: SizedBox.fromSize(
                                size: Size.fromRadius(32),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: Helpers.getChannelImage(
                                    channel, context.currentUser!)??
                                      'assets/images/image0.png',
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Helpers.getChannelName(
                                  channel, context.currentUser!),
                              style: MyTheme.senderName,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'ID: 12345',
                              style: MyTheme.textTime,
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(
                  thickness: 1,
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () {
                    print('chat');
                  },
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: MyTheme.kPrimaryColor,
                        borderRadius: borderRadius,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(CupertinoIcons.bubble_left_bubble_right,
                              color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            'Message',
                            style: MyTheme.buttonText.copyWith(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
