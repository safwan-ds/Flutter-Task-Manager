import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:task_manager/data/classes/task.dart";
import "package:task_manager/data/constants.dart";
import "package:task_manager/data/database_helper.dart";
import "package:task_manager/views/widgets/delete_task_dialog.dart";
import "package:task_manager/views/widgets/edit_task_dialog.dart";

class TaskWidget extends StatefulWidget {
  const TaskWidget({
    super.key,
    required this.task,
    required this.dbHelper,
    required this.setState,
  });

  final Task task;
  final DatabaseHelper dbHelper;
  final Function setState;

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  late Task task;

  @override
  void initState() {
    task = widget.task;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: ListTile(
        leading: CompleteButton(task: task, widget: widget),
        title: Text(task.title),
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description.isNotEmpty) Text(task.description),
            if (task.dueDate != null)
              Text.rich(
                TextSpan(
                  text: StringConstants.dueDate,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: DateFormat(
                        task.dueDate!.year == DateTime.now().year
                            ? StringConstants.dateFormatSameYear
                            : StringConstants.dateFormat,
                      ).format(task.dueDate!),
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            Text.rich(
              TextSpan(
                text: StringConstants.createdAt,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: DateFormat(
                      task.createdAt.year == DateTime.now().year
                          ? StringConstants.dateFormatSameYear
                          : StringConstants.dateFormat,
                    ).format(task.createdAt),
                    style: TextStyle(fontWeight: FontWeight.normal),
                  )
                ],
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return EditTaskDialog(
                      task: task,
                      dbHelper: widget.dbHelper,
                      setStatePage: widget.setState,
                      setState: (newTask) {
                        setState(
                          () {
                            task = newTask;
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return DeleteTaskDialog(
                      task: task,
                      dbHelper: widget.dbHelper,
                      setState: widget.setState,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CompleteButton extends StatelessWidget {
  const CompleteButton({
    super.key,
    required this.task,
    required this.widget,
  });

  final Task task;
  final TaskWidget widget;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog.adaptive(
              title: Text("Confirmation"),
              content: Text(
                task.isCompleted
                    ? "Are you sure you want to undone the task?"
                    : "Are you sure you want to complete the task?",
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
                    task.isCompleted = !task.isCompleted;
                    widget.dbHelper.updateTask(task);
                    widget.setState(() {});
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(task.isCompleted
                            ? "${task.title} is completed"
                            : "${task.title} is moved to uncompleted tasks"),
                      ),
                    );
                  },
                  child: Text("Confirm"),
                ),
              ],
            );
          },
        );
      },
      icon: Icon(
        task.isCompleted ? Icons.undo : Icons.done,
      ),
      tooltip:
          task.isCompleted ? StringConstants.undone : StringConstants.complete,
    );
  }
}
