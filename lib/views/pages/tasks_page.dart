import "package:flutter/material.dart";
import "package:task_manager/data/classes/task.dart";
import "package:task_manager/data/constants.dart";
import "package:task_manager/data/database_helper.dart";
import "package:task_manager/data/styles.dart";
import "package:task_manager/views/widgets/task_widget.dart";

class TasksPage extends StatefulWidget {
  const TasksPage({
    super.key,
    required this.completed,
    required this.dbHelper,
  });

  final bool completed;
  final DatabaseHelper dbHelper;

  @override
  State<TasksPage> createState() => TasksPageState();
}

class TasksPageState extends State<TasksPage> {
  late DatabaseHelper dbHelper;

  @override
  void initState() {
    dbHelper = widget.dbHelper;
    super.initState();
  }

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: DoubleConstants.tasksPageVerticalPadding,
      ),
      child: FutureBuilder(
        future: dbHelper.getTasks(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<Task> tasks = snapshot.data!;
            tasks.removeWhere(
              (task) => widget.completed ? !task.isCompleted : task.isCompleted,
            );
            if (snapshot.data!.isNotEmpty) {
              return ListView.builder(
                itemCount: tasks.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == tasks.length) {
                    return SizedBox(
                      height: DoubleConstants.spaceAfterTasks,
                    );
                  } else {
                    final task = tasks.elementAt(index);
                    return TaskWidget(
                      key: ValueKey(task.id),
                      task: task,
                      dbHelper: dbHelper,
                      setState: setState,
                    );
                  }
                },
              );
            } else {
              return Center(
                child: Padding(
                  padding:
                      const EdgeInsets.all(DoubleConstants.noTasksTextPadding),
                  child: Text(
                    StringConstants.noTasks,
                    textAlign: TextAlign.center,
                    style: LocalTextStyles.noTasks,
                  ),
                ),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
        },
      ),
    );
  }
}
