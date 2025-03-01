import "package:flutter/material.dart";

class LocalTextStyles {
  static const TextStyle emptyPageText = TextStyle(fontSize: 20.0);

  static const TextStyle boldText = TextStyle(fontWeight: FontWeight.bold);
  static const TextStyle normalText = TextStyle(fontWeight: FontWeight.normal);
}

enum ButtonTypes {
  primary,
  secondary,
  danger,
}

ButtonStyle getButtonStyle(BuildContext context, ButtonTypes type) {
  switch (type) {
    case ButtonTypes.primary:
      return ButtonStyle(
        foregroundColor:
            WidgetStateProperty.all(Theme.of(context).colorScheme.primary),
      );

    case ButtonTypes.secondary:
      return ButtonStyle(
        foregroundColor:
            WidgetStateProperty.all(Theme.of(context).colorScheme.onPrimary),
      );

    case ButtonTypes.danger:
      return ButtonStyle(
        foregroundColor:
            WidgetStateProperty.all(Theme.of(context).colorScheme.error),
      );
  }
}
