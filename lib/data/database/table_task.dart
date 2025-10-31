import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

class Tasks extends Table {
  // ignore: prefer_const_constructors
  TextColumn get id => text().clientDefault(() => Uuid().v4())();
  TextColumn get title => text()();
  TextColumn get description => text()();
  TextColumn get date => text()();
  TextColumn get time => text()();
  TextColumn get category => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
