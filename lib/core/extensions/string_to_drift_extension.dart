import 'package:drift/drift.dart';

extension NullableStringExtension on String? {
  Value<String> toDriftValue() => this != null && this!.trim().isNotEmpty ? Value(this!) : const Value.absent();
}
