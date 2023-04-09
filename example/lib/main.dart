import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:enhanced_text_field/enhanced_text_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Enhanced Text Field Example'),
        ),
        body: Column(
          children: [
            // Segment(
            //   title: "Simple text input",
            //   child: _BasicInputWidget(
            //     initial: "Initial Input Value",
            //     focusNode: FocusNode(),
            //   ),
            // ),
            // const SizedBox(height: 16),

            Segment(
              title: "Date input",
              child: _DateInputWidget(
                initial: DateTime.now(),
                focusNode: FocusNode(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class Segment extends StatelessWidget {
  final String title;
  final Widget child;

  const Segment({Key? key, required this.title, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const Divider(),
            child,
          ],
        ),
      ),
    );
  }
}

class _BasicInputWidget extends StatefulWidget {
  final FocusNode focusNode;
  final String initial;

  const _BasicInputWidget({Key? key, required this.initial, required this.focusNode}) : super(key: key);

  @override
  State<_BasicInputWidget> createState() => _BasicInputWidgetState();
}

class _BasicInputWidgetState extends State<_BasicInputWidget> {
  String? current;

  @override
  Widget build(BuildContext context) {
    return EnhancedTextField<String>(
      initialValue: 'Initial',
      value: current,
      focusNode: widget.focusNode,
      onNewValueProposed: (updated, initial) async {
        print("New value proposed: $updated");
        return showAcceptNewValueDialog(context, updated, initial).then((value) {
          if (value == true) {
            print("New value accepted: $updated");
            return true;
          } else {
            print("New valee rejected, continue editing");
            return false;
          }
        });
      },
      valueMapper: ValueMapper.string,
      onValueChanged: (value) {
        print("Text Field's new value changed to: $value");
        setState(() {
          current = value;
        });
      },
    );
  }
}

class _DateInputWidget extends StatefulWidget {
  final FocusNode focusNode;
  final DateTime initial;

  const _DateInputWidget({Key? key, required this.focusNode, required this.initial}) : super(key: key);

  @override
  State<_DateInputWidget> createState() => _DateInputWidgetState();
}

class _DateInputWidgetState extends State<_DateInputWidget> {
  DateTime? current;

  @override
  Widget build(BuildContext context) {
    return EnhancedTextField<DateTime>(
      initialValue: widget.initial,
      value: current,
      focusNode: widget.focusNode,
      onNewValueProposed: (updated, initial) async {
        print("New value proposed: $updated");
        return showAcceptNewValueDialog(context, updated.toString(), initial.toString()).then((value) {
          if (value == true) {
            print("New value accepted: $updated");
            return true;
          } else {
            print("New value rejected, continue editing");
            return false;
          }
        });
      },
      valueMapper: ValueMapper.dateTime,
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: current ?? widget.initial,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        ).then((value) {
          if (value != null) {
            setState(() {
              current = value;
            });
          }
        });
      },
      onValueChanged: (value) {
        print("Text Field's new value changed to: ${value.toString()}");
        setState(() {
          current = value;
        });
      },
    );
  }
}

Future<bool?> showAcceptNewValueDialog<T>(BuildContext context, String newValue, String initialValue) async {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Accept new value?'),
        content: Text('New value: $newValue'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}
