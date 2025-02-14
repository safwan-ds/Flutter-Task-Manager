import "package:flutter/material.dart";
import "package:task_manager/data/classes/task.dart";
import "package:task_manager/data/database_helper.dart";

class EditTaskDialog extends StatefulWidget {
  const EditTaskDialog({
    super.key,
    required this.task,
    required this.dbHelper,
    required this.setState,
  });

  final Task task;
  final DatabaseHelper dbHelper;
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
              hintText: "Tasks's title",
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
              hintText: "Tasks's description",
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
            widget.dbHelper.updateTask(
              Task(
                id: id,
                title: _titleController.text,
                description: _descController.text,
                dueDate: _selectedDate,
                createdAt: _createdAt,
              ),
            );
            widget.setState(() {});
            Navigator.pop(context);
          },
          child: Text("Confirm"),
        ),
      ],
    );
  }
}
