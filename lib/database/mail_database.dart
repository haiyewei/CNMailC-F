import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'mail_database.g.dart';

@DataClassName('MailAccount')
class MailAccounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get emailAddress => text()();
  TextColumn get alias => text().nullable()();
  TextColumn get password => text()();
  TextColumn get serverType => text()(); // 例如 'IMAP', 'POP', 'SMTP'
  TextColumn get domain => text()();
  IntColumn get port => integer()();
  BoolColumn get isSsl => boolean()();
}

@DriftDatabase(tables: [MailAccounts])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 3; // Schema version 已更新

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 3) {
          // Migrate from schema version < 3 to 3
          await m.addColumn(mailAccounts, mailAccounts.alias);
        }
      },
    );
  }

  // 插入邮箱账户
  Future<int> insertMailAccount(MailAccountsCompanion account) {
    return into(mailAccounts).insert(account);
  }

  // 获取所有邮箱账户
  Future<List<MailAccount>> getAllMailAccounts() {
    return select(mailAccounts).get();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
