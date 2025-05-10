// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mail_database.dart';

// ignore_for_file: type=lint
class $MailAccountsTable extends MailAccounts
    with TableInfo<$MailAccountsTable, MailAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MailAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _emailAddressMeta = const VerificationMeta(
    'emailAddress',
  );
  @override
  late final GeneratedColumn<String> emailAddress = GeneratedColumn<String>(
    'email_address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aliasMeta = const VerificationMeta('alias');
  @override
  late final GeneratedColumn<String> alias = GeneratedColumn<String>(
    'alias',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta(
    'password',
  );
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverTypeMeta = const VerificationMeta(
    'serverType',
  );
  @override
  late final GeneratedColumn<String> serverType = GeneratedColumn<String>(
    'server_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _domainMeta = const VerificationMeta('domain');
  @override
  late final GeneratedColumn<String> domain = GeneratedColumn<String>(
    'domain',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _portMeta = const VerificationMeta('port');
  @override
  late final GeneratedColumn<int> port = GeneratedColumn<int>(
    'port',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSslMeta = const VerificationMeta('isSsl');
  @override
  late final GeneratedColumn<bool> isSsl = GeneratedColumn<bool>(
    'is_ssl',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_ssl" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    emailAddress,
    alias,
    password,
    serverType,
    domain,
    port,
    isSsl,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mail_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<MailAccount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('email_address')) {
      context.handle(
        _emailAddressMeta,
        emailAddress.isAcceptableOrUnknown(
          data['email_address']!,
          _emailAddressMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_emailAddressMeta);
    }
    if (data.containsKey('alias')) {
      context.handle(
        _aliasMeta,
        alias.isAcceptableOrUnknown(data['alias']!, _aliasMeta),
      );
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('server_type')) {
      context.handle(
        _serverTypeMeta,
        serverType.isAcceptableOrUnknown(data['server_type']!, _serverTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_serverTypeMeta);
    }
    if (data.containsKey('domain')) {
      context.handle(
        _domainMeta,
        domain.isAcceptableOrUnknown(data['domain']!, _domainMeta),
      );
    } else if (isInserting) {
      context.missing(_domainMeta);
    }
    if (data.containsKey('port')) {
      context.handle(
        _portMeta,
        port.isAcceptableOrUnknown(data['port']!, _portMeta),
      );
    } else if (isInserting) {
      context.missing(_portMeta);
    }
    if (data.containsKey('is_ssl')) {
      context.handle(
        _isSslMeta,
        isSsl.isAcceptableOrUnknown(data['is_ssl']!, _isSslMeta),
      );
    } else if (isInserting) {
      context.missing(_isSslMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MailAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MailAccount(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      emailAddress:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}email_address'],
          )!,
      alias: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}alias'],
      ),
      password:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}password'],
          )!,
      serverType:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}server_type'],
          )!,
      domain:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}domain'],
          )!,
      port:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}port'],
          )!,
      isSsl:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_ssl'],
          )!,
    );
  }

  @override
  $MailAccountsTable createAlias(String alias) {
    return $MailAccountsTable(attachedDatabase, alias);
  }
}

class MailAccount extends DataClass implements Insertable<MailAccount> {
  final int id;
  final String emailAddress;
  final String? alias;
  final String password;
  final String serverType;
  final String domain;
  final int port;
  final bool isSsl;
  const MailAccount({
    required this.id,
    required this.emailAddress,
    this.alias,
    required this.password,
    required this.serverType,
    required this.domain,
    required this.port,
    required this.isSsl,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['email_address'] = Variable<String>(emailAddress);
    if (!nullToAbsent || alias != null) {
      map['alias'] = Variable<String>(alias);
    }
    map['password'] = Variable<String>(password);
    map['server_type'] = Variable<String>(serverType);
    map['domain'] = Variable<String>(domain);
    map['port'] = Variable<int>(port);
    map['is_ssl'] = Variable<bool>(isSsl);
    return map;
  }

  MailAccountsCompanion toCompanion(bool nullToAbsent) {
    return MailAccountsCompanion(
      id: Value(id),
      emailAddress: Value(emailAddress),
      alias:
          alias == null && nullToAbsent ? const Value.absent() : Value(alias),
      password: Value(password),
      serverType: Value(serverType),
      domain: Value(domain),
      port: Value(port),
      isSsl: Value(isSsl),
    );
  }

  factory MailAccount.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MailAccount(
      id: serializer.fromJson<int>(json['id']),
      emailAddress: serializer.fromJson<String>(json['emailAddress']),
      alias: serializer.fromJson<String?>(json['alias']),
      password: serializer.fromJson<String>(json['password']),
      serverType: serializer.fromJson<String>(json['serverType']),
      domain: serializer.fromJson<String>(json['domain']),
      port: serializer.fromJson<int>(json['port']),
      isSsl: serializer.fromJson<bool>(json['isSsl']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'emailAddress': serializer.toJson<String>(emailAddress),
      'alias': serializer.toJson<String?>(alias),
      'password': serializer.toJson<String>(password),
      'serverType': serializer.toJson<String>(serverType),
      'domain': serializer.toJson<String>(domain),
      'port': serializer.toJson<int>(port),
      'isSsl': serializer.toJson<bool>(isSsl),
    };
  }

  MailAccount copyWith({
    int? id,
    String? emailAddress,
    Value<String?> alias = const Value.absent(),
    String? password,
    String? serverType,
    String? domain,
    int? port,
    bool? isSsl,
  }) => MailAccount(
    id: id ?? this.id,
    emailAddress: emailAddress ?? this.emailAddress,
    alias: alias.present ? alias.value : this.alias,
    password: password ?? this.password,
    serverType: serverType ?? this.serverType,
    domain: domain ?? this.domain,
    port: port ?? this.port,
    isSsl: isSsl ?? this.isSsl,
  );
  MailAccount copyWithCompanion(MailAccountsCompanion data) {
    return MailAccount(
      id: data.id.present ? data.id.value : this.id,
      emailAddress:
          data.emailAddress.present
              ? data.emailAddress.value
              : this.emailAddress,
      alias: data.alias.present ? data.alias.value : this.alias,
      password: data.password.present ? data.password.value : this.password,
      serverType:
          data.serverType.present ? data.serverType.value : this.serverType,
      domain: data.domain.present ? data.domain.value : this.domain,
      port: data.port.present ? data.port.value : this.port,
      isSsl: data.isSsl.present ? data.isSsl.value : this.isSsl,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MailAccount(')
          ..write('id: $id, ')
          ..write('emailAddress: $emailAddress, ')
          ..write('alias: $alias, ')
          ..write('password: $password, ')
          ..write('serverType: $serverType, ')
          ..write('domain: $domain, ')
          ..write('port: $port, ')
          ..write('isSsl: $isSsl')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    emailAddress,
    alias,
    password,
    serverType,
    domain,
    port,
    isSsl,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MailAccount &&
          other.id == this.id &&
          other.emailAddress == this.emailAddress &&
          other.alias == this.alias &&
          other.password == this.password &&
          other.serverType == this.serverType &&
          other.domain == this.domain &&
          other.port == this.port &&
          other.isSsl == this.isSsl);
}

class MailAccountsCompanion extends UpdateCompanion<MailAccount> {
  final Value<int> id;
  final Value<String> emailAddress;
  final Value<String?> alias;
  final Value<String> password;
  final Value<String> serverType;
  final Value<String> domain;
  final Value<int> port;
  final Value<bool> isSsl;
  const MailAccountsCompanion({
    this.id = const Value.absent(),
    this.emailAddress = const Value.absent(),
    this.alias = const Value.absent(),
    this.password = const Value.absent(),
    this.serverType = const Value.absent(),
    this.domain = const Value.absent(),
    this.port = const Value.absent(),
    this.isSsl = const Value.absent(),
  });
  MailAccountsCompanion.insert({
    this.id = const Value.absent(),
    required String emailAddress,
    this.alias = const Value.absent(),
    required String password,
    required String serverType,
    required String domain,
    required int port,
    required bool isSsl,
  }) : emailAddress = Value(emailAddress),
       password = Value(password),
       serverType = Value(serverType),
       domain = Value(domain),
       port = Value(port),
       isSsl = Value(isSsl);
  static Insertable<MailAccount> custom({
    Expression<int>? id,
    Expression<String>? emailAddress,
    Expression<String>? alias,
    Expression<String>? password,
    Expression<String>? serverType,
    Expression<String>? domain,
    Expression<int>? port,
    Expression<bool>? isSsl,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (emailAddress != null) 'email_address': emailAddress,
      if (alias != null) 'alias': alias,
      if (password != null) 'password': password,
      if (serverType != null) 'server_type': serverType,
      if (domain != null) 'domain': domain,
      if (port != null) 'port': port,
      if (isSsl != null) 'is_ssl': isSsl,
    });
  }

  MailAccountsCompanion copyWith({
    Value<int>? id,
    Value<String>? emailAddress,
    Value<String?>? alias,
    Value<String>? password,
    Value<String>? serverType,
    Value<String>? domain,
    Value<int>? port,
    Value<bool>? isSsl,
  }) {
    return MailAccountsCompanion(
      id: id ?? this.id,
      emailAddress: emailAddress ?? this.emailAddress,
      alias: alias ?? this.alias,
      password: password ?? this.password,
      serverType: serverType ?? this.serverType,
      domain: domain ?? this.domain,
      port: port ?? this.port,
      isSsl: isSsl ?? this.isSsl,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (emailAddress.present) {
      map['email_address'] = Variable<String>(emailAddress.value);
    }
    if (alias.present) {
      map['alias'] = Variable<String>(alias.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (serverType.present) {
      map['server_type'] = Variable<String>(serverType.value);
    }
    if (domain.present) {
      map['domain'] = Variable<String>(domain.value);
    }
    if (port.present) {
      map['port'] = Variable<int>(port.value);
    }
    if (isSsl.present) {
      map['is_ssl'] = Variable<bool>(isSsl.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MailAccountsCompanion(')
          ..write('id: $id, ')
          ..write('emailAddress: $emailAddress, ')
          ..write('alias: $alias, ')
          ..write('password: $password, ')
          ..write('serverType: $serverType, ')
          ..write('domain: $domain, ')
          ..write('port: $port, ')
          ..write('isSsl: $isSsl')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MailAccountsTable mailAccounts = $MailAccountsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [mailAccounts];
}

typedef $$MailAccountsTableCreateCompanionBuilder =
    MailAccountsCompanion Function({
      Value<int> id,
      required String emailAddress,
      Value<String?> alias,
      required String password,
      required String serverType,
      required String domain,
      required int port,
      required bool isSsl,
    });
typedef $$MailAccountsTableUpdateCompanionBuilder =
    MailAccountsCompanion Function({
      Value<int> id,
      Value<String> emailAddress,
      Value<String?> alias,
      Value<String> password,
      Value<String> serverType,
      Value<String> domain,
      Value<int> port,
      Value<bool> isSsl,
    });

class $$MailAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $MailAccountsTable> {
  $$MailAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emailAddress => $composableBuilder(
    column: $table.emailAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get alias => $composableBuilder(
    column: $table.alias,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverType => $composableBuilder(
    column: $table.serverType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get domain => $composableBuilder(
    column: $table.domain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSsl => $composableBuilder(
    column: $table.isSsl,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MailAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $MailAccountsTable> {
  $$MailAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emailAddress => $composableBuilder(
    column: $table.emailAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get alias => $composableBuilder(
    column: $table.alias,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverType => $composableBuilder(
    column: $table.serverType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get domain => $composableBuilder(
    column: $table.domain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get port => $composableBuilder(
    column: $table.port,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSsl => $composableBuilder(
    column: $table.isSsl,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MailAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MailAccountsTable> {
  $$MailAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get emailAddress => $composableBuilder(
    column: $table.emailAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get alias =>
      $composableBuilder(column: $table.alias, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get serverType => $composableBuilder(
    column: $table.serverType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get domain =>
      $composableBuilder(column: $table.domain, builder: (column) => column);

  GeneratedColumn<int> get port =>
      $composableBuilder(column: $table.port, builder: (column) => column);

  GeneratedColumn<bool> get isSsl =>
      $composableBuilder(column: $table.isSsl, builder: (column) => column);
}

class $$MailAccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MailAccountsTable,
          MailAccount,
          $$MailAccountsTableFilterComposer,
          $$MailAccountsTableOrderingComposer,
          $$MailAccountsTableAnnotationComposer,
          $$MailAccountsTableCreateCompanionBuilder,
          $$MailAccountsTableUpdateCompanionBuilder,
          (
            MailAccount,
            BaseReferences<_$AppDatabase, $MailAccountsTable, MailAccount>,
          ),
          MailAccount,
          PrefetchHooks Function()
        > {
  $$MailAccountsTableTableManager(_$AppDatabase db, $MailAccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$MailAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$MailAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$MailAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> emailAddress = const Value.absent(),
                Value<String?> alias = const Value.absent(),
                Value<String> password = const Value.absent(),
                Value<String> serverType = const Value.absent(),
                Value<String> domain = const Value.absent(),
                Value<int> port = const Value.absent(),
                Value<bool> isSsl = const Value.absent(),
              }) => MailAccountsCompanion(
                id: id,
                emailAddress: emailAddress,
                alias: alias,
                password: password,
                serverType: serverType,
                domain: domain,
                port: port,
                isSsl: isSsl,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String emailAddress,
                Value<String?> alias = const Value.absent(),
                required String password,
                required String serverType,
                required String domain,
                required int port,
                required bool isSsl,
              }) => MailAccountsCompanion.insert(
                id: id,
                emailAddress: emailAddress,
                alias: alias,
                password: password,
                serverType: serverType,
                domain: domain,
                port: port,
                isSsl: isSsl,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MailAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MailAccountsTable,
      MailAccount,
      $$MailAccountsTableFilterComposer,
      $$MailAccountsTableOrderingComposer,
      $$MailAccountsTableAnnotationComposer,
      $$MailAccountsTableCreateCompanionBuilder,
      $$MailAccountsTableUpdateCompanionBuilder,
      (
        MailAccount,
        BaseReferences<_$AppDatabase, $MailAccountsTable, MailAccount>,
      ),
      MailAccount,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MailAccountsTableTableManager get mailAccounts =>
      $$MailAccountsTableTableManager(_db, _db.mailAccounts);
}
