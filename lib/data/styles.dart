import "package:flutter/material.dart";

class LocalTextStyles {
  static TextStyle titleText(context) {
    return TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle descText = TextStyle(
    fontSize: 16.0,
  );
}
