import "package:flutter/material.dart";
import "package:task_manager/data/classes/task.dart";
import "package:task_manager/data/database_helper.dart";

class NewTaskDialog extends StatefulWidget {
  const NewTaskDialog({
    super.key,
    required this.dbHelper,
    required this.setState,
  });

  final DatabaseHelper dbHelper;
  final Function setState;

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
      lastDate: DateTime(2101), // Set the latest date the user can select
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
      title: Text("New Task"),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        spacing: 10.0,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: "Task's title",
              border: OutlineInputBorder(),
              errorText: _isEmpty ? "Title can't be empty" : null,
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
              hintText: "Task's description",
              border: OutlineInputBorder(),
            ),
          ),
          ListTile(
            onTap: () {
              _selectDate(context);
            },
            title: Text(
              _selectedDate == null
                  ? "No date selected"
                  : "${_selectedDate!.toLocal()}".split(" ")[0],
              textAlign: TextAlign.center,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ],
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
            widget.setState(() {});
            Navigator.pop(context);
          },
          child: Text("Add"),
        ),
      ],
    );
  }
}
