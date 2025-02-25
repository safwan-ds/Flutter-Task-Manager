import "package:flutter/material.dart";
import "package:task_manager/data/classes/task.dart";
import "package:task_manager/data/constants.dart";
import "package:task_manager/data/database_helper.dart";

class NewTaskDialog extends StatefulWidget {
  const NewTaskDialog({
    super.key,
    required this.dbHelper,
    required this.setState,
  });

  final DatabaseHelper dbHelper;
  final VoidCallback? setState;

  @override
  State<NewTaskDialog> createState() => _NewTaskDialogState();
}

class _NewTaskDialogState extends State<NewTaskDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  bool _isEmpty = false;
  DateTime? _selectedDate;

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
      title: Text(StringConstants.newTask),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        spacing: 10.0,
        children: [
          TextField(
            autofocus: true,
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
            widget.dbHelper.insertTask(
              Task(
                title: _titleController.text,
                description: _descController.text,
                dueDate: _selectedDate,
                createdAt: DateTime.now(),
              ),
            );
            widget.setState!();
            Navigator.pop(context);
          },
          child: Text(StringConstants.add),
        ),
      ],
    );
  }
}
