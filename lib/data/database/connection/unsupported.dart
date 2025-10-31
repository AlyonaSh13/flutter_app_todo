import 'package:drift/drift.dart';
import 'package:flutter_app_todo/data/database/database.dart';

AppDatabase constructDb() => throw UnimplementedError();

Never _unsupported() {
  throw UnsupportedError(
    'No suitable database implementation was found on this platform.',
  );
}

// Depending on the platform the app is compiled to, the following stubs will
// be replaced with the methods in native.dart or web.dart

Future<void> validateDatabaseSchema(GeneratedDatabase database) async {
  _unsupported();
}
