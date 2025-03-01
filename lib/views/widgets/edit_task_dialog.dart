import "package:flutter/material.dart";
import "package:task_manager/data/classes/task.dart";
import "package:task_manager/data/constants.dart";
import "package:task_manager/main.dart";
import "package:task_manager/views/pages/tasks_page.dart";
import "package:task_manager/views/widgets/task_form.dart";

final GlobalKey<TaskFormState> taskFormKey = GlobalKey<TaskFormState>();

class EditTaskDialog extends StatefulWidget {
  const EditTaskDialog({
    super.key,
    required this.task,
    required this.widget,
    required this.setState,
  });

  final Task task;
  final TasksPageState widget;
  final Function setState;

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  late TaskForm taskForm;

  int? id;
  late DateTime _createdAt;

  @override
  void initState() {
    super.initState();
    taskForm = TaskForm(
      key: taskFormKey,
      selectedDate: widget.task.dueDate,
      selectedPriority: widget.task.priority,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final Task task = widget.task;
      id = task.id;
      taskFormKey.currentState?.titleController.text = task.title;
      taskFormKey.currentState?.descController.text = task.description;
      taskFormKey.currentState?.selectedDate = task.dueDate;
      _createdAt = task.createdAt;
      taskFormKey.currentState?.selectedCategoryId = task.categoryId;
      taskFormKey.currentState?.selectedPriority = task.priority;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(StringConstants.editTask),
      content: SingleChildScrollView(child: taskForm),
      actions: [
        TextButton(
          onPressed: () {
            widget.widget.setState(() {
              widget.widget.loadData = widget.widget.widget.loadData();
            });
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
            Task newTask = Task(
              id: id,
              title: taskFormKey.currentState!.titleController.text.trim(),
              description: taskFormKey.currentState!.descController.text.trim(),
              isCompleted: widget.task.isCompleted,
              dueDate: taskFormKey.currentState!.selectedDate,
              createdAt: _createdAt,
              categoryId: taskFormKey.currentState!.selectedCategoryId,
              priority: taskFormKey.currentState!.selectedPriority,
            );
            dbHelper.updateTask(newTask);
            widget.widget.setState(() {
              widget.widget.loadData = widget.widget.widget.loadData();
            });
            widget.setState(newTask);
            Navigator.pop(context);
          },
          child: Text(StringConstants.save),
        ),
      ],
    );
  }
}
