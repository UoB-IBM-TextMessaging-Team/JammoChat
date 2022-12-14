import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    Key? key,
    this.url,
    required this.radius,
    this.onTap,
  }) : super(key: key);

  const Avatar.small({
    Key? key,
    this.url,
    this.onTap,
  })  : radius = 24,
        super(key: key);

  const Avatar.medium({
    Key? key,
    this.url,
    this.onTap,
  })  : radius = 26,
        super(key: key);

  const Avatar.large({
    Key? key,
    this.url,
    this.onTap,
  })  : radius = 34,
        super(key: key);

  final double radius;
  final String? url;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: _avatar(context),
    );
  }

  Widget _avatar(BuildContext context) {
    if (url != null) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: CachedNetworkImageProvider(
            url!
        ),
        backgroundColor: Colors.transparent,
      );
    } else {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.transparent,
        child: Center(
          child: Text(
            '?',
            style: TextStyle(fontSize: radius),
          ),
        ),
      );
    }
  }
}

class boxAvatar extends StatelessWidget {
  boxAvatar($, {Key? key, required this.messageData}) : super(key: key);
  final BorderRadius borderRadius = BorderRadius.circular(20);
  final MessageData messageData;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox.fromSize(
        size: Size.fromRadius(32),
        child: Image.asset(
          messageData.profilePicture,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
