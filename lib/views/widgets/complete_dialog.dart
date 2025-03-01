import "package:flutter/material.dart";
import "package:task_manager/data/classes/task.dart";
import "package:task_manager/data/constants.dart";
import "package:task_manager/main.dart";
import "package:task_manager/views/widgets/cancel_button.dart";
import "package:task_manager/views/widgets/task_card.dart";

class CompleteDialog extends StatelessWidget {
  const CompleteDialog({
    super.key,
    required this.task,
    required this.widget,
  });

  final Task task;
  final TaskCard widget;

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text("Confirmation"),
      content: Text(
        task.isCompleted
            ? "Do you want to undone ${task.title}?"
            : "Do you want to complete ${task.title}?",
        textAlign: TextAlign.justify,
      ),
      actions: [
        CancelButton(),
        TextButton(
          onPressed: () {
            task.isCompleted = !task.isCompleted;
            dbHelper.updateTask(task);
            // ignore: invalid_use_of_protected_member
            widget.widget.setState(() {
              widget.widget.loadData = widget.widget.widget.loadData();
            });
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(task.isCompleted
                    ? "${task.title} is completed"
                    : "${task.title} is moved to uncompleted tasks"),
              ),
            );
          },
          child: Text(StringConstants.confirm),
        ),
      ],
    );
  }
}
