import "dart:developer";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              DropdownButton(
                value: dropdownValue,
                items: [
                  DropdownMenuItem(
                    value: "e1",
                    child: Text("test 1"),
                  ),
                  DropdownMenuItem(
                    value: "e2",
                    child: Text("test 2"),
                  ),
                ],
                onChanged: (String? value) {
                  setState(() {
                    dropdownValue = value;
                  });
                },
              ),
              TextField(
                decoration: InputDecoration(border: OutlineInputBorder()),
                controller: controller,
                onEditingComplete: () {
                  setState(() {});
                },
              ),
              Text(controller.text),
              Checkbox(
                tristate: false,
                value: isChecked,
                onChanged: (bool? value) => setState(() {
                  isChecked = value;
                }),
              ),
              CheckboxListTile(
                  tristate: false,
                  title: Text("Test"),
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value;
                    });
                  }),
              CupertinoSwitch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
              ),
              SwitchListTile.adaptive(
                title: Text("test"),
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
              ),
              Slider(
                label: "test",
                min: 0.0,
                max: 10.0,
                divisions: 10,
                value: sliderValue,
                onChanged: (double value) {
                  setState(() {
                    sliderValue = value;
                  });
                  log(value.toString());
                },
              ),
              Divider(),
              InkWell(
                splashColor: Colors.teal,
                onTap: () => log("test"),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  color: Colors.white12,
                ),
              ),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Snackbar"),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Text("Snackbar test"),
                  ),
                  FilledButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AboutDialog();
                        },
                      );
                    },
                    child: Text("Dialog test"),
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("test"),
                            content: Text("Alert content"),
                            actions: [
                              FilledButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("Close"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text("Alert test"),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: Text("test"),
                  ),
                  CloseButton(),
                  BackButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
