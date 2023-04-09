# enhanced_text_field

Provides an enhanced text field with confirm and cancel buttons, while indicating a field has
changed from initial values. Assists in editing of forms and tracking and displaying changed fields.

## Installation
This package is not yet available on pub.dev. To use this package, add the following to your
pubspec.yaml file:

```yaml
dependencies:
  enhanced_text_field:
    git:
      url: https://github.com/cybex-dev/enhanced_text_field.git
      ref: master
```

## Getting Started

### Imports
```dart
import 'package:enhanced_text_field/enhanced_text_field.dart';
```

This is a (mostly) drop-in replacement for the standard `TextField` widget. It provides (mostly) the same functionality, with additional features.

### Example
```dart
EnhancedTextField<String>(
    initialValue: "Initial Value",
    controller: TextEditingController(),
    focusNode: FocusNode(),
    valueMapper: ValueMapper.string,
);
```

## Features

- Drop-in replacement for `TextField` widget.
- Indicate field changes with `didChange` property
- Accept/reject field changes with `Future<bool>` callback