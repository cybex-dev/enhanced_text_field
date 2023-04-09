abstract class ValueMapper<T> {
  static ValueMapper<String> string = _StringMapper();
  static ValueMapper<DateTime> dateTime = _DateMapper();

  /// Map the string value to the value [T] type.
  T map(String value);

  /// Format the value [T] to a string.
  String format(T value);
}

class _StringMapper implements ValueMapper<String> {
  @override
  String map(String value) => value;

  @override
  String format(String value) => value;
}

class _DateMapper implements ValueMapper<DateTime> {
  @override
  DateTime map(String value) => DateTime.parse(value);

  @override
  String format(DateTime value) => value.toIso8601String();
}