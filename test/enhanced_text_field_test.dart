import 'package:enhanced_text_field/enhanced_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('basic widget', (tester) async {
    final key = UniqueKey();
    await pumpTextField(
      tester,
      EnhancedTextField<String>(
        key: key,
        initialValue: '',
        valueMapper: ValueMapper.string,
      ),
    );
    expect(find.byType(EnhancedTextField<String>), findsOneWidget);
    expect(find.widgetWithText(EnhancedTextField<String>, ''), findsOneWidget);
  });

  testWidgets('basic widget with initial value', (tester) async {
    final key = UniqueKey();
    await pumpTextField(
      tester,
      EnhancedTextField<String>(
        key: key,
        initialValue: 'Initial',
        valueMapper: ValueMapper.string,
      ),
    );
    expect(find.byType(EnhancedTextField<String>), findsOneWidget);
    expect(find.widgetWithText(EnhancedTextField<String>, 'Initial'), findsOneWidget);
  });

  testWidgets('basic widget with initial value "Initial" and changed value "Changed"', (tester) async {
    final key = UniqueKey();
    await pumpTextField(
      tester,
      EnhancedTextField<String>(
        key: key,
        initialValue: 'Initial',
        valueMapper: ValueMapper.string,
        value: 'Changed',
      ),
    );
    expect(find.byType(EnhancedTextField<String>), findsOneWidget);
    expect(find.widgetWithText(EnhancedTextField<String>, 'Initial'), findsNothing);
    expect(find.widgetWithText(EnhancedTextField<String>, 'Changed'), findsOneWidget);
  });

  testWidgets('basic widget on tap has focus', (tester) async {
    final key = UniqueKey();
    final focusNode = FocusNode();
    await pumpTextField(
      tester,
      EnhancedTextField<String>(
        key: key,
        initialValue: 'Initial',
        valueMapper: ValueMapper.string,
        value: 'Changed',
        focusNode: focusNode,
      ),
    );
    expect(find.byType(EnhancedTextField<String>), findsOneWidget);

    // request focus
    await tester.tap(find.byType(EnhancedTextField<String>));
    await tester.pumpAndSettle();
    expect(focusNode.hasFocus, isTrue);
  });

  testWidgets('basic widget on tap has focus', (tester) async {
    final key = UniqueKey();
    final focusNode = FocusNode();
    await pumpTextField(
      tester,
      EnhancedTextField<String>(
        key: key,
        initialValue: 'Initial',
        value: 'Changed',
        focusNode: focusNode,
        valueMapper: ValueMapper.string,
      ),
    );
    expect(find.byType(EnhancedTextField<String>), findsOneWidget);

    // request focus
    await tester.tap(find.byType(EnhancedTextField<String>));
    await tester.pumpAndSettle();
    expect(focusNode.hasFocus, isTrue);
  });

  // tests for:
  //  - focus change with editing actions
  //  - valueMapper
  //  - valueToString
  //  - onValueChanged
  //  - didChange
  //  - accept change
  //  - reject change
  //  - value updated
  //  - initial value updated
}

Future<void> pumpTextField<T>(WidgetTester tester, EnhancedTextField<T> textField) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: textField,
      ),
    ),
  );
  await tester.pumpAndSettle();
}
