import 'package:flutter/material.dart';

class EditingActions extends StatefulWidget {
  final bool didChange;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const EditingActions({
    Key? key,
    required this.didChange,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<EditingActions> createState() => _EditingActionsState();
}

class _EditingActionsState extends State<EditingActions> {
  late bool didChange;

  @override
  void initState() {
    super.initState();
    didChange = widget.didChange;
  }

  @override
  void didUpdateWidget(covariant EditingActions oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.didChange != oldWidget.didChange) {
      didChange = widget.didChange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final saveButton = TextButton(
      style: TextButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
      onPressed: widget.onSave,
      child: const Text("Save", style: TextStyle(color: Colors.white)),
    );

    final cancelButton = TextButton(
      onPressed: widget.onCancel,
      child: const Text("Cancel", style: TextStyle(color: Colors.black)),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 150),
          firstChild: saveButton,
          secondChild: const SizedBox.shrink(),
          crossFadeState: didChange ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          alignment: Alignment.centerRight,
          sizeCurve: Curves.easeInOut,
        ),
        VerticalDivider(width: didChange ? 4.0 : 0.0),
        cancelButton,
      ],
    );
  }
}
