import "package:flutter/material.dart";
import "package:task_manager/data/classes/task.dart";
import "package:task_manager/data/database_helper.dart";
import "package:task_manager/views/widgets/new_task_dialog.dart";
import "package:task_manager/views/widgets/task_widget.dart";

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  late DatabaseHelper dbHelper;

  @override
  void initState() {
    dbHelper = DatabaseHelper();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_task),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return NewTaskDialog(
                  dbHelper: dbHelper,
                  setState: setState,
                );
              });
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: FutureBuilder(
            future: dbHelper.getTasks(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else if (snapshot.data!.isNotEmpty) {
                final List<Task> tasks = snapshot.data!;
                return ListView.builder(
                    itemCount: tasks.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == tasks.length) {
                        return SizedBox(height: 70.0);
                      } else {
                        final task = tasks.elementAt(index);
                        return TaskWidget(
                          key: ValueKey(task.id),
                          task: task,
                          dbHelper: dbHelper,
                          setState: setState,
                        );
                      }
                    });
              } else {
                return Center(child: Text("Empty"));
              }
            }),
      ),
    );
  }
}
