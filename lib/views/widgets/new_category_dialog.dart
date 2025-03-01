import "package:flutter/material.dart";
import "package:task_manager/data/classes/category.dart";
import "package:task_manager/main.dart";
import "package:task_manager/views/widgets/task_form.dart";

class NewCategoryDialog extends StatefulWidget {
  const NewCategoryDialog({
    super.key,
    required this.widget,
  });

  final TaskFormState widget;

  @override
  State<NewCategoryDialog> createState() => _NewCategoryDialogState();
}

class _NewCategoryDialogState extends State<NewCategoryDialog> {
  final TextEditingController categoryController = TextEditingController();
  bool isCategoryEmpty = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          spacing: 16.0,
          children: [
            Expanded(
              child: TextField(
                controller: categoryController,
                decoration: InputDecoration(
                  hintText: "Category's name",
                  border: OutlineInputBorder(),
                  errorText: isCategoryEmpty ? "Empty" : null,
                ),
                onChanged: (value) {
                  setState(() {
                    isCategoryEmpty = false;
                  });
                },
              ),
            ),
            FilledButton(
              onPressed: () async {
                if (categoryController.text.trim().isEmpty) {
                  setState(() {
                    isCategoryEmpty = true;
                  });
                  return;
                }
                final Category newCategory =
                    Category(name: categoryController.text);
                int newId = await dbHelper.insertCategory(newCategory);
                widget.widget.setState(
                  () {
                    widget.widget.categoriesFuture = dbHelper.getCategories();
                    widget.widget.selectedCategoryId = newId;
                  },
                );
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}
