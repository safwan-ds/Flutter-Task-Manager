import "package:flutter/material.dart";
import "package:task_manager/data/classes/task.dart";
import "package:task_manager/data/constants.dart";
import "package:task_manager/data/database_helper.dart";

class EditTaskDialog extends StatefulWidget {
  const EditTaskDialog({
    super.key,
    required this.task,
    required this.dbHelper,
    required this.setStatePage,
    required this.setState,
  });

  final Task task;
  final DatabaseHelper dbHelper;
  final Function setStatePage;
  final Function setState;

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  int? id;
  bool _isEmpty = false;
  DateTime? _selectedDate;
  late DateTime _createdAt;

  @override
  void initState() {
    super.initState();
    final Task task = widget.task;
    id = task.id;
    _titleController.text = task.title;
    _descController.text = task.description;
    _selectedDate = task.dueDate;
    _createdAt = task.createdAt;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate, // Set the initial date
      firstDate: DateTime.now(), // Set the earliest date the user can select
      lastDate: DateTime(
          IntegerConstants.lastDate), // Set the latest date the user can select
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(StringConstants.editTask),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        spacing: DoubleConstants.formSpacing,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: StringConstants.taskTitle,
              border: OutlineInputBorder(),
              errorText: _isEmpty ? StringConstants.emptyError : null,
            ),
            onChanged: (value) {
              setState(() {
                _isEmpty = false;
              });
            },
          ),
          TextField(
            controller: _descController,
            decoration: InputDecoration(
              hintText: StringConstants.taskDescription,
              border: OutlineInputBorder(),
            ),
          ),
          ListTile(
            onTap: () {
              _selectDate(context);
            },
            title: Text(
              _selectedDate == null
                  ? StringConstants.noDate
                  : "${_selectedDate!.toLocal()}".split(" ")[0],
              textAlign: TextAlign.center,
            ),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(DoubleConstants.dateTileBorderRadius),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(StringConstants.cancel),
        ),
        FilledButton(
          onPressed: () {
            if (_titleController.text.isEmpty) {
              setState(() {
                _isEmpty = _titleController.text.isEmpty;
              });
              return;
            }
            Task newTask = Task(
              id: id,
              title: _titleController.text,
              description: _descController.text,
              isCompleted: widget.task.isCompleted,
              dueDate: _selectedDate,
              createdAt: _createdAt,
            );
            widget.dbHelper.updateTask(newTask);
            widget.setStatePage(() {});
            widget.setState(newTask);
            Navigator.pop(context);
          },
          child: Text(StringConstants.save),
        ),
      ],
    );
  }
}
