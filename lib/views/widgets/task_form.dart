import "package:flutter/material.dart";
import "package:task_manager/data/classes/category.dart";
import "package:task_manager/data/constants.dart";
import "package:task_manager/data/notifiers.dart";
import "package:task_manager/data/styles.dart";
import "package:task_manager/main.dart";
import "package:task_manager/views/widgets/new_category_dialog.dart";

class TaskForm extends StatefulWidget {
  const TaskForm({
    super.key,
    this.selectedCategoryId,
    this.selectedDate,
    this.selectedPriority,
  });

  final int? selectedCategoryId;
  final DateTime? selectedDate;
  final int? selectedPriority;

  @override
  State<TaskForm> createState() => TaskFormState();
}

class TaskFormState extends State<TaskForm> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  Future<List<Category>>? categoriesFuture;

  bool isEmpty = false;
  int? selectedCategoryId;
  DateTime? selectedDate;
  int? selectedPriority;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Set the initial date
      firstDate: DateTime.now(), // Set the earliest date the user can select
      lastDate: DateTime(
          IntegerConstants.lastDate), // Set the latest date the user can select
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    selectedDate = widget.selectedDate;
    categoriesFuture = dbHelper.getCategories();
    selectedPriority = widget.selectedPriority;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      spacing: 10.0,
      children: [
        // Title
        TextField(
          autofocus: true,
          controller: titleController,
          decoration: InputDecoration(
            hintText: StringConstants.taskTitle,
            border: OutlineInputBorder(),
            errorText: isEmpty ? StringConstants.emptyError : null,
          ),
          onChanged: (value) {
            if (isEmpty) {
              setState(
                () {
                  isEmpty = false;
                },
              );
            }
          },
        ),
        // Description
        TextField(
          controller: descController,
          decoration: InputDecoration(
            hintText: StringConstants.taskDescription,
            border: OutlineInputBorder(),
          ),
        ),
        // Category
        IntrinsicHeight(
          child: Row(
            // spacing: 16.0,
            children: [
              Flexible(
                flex: 2,
                child: Center(
                  child: FutureBuilder<List<Category>>(
                    future: categoriesFuture,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else if (snapshot.hasData && !snapshot.data.isEmpty) {
                          final categories = snapshot.data!;
                          return DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              // TODO: fix the issue with the text field focus
                              isExpanded: true,
                              itemHeight: null,
                              selectedItemBuilder: (context) {
                                return categories.map<Widget>(
                                  (category) {
                                    return DropdownMenuItem(
                                      child: Text(category.name),
                                    );
                                  },
                                ).toList();
                              },
                              value: selectedCategoryId,
                              hint: const Text("Select Category"),
                              items: categories.map<DropdownMenuItem<int>>(
                                (Category category) {
                                  return DropdownMenuItem<int>(
                                    value: category.id,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            category.name,
                                            softWrap: true,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              icon: Icon(Icons.warning),
                                              iconColor: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                              title: Text(
                                                  "Are you sure you want to delete this category?"),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  child: Text("Cancel"),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    // Close the dropdown menu.
                                                    Navigator.pop(context);
                                                    Navigator.pop(context);
                                                    // Optionally wait a brief moment to ensure the dropdown is closed.
                                                    await Future.delayed(
                                                        const Duration(
                                                            milliseconds: 100));
                                                    // Delete the category.
                                                    await dbHelper
                                                        .deleteCategory(
                                                            category.id!);
                                                    // Update the state. Optionally reset the selected category if it was the one deleted.
                                                    setState(
                                                      () {
                                                        categoriesFuture =
                                                            dbHelper
                                                                .getCategories();
                                                        if (selectedCategoryId ==
                                                            category.id) {
                                                          selectedCategoryId =
                                                              null;
                                                        }
                                                      },
                                                    );
                                                    categoryDeleteNotifier
                                                            .value =
                                                        !categoryDeleteNotifier
                                                            .value;
                                                  },
                                                  style: getButtonStyle(
                                                    context,
                                                    ButtonTypes.danger,
                                                  ),
                                                  child: Text("Delete"),
                                                )
                                              ],
                                            ),
                                          ),
                                          icon: Icon(Icons.delete),
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ).toList(),
                              onChanged: (int? newValue) {
                                setState(() {
                                  selectedCategoryId = newValue;
                                });
                              },
                            ),
                          );
                        } else {
                          return const Text("No categories available");
                        }
                      }
                    },
                  ),
                ),
              ),
              VerticalDivider(),
              Flexible(
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        // Category dialog
                        return NewCategoryDialog(
                          widget: this,
                        );
                      },
                    );
                  },
                  child: Text(
                    StringConstants.newCategory,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        Divider(),
        // Date
        ListTile(
          onTap: () {
            _selectDate(context);
          },
          title: Text(
            selectedDate == null
                ? StringConstants.noDate
                : "${selectedDate!.toLocal()}".split(" ")[0],
            textAlign: TextAlign.center,
          ),
          trailing: selectedDate != null
              ? TextButton(
                  onPressed: () {
                    if (selectedDate != null) {
                      setState(
                        () {
                          selectedDate = null;
                        },
                      );
                    }
                  },
                  child: Text("Remove"),
                )
              : null,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(DoubleConstants.dateTileBorderRadius),
          ),
        ),
        Divider(),
        DropdownButtonHideUnderline(
          child: DropdownButton(
            hint: Text("Priority"),
            value: selectedPriority,
            items: List.generate(
              StringConstants.priorityLabels.length,
              (index) => DropdownMenuItem(
                value: index,
                child: Text(
                  StringConstants.priorityLabels[index],
                ),
              ),
            ),
            onChanged: (value) {
              setState(() {
                selectedPriority = value;
              });
            },
          ),
        )
      ],
    );
  }
}
