import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'mail_database.g.dart';

@DataClassName('EmailAccount')
class EmailAccounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().withLength(min: 1, max: 255).unique()();
  TextColumn get password => text().withLength(min: 1)();
  TextColumn get pop3ServerHost => text().withLength(min: 1)();
  TextColumn get pop3ServerPort => text().withLength(min: 1)();
  BoolColumn get pop3IsSecure => boolean().withDefault(Constant(true))();
  TextColumn get smtpServerHost => text().withLength(min: 1)();
  TextColumn get smtpServerPort => text().withLength(min: 1)();
  BoolColumn get smtpIsSecure => boolean().withDefault(Constant(true))();
  TextColumn get imapServerHost => text().withLength(min: 1)();
  TextColumn get imapServerPort => text().withLength(min: 1)();
  BoolColumn get imapIsSecure => boolean().withDefault(Constant(true))();
}

@DriftDatabase(tables: [EmailAccounts])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}