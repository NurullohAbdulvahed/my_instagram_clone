import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomSheetClass{
  Icon? iconData;
  String? iconName;

  BottomSheetClass(this.iconData, this.iconName);


 static List<BottomSheetClass> bottomSheetList = [
    BottomSheetClass(const Icon(Icons.settings), "Settings"),
    BottomSheetClass(const Icon(FontAwesomeIcons.clock), "Archive"),
    BottomSheetClass(const Icon(CupertinoIcons.clock), "Your activity"),
    BottomSheetClass(const Icon(Icons.qr_code_2), "QR code"),
    BottomSheetClass(const Icon(FontAwesomeIcons.bookmark), "Saved"),
    BottomSheetClass(const Icon(FontAwesomeIcons.list), "Close Friends"),
    BottomSheetClass(const Icon(Icons.health_and_safety), "Covid-19 Information Center"),
  ];

  static List<BottomSheetClass> settingsPageBottomSheetList = [
    BottomSheetClass(const Icon(Icons.person_add,), "Follow and invite friends"),
    BottomSheetClass(const Icon(Icons.notifications), "Notifications"),
    BottomSheetClass(const Icon(FontAwesomeIcons.lock), "Privacy"),
    BottomSheetClass(const Icon(Icons.security), "Security"),
    BottomSheetClass(const Icon(FontAwesomeIcons.bullhorn), "Ads"),
    BottomSheetClass(const Icon(FontAwesomeIcons.userCircle), "Account"),
    BottomSheetClass(const Icon(FontAwesomeIcons.lifeRing), "Help"),
    BottomSheetClass(const Icon(FontAwesomeIcons.info), "About"),
    BottomSheetClass(const Icon(FontAwesomeIcons.palette,), "Theme"),

  ];

  static List textModal = [
    "Post to other apps...",
    "Archive",
    "Delete",
    "Edit",
    "Hide like count",
    "Turn off commenting",
  ];
  static List textModal2 = [
    "Why are you seeing this post...",
    "Hide",
    "Unfollow",
  ];
}