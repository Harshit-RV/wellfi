import 'package:flutter/material.dart';

PreferredSizeWidget buildCustomAppBar(String title) {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Text(title),
    titleTextStyle: const TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  );
}
