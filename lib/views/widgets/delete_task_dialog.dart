import "package:flutter/material.dart";
import "package:task_manager/data/classes/task.dart";
import "package:task_manager/data/constants.dart";
import "package:task_manager/data/styles.dart";
import "package:task_manager/main.dart";
import "package:task_manager/views/pages/tasks_page.dart";

class DeleteTaskDialog extends StatelessWidget {
  const DeleteTaskDialog({
    super.key,
    required this.task,
    required this.widget,
  });

  final Task task;
  final TasksPageState widget;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: Icon(Icons.warning),
      iconColor: Theme.of(context).colorScheme.error,
      title: Text(StringConstants.taskDeleteConfirm),
      content: Text(
        "This will delete ${task.title} task forever. Are you sure you want to delete this task forever?",
        textAlign: TextAlign.justify,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(StringConstants.cancel),
        ),
        TextButton(
          onPressed: () {
            dbHelper.deleteTask(task.id!);
            // ignore: invalid_use_of_protected_member
            widget.setState(() {
              widget.loadData = widget.widget.loadData();
            });
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Deleted task ${task.title}"),
              ),
            );
          },
          style: getButtonStyle(context, ButtonTypes.danger),
          child: Text(StringConstants.delete),
        ),
      ],
      actionsAlignment: MainAxisAlignment.end,
    );
  }
}
