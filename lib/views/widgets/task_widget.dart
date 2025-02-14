import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:task_manager/data/classes/task.dart";
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
        leading: Checkbox.adaptive(
          value: task.isCompleted,
          onChanged: (value) {
            setState(() {
              task.isCompleted = value!;
              widget.dbHelper.updateTask(task);
            });
          },
        ), // TODO: change the checkbox to a "complete" button
        title: Text(task.title),
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description.isNotEmpty) Text(task.description),
            if (task.dueDate != null)
              Text(
                'Due to: ${DateFormat("yyyy-MM-dd").format(task.dueDate!)}',
              ),
            Text(
              'Created at: ${DateFormat("yyyy-MM-dd HH:mm").format(task.createdAt)}',
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
                      setState: widget.setState,
                    );
                  },
                );
              },
            ),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return DeleteTaskDialog(
                          task: task,
                          dbHelper: widget.dbHelper,
                          setState: widget.setState);
                    });
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
