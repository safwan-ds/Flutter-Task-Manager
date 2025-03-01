import "package:flutter/material.dart";
import "package:task_manager/data/constants.dart";

class CancelButton extends StatelessWidget {
  const CancelButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: Text(StringConstants.cancel),
    );
  }
}
