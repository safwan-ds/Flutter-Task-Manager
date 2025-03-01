import "package:flutter/material.dart";
import "package:task_manager/data/classes/category.dart";
import "package:task_manager/data/classes/task.dart";
import "package:task_manager/data/constants.dart";
import "package:task_manager/data/styles.dart";
import "package:task_manager/main.dart";
import "package:task_manager/views/widgets/task_card.dart";

class TasksPage extends StatefulWidget {
  const TasksPage({
    super.key,
    required this.completed,
  });

  final bool completed;

  @override
  State<TasksPage> createState() => TasksPageState();

  Future<Map<String, dynamic>> loadData() async {
    final tasks = await dbHelper.getTasks(isCompleted: completed);
    final categories = await dbHelper.getCategories();
    return {"tasks": tasks, "categories": categories};
  }
}

class TasksPageState extends State<TasksPage> {
  late Future<Map<String, dynamic>> loadData;

  @override
  void initState() {
    super.initState();
    loadData = widget.loadData();
  }

  void refresh() {
    setState(() {
      loadData =
          widget.loadData(); // refresh both tasks and categories together
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: DoubleConstants.tasksPageVerticalPadding,
      ),
      child: FutureBuilder<Map<String, dynamic>>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator.adaptive());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            final tasks = snapshot.data!["tasks"] as List<Task>;
            final categories = snapshot.data!["categories"] as List<Category>;

            // Filter tasks based on completion status
            tasks.removeWhere(
              (task) => widget.completed ? !task.isCompleted : task.isCompleted,
            );

            if (tasks.isNotEmpty) {
              return ListView.builder(
                itemCount: tasks.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == tasks.length) {
                    return SizedBox(
                      height: DoubleConstants.spaceAfterTasks,
                    );
                  } else {
                    final task = tasks[index];
                    // Look up the category name from the cached categories list.
                    final categoryName = task.categoryId != null
                        ? categories
                            .firstWhere(
                              (cat) => cat.id == task.categoryId,
                              orElse: () => Category(id: 0, name: "Unknown"),
                            )
                            .name
                        : null;
                    return TaskCard(
                      key: ValueKey(task.id),
                      task: task,
                      category: categoryName,
                      widget: this,
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
                    widget.completed
                        ? "You have no completed tasks."
                        : StringConstants.noTasks,
                    textAlign: TextAlign.center,
                    style: LocalTextStyles.emptyPageText,
                  ),
                ),
              );
            }
          } else {
            return Center(child: CircularProgressIndicator.adaptive());
          }
        },
      ),
    );
  }
}
