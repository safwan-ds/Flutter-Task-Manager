import "package:flutter/material.dart";
import "package:task_manager/data/classes/task.dart";
import "package:task_manager/data/database_helper.dart";

class DeleteTaskDialog extends StatelessWidget {
  const DeleteTaskDialog({
    super.key,
    required this.task,
    required this.dbHelper,
    required this.setState,
  });

  final Task task;
  final DatabaseHelper dbHelper;
  final Function setState;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(Icons.warning),
      iconColor: Theme.of(context).colorScheme.error,
      title: Text("Are you sure?"),
      content: Text(
        "This will delete ${task.title} task forever. Are you sure you want to delete this task forever?",
        textAlign: TextAlign.justify,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
        FilledButton(
          onPressed: () {
            dbHelper.deleteTask(task.id!);
            setState(() {});
            Navigator.pop(context);
          },
          style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.all(Theme.of(context).colorScheme.error),
            foregroundColor:
                WidgetStateProperty.all(Theme.of(context).colorScheme.onError),
          ),
          child: Text("Delete"),
        ),
      ],
      actionsAlignment: MainAxisAlignment.end,
    );
  }
}
