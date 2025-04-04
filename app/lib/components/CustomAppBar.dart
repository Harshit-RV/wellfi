import 'package:flutter/material.dart';
import 'package:wellfi2/constants.dart';

PreferredSizeWidget buildCustomAppBar(String title) {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Text(title),
    backgroundColor: kLighterBackgroundColor,
    titleTextStyle: const TextStyle(
      // color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );
}
