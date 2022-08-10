import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import 'package:ar_ai_messaging_client_frontend/models/models.dart';
import 'package:ar_ai_messaging_client_frontend/helpers.dart';

import 'package:ar_ai_messaging_client_frontend/widgets/widgets.dart';

class HomeChat extends StatefulWidget {
  const HomeChat({Key? key}) : super(key: key);

  @override
  State<HomeChat> createState() => _HomeChatState();
}

class _HomeChatState extends State<HomeChat> {

  final channelListController = ChannelListController();

  @override
  Widget build(BuildContext context) {
    return ChannelsBloc(
      child: ChannelListCore(
      channelListController: channelListController,
      filter: Filter.and(
        [
          Filter.equal('type', 'messaging'),
          Filter.in_('members', [
            StreamChatCore.of(context).currentUser!.id,
          ])
        ],
      ),
        emptyBuilder: (context) => const Center(
          child: Text(
            'So empty.\nGo and message someone.',
            textAlign: TextAlign.center,
          ),
        ),
        errorBuilder: (context, error) => DisplayErrorMessage(
          error: error,
        ),
        loadingBuilder: (
          context,
        ) =>
            const Center(
          child: SizedBox(
            height: 100,
            width: 100,
            child: CircularProgressIndicator(),
          ),
        ),
        listBuilder: (context, channels) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                children: [
                    SizedBox(height: 18),
                    Searcher(onEnterPress: (String s) {
                      //TODO
                    }),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return MessageTitle(channel: channels[index],);
                  },
                  childCount: channels.length,
                ),
              )
            ],
          );
        },
      ),
    );
  }
}