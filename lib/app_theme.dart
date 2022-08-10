// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ar_ai_messaging_client_frontend/theme.dart';

class MyTheme {
  MyTheme._();
  static Color kPrimaryColor = const Color(0xff7C7B9B);
  static Color kPrimaryColorVariant = Color(0xff686795);
  static Color kAccentColor = const Color(0xffFCAAAB);
  static Color kAccentColorVariant = Color(0xffF7A3A2);
  static Color kUnreadChatBG = Color(0xffEE1D1D);

  static final TextStyle kAppTitle = GoogleFonts.grandHotel(
      fontSize: 36, color: Colors.white); // change color here <======

  static final TextStyle kAppTitle1 = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static final TextStyle heading2 = TextStyle(
    color: Color(0xff686795),
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
  );

  static final TextStyle textMessage =
      TextStyle(fontSize: 14, letterSpacing: 1.2, fontWeight: FontWeight.w500);

  static final TextStyle textPreview = TextStyle(
    fontSize: 13,
    letterSpacing: 1.2,
    fontWeight: FontWeight.w600,
    color: AppColors.textFaded,
  );

  static final TextStyle textTime = TextStyle(
    color: AppColors.textFaded,
    fontSize: 11,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.5,
  );

  static final TextStyle senderName = TextStyle(
    fontSize: 16,
    letterSpacing: 0.2,
    wordSpacing: 1.5,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle bodyTextMessage = TextStyle(
    height: 1.4,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  static final TextStyle buttonText = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static final TextStyle searchText = TextStyle(
    fontWeight: FontWeight.w600,
    letterSpacing: 1,
    color: AppColors.textFaded,
  );
}
