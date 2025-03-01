import "package:flutter/material.dart";
import "package:task_manager/data/classes/task.dart";
import "package:task_manager/data/constants.dart";
import "package:task_manager/main.dart";
import "package:task_manager/views/pages/tasks_page.dart";
import "package:task_manager/views/widgets/task_form.dart";

final GlobalKey<TaskFormState> taskFormKey = GlobalKey<TaskFormState>();

class NewTaskDialog extends StatefulWidget {
  const NewTaskDialog({
    super.key,
    required this.widget,
  });

  final TasksPageState widget;

  @override
  State<NewTaskDialog> createState() => _NewTaskDialogState();
}

class _NewTaskDialogState extends State<NewTaskDialog> {
  TaskForm taskForm = TaskForm(key: taskFormKey);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(StringConstants.newTask),
      content: SingleChildScrollView(child: taskForm),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(StringConstants.cancel),
        ),
        FilledButton(
          onPressed: () {
            if (taskFormKey.currentState!.titleController.text.trim().isEmpty) {
              setState(() {
                taskFormKey.currentState!.isEmpty = true;
                taskFormKey.currentState!.titleController.clear();
                taskFormKey.currentState!.setState(() {});
              });
              return;
            }
            dbHelper.insertTask(
              Task(
                title: taskFormKey.currentState!.titleController.text.trim(),
                description:
                    taskFormKey.currentState!.descController.text.trim(),
                dueDate: taskFormKey.currentState!.selectedDate,
                createdAt: DateTime.now(),
                categoryId: taskFormKey.currentState!.selectedCategoryId,
                priority: taskFormKey.currentState!.selectedPriority,
              ),
            );
            widget.widget.setState(
              () {
                widget.widget.loadData = widget.widget.widget.loadData();
              },
            );
            Navigator.pop(context);
          },
          child: Text(StringConstants.add),
        ),
      ],
    );
  }
}
