import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:task_manager/data/classes/task.dart";
import "package:task_manager/data/constants.dart";
import "package:task_manager/data/styles.dart";
import "package:task_manager/views/pages/tasks_page.dart";
import "package:task_manager/views/widgets/complete_dialog.dart";
import "package:task_manager/views/widgets/delete_task_dialog.dart";
import "package:task_manager/views/widgets/edit_task_dialog.dart";

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.task,
    this.category,
    required this.widget,
  });

  final Task task;
  final String? category;
  final TasksPageState widget;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
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
      child: ExpansionTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return CompleteDialog(task: task, widget: widget);
              },
            );
          },
          icon: Icon(
            task.isCompleted ? Icons.undo : Icons.done,
          ),
          tooltip: task.isCompleted
              ? StringConstants.undone
              : StringConstants.complete,
        ),
        title: Text(
          task.title,
          style: LocalTextStyles.boldText,
        ),
        subtitle: (task.description.isNotEmpty) ? Text(task.description) : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return EditTaskDialog(
                      task: task,
                      widget: widget.widget,
                      setState: (newTask) {
                        setState(
                          () {
                            task = newTask;
                          },
                        );
                      },
                    );
                  },
                ).then(
                  (value) {
                    widget.widget.setState(() {
                      widget.widget.loadData = widget.widget.widget.loadData();
                    });
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
                      widget: widget.widget,
                    );
                  },
                );
              },
            ),
          ],
        ),
        children: <Widget>[
          Divider(),
          if (widget.category != null)
            DetailsText(
              title: "Category: ",
              text: widget.category!,
            ),
          if (widget.category != null) Divider(),
          if (task.dueDate != null)
            DetailsText(
              title: StringConstants.dueDate,
              text: DateFormat(
                task.dueDate!.year == DateTime.now().year
                    ? StringConstants.dateFormatSameYear
                    : StringConstants.dateFormat,
              ).format(task.dueDate!),
            ),
          if (task.dueDate != null) Divider(),
          DetailsText(
            title: StringConstants.createdAt,
            text: DateFormat(
              task.createdAt.year == DateTime.now().year
                  ? StringConstants.dateFormatSameYear
                  : StringConstants.dateFormat,
            ).format(task.createdAt),
          ),
          Divider(),
          if (task.priority != null)
            DetailsText(
              title: StringConstants.priority,
              text: ["Low", "Medium", "High"][task.priority!],
            ),
          if (task.priority != null) Divider(),
        ],
      ),
    );
  }
}

class DetailsText extends StatelessWidget {
  const DetailsText({
    super.key,
    required this.title,
    required this.text,
  });

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
        TextSpan(text: title, style: LocalTextStyles.boldText, children: [
      TextSpan(
        text: text,
        style: LocalTextStyles.normalText,
      ),
    ]));
  }
}
