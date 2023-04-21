import 'package:enhanced_text_field/src/value_mapper.dart';
import 'package:flutter/material.dart';

import 'actions/editing_actions.dart';

typedef OnNewValueProposed<T> = Future<bool> Function(T newValue, T initialValue);

// typedef ChangedBuilder = Widget Function(BuildContext context, bool changed);

class EnhancedTextField<T> extends StatefulWidget {
  /// Text editing controller
  final TextEditingController? controller;

  /// Focus node allows showing additional editing actions when the text field is focused.
  final FocusNode? focusNode;

  /// The initial value of the text field, this is used to determine if the text field content has changed and stored in [didChange].
  /// Any changes to the text field content will be compared to this value to determine any changes.
  final T initialValue;

  /// The current value of the text field, this is used to determine if the text field content has changed and stored in [didChange].
  /// If [value] is null, [didChange] will be true if [initialValue] != [value].
  final T? value;

  /// Called when the controller's text content has changed by user input,
  /// [onNewValueProposed] is called to determine if the new value should be accepted.
  /// Default implementation returns true.
  final OnNewValueProposed<T>? onNewValueProposed;

  /// Called when value changed has been accepted, this represents the updated text field content.
  final ValueChanged<T>? onValueChanged;

  /// Format the value [T] to/from string to be displayed in the text field.
  final ValueMapper<T> valueMapper;

  /// When tapping on the text field, this callback is called. Useful for showing a date picker.
  final VoidCallback? onTap;

  /// Builder for the text field's [TextField.helperText] field, this allows customizing the changed widget for text field hint.
  /// If not provided, "* Pending Changes" is shown.
  /// final ChangedBuilder? changedBuilder;

  final bool? readOnly;
  final bool enabled;
  final String? hintText;
  final String? labelText;

  const EnhancedTextField({
    Key? key,
    required this.initialValue,
    required this.valueMapper,
    this.controller,
    this.focusNode,
    this.value,
    this.onNewValueProposed,
    this.onValueChanged,
    // this.changedBuilder,
    this.onTap,
    this.readOnly,
    this.enabled = true,
    this.hintText,
    this.labelText,
  }) : super(key: key);

  @override
  State<EnhancedTextField<T>> createState() => _EnhancedTextFieldState<T>();
}

class _EnhancedTextFieldState<T> extends State<EnhancedTextField<T>> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late T _initialValue;
  // late T _currentValue;
  bool didChange = false;
  late final ValueMapper<T> _valueMapper;

  @override
  void initState() {
    super.initState();
    _valueMapper = widget.valueMapper;
    _initialValue = widget.initialValue;

    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();

    _attachListeners();
    _onWidgetValueUpdated();
  }

  @override
  void didUpdateWidget(covariant EnhancedTextField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (!didChange) {
        setState(() {
          _initialValue = widget.initialValue;
          _controller.text = _valueMapper.format(widget.value ?? _initialValue);
        });
      } else {
        _onWidgetValueUpdated();
      }
    }
  }

  void _onWidgetValueUpdated() {
    if (widget.value != null) {
      // unnecessary cast, but required to avoid linter warning for [widget.value!]
      _evaluateDidChange(widget.value as T);
    }
    _updateControllerValue(widget.value ?? _initialValue);
  }

  void _attachListeners() {
    _focusNode.addListener(_onFocusChanged);
  }

  void _detachListeners() {
    _focusNode.removeListener(_onFocusChanged);
  }

  /// Update the TextEditingController's text value
  void _updateControllerValue(T value) {
    final newValue = _valueMapper.format(value);
    _controller.text = newValue;
  }

  /// On TextField content changed, update the internal current value
  void _onTextChanged(String value) {
    setState(() {
      final newValue = _valueMapper.map(value);
      _evaluateDidChange(newValue);
    });
  }

  /// Update the internal current value and set [didChange] to true if the new value is different from the initial value
  void _evaluateDidChange(T newValue) {
    // _currentValue = newValue;
    didChange = newValue != _initialValue;
  }

  void _onFocusChanged() {
    setState(() {});
  }

  void _onSave(String value) async {
    // remove focus on text field
    _focusNode.unfocus();

    // ask user to confirm the change
    bool acceptNewValue = true;
    final newValue = _valueMapper.map(value);
    if (widget.onNewValueProposed != null) {
      acceptNewValue = await widget.onNewValueProposed!(newValue, _initialValue);
    }
    // if the user does not accept the new value, re-focus the text field for further editing
    if (!acceptNewValue) {
      _focusNode.requestFocus();
      return;
    }

    // set new initial value * update [current] internal value
    _initialValue = newValue;
    _evaluateDidChange(newValue);

    // update the value with callback for user to handle
    widget.onValueChanged?.call(newValue);
  }

  void _onRejectChanges() {
    setState(() {
      _controller.text = _valueMapper.format(_initialValue);
      _focusNode.unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final editingActions = EditingActions(
      didChange: didChange,
      onSave: () => _onSave(_controller.text),
      onCancel: _onRejectChanges,
    );
    final editButton = IconButton(
      icon: const Icon(Icons.edit),
      onPressed: () {
        setState(() {
          _focusNode.requestFocus();
        });
      },
    );

    final textField = TextFormField(
      focusNode: _focusNode,
      controller: _controller,
      validator: (value) => value!.isEmpty ? "Required" : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      readOnly: widget.readOnly ?? !_focusNode.hasFocus,
      onTap: widget.onTap,
      onEditingComplete: () => _onSave(_controller.text),
      onChanged: _onTextChanged,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        hintText: widget.hintText,
        labelText: widget.labelText,
        enabled: widget.enabled,
        helperText: didChange ? "Pending changes" : null,
        helperStyle: TextStyle(color: Theme.of(context).primaryColor),
        alignLabelWithHint: true,
        suffix: _focusNode.hasFocus ? editingActions : null,
        suffixIcon: _focusNode.hasFocus ? null : didChange ? editingActions : editButton,
        prefixText: didChange ? "*" : null,
        prefixStyle: TextStyle(color: Theme.of(context).primaryColor),
      ),
    );

    return Container(
      padding: const EdgeInsets.only(top: 8.0),
      child: textField,
    );
  }

  @override
  void dispose() {
    _detachListeners();

    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }
}
