import "package:flutter/material.dart";
import "package:task_manager/data/constants.dart";
import "package:task_manager/data/styles.dart";
import "package:task_manager/main.dart";

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TextEditingController controller = TextEditingController();
  bool? isChecked = false;
  bool isSwitched = false;
  double sliderValue = 0.0;
  String? dropdownValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all(
                          Theme.of(context).colorScheme.error),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            icon: Icon(Icons.warning),
                            iconColor: Theme.of(context).colorScheme.error,
                            title: Text(StringConstants.taskDeleteConfirm),
                            content: Text(
                              "This will delete all your tasks and categories forever!",
                              textAlign: TextAlign.justify,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(StringConstants.cancel),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await dbHelper.recreateDatabase(
                                    await dbHelper.database,
                                  );
                                  if (context.mounted) Navigator.pop(context);
                                  // TODO: make the pages reload after the reset
                                },
                                style:
                                    getButtonStyle(context, ButtonTypes.danger),
                                child: Text(StringConstants.delete),
                              ),
                            ],
                            actionsAlignment: MainAxisAlignment.end,
                          );
                        },
                      );
                    },
                    child: Text("Delete all data")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
