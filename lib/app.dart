import 'package:flutter/material.dart';
import 'package:logger/logger.dart' as log;
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:algolia/algolia.dart';

const streamKey = 'c8m5epxejk8e';
const WatsonSTTApikey = "V54HsAymPgGoYbINdYowOHxK7-ULgpTmAubGBFgg68E-";
const WatsonSTTUrl = "https://api.eu-gb.speech-to-text.watson.cloud.ibm.com/instances/30206445-a817-40a2-aac9-e5432636a66c";


var logger = log.Logger();

/// Extensions can be used to add functionality to the SDK.
extension StreamChatContext on BuildContext {
  /// Fetches the current user image.
  String? get currentUserImage => currentUser!.image;

  /// Fetches the current user.
  User? get currentUser => StreamChatCore.of(this).currentUser;

}


class AlgoliaClient {
  Algolia algoliaClient = Algolia.init(
      applicationId: "H6H5367L13", apiKey: "35ba28d360bd7e2e6668d6b81396cde3");
}

class ZeroDurationRoute extends MaterialPageRoute {
  ZeroDurationRoute({required WidgetBuilder builder}) : super(builder: builder);

  @override
  Duration get transitionDuration => Duration(seconds: 0);
}
