import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:drift_dev/api/migrations_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_todo/data/database/database.dart';
import 'package:sqlite3/wasm.dart';

AppDatabase constructDb() {
  return AppDatabase(e: connectOnWeb());
}

DatabaseConnection connectOnWeb() {
  return DatabaseConnection.delayed(
    Future(() async {
      final result = await WasmDatabase.open(
        databaseName: 'todo-app',
        sqlite3Uri: Uri.parse('sqlite3.wasm'),
        driftWorkerUri: Uri.parse('drift_worker.js'),
      );

      if (result.missingFeatures.isNotEmpty) {
        // Depending how central local persistence is to your app, you may want
        // to show a warning to the user if only unrealiable implemetentations
        // are available.
        if (kDebugMode) {
          print(
            'Using ${result.chosenImplementation} due to missing browser '
            'features: ${result.missingFeatures}',
          );
        }
      }

      return result.resolvedExecutor;
    }),
  );
}

Future<void> validateDatabaseSchema(GeneratedDatabase database) async {
  // This method validates that the actual schema of the opened database matches
  // the tables, views, triggers and indices for which drift_dev has generated
  // code.
  // Validating the database's schema after opening it is generally a good idea,
  // since it allows us to get an early warning if we change a table definition
  // without writing a schema migration for it.
  //
  // For details, see: https://drift.simonbinder.eu/docs/advanced-features/migrations/#verifying-a-database-schema-at-runtime
  if (kDebugMode) {
    final sqlite = await WasmSqlite3.loadFromUrl(Uri.parse('/sqlite3.wasm'));
    sqlite.registerVirtualFileSystem(InMemoryFileSystem(), makeDefault: true);

    await VerifySelf(database).validateDatabaseSchema(sqlite3: sqlite);
  }
}
