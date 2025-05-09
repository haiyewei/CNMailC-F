// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mail_database.dart';

// ignore_for_file: type=lint
class $EmailAccountsTable extends EmailAccounts
    with TableInfo<$EmailAccountsTable, EmailAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EmailAccountsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 255,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _passwordMeta = const VerificationMeta(
    'password',
  );
  @override
  late final GeneratedColumn<String> password = GeneratedColumn<String>(
    'password',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pop3ServerHostMeta = const VerificationMeta(
    'pop3ServerHost',
  );
  @override
  late final GeneratedColumn<String> pop3ServerHost = GeneratedColumn<String>(
    'pop3_server_host',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pop3ServerPortMeta = const VerificationMeta(
    'pop3ServerPort',
  );
  @override
  late final GeneratedColumn<String> pop3ServerPort = GeneratedColumn<String>(
    'pop3_server_port',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pop3IsSecureMeta = const VerificationMeta(
    'pop3IsSecure',
  );
  @override
  late final GeneratedColumn<bool> pop3IsSecure = GeneratedColumn<bool>(
    'pop3_is_secure',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pop3_is_secure" IN (0, 1))',
    ),
    defaultValue: Constant(true),
  );
  static const VerificationMeta _smtpServerHostMeta = const VerificationMeta(
    'smtpServerHost',
  );
  @override
  late final GeneratedColumn<String> smtpServerHost = GeneratedColumn<String>(
    'smtp_server_host',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _smtpServerPortMeta = const VerificationMeta(
    'smtpServerPort',
  );
  @override
  late final GeneratedColumn<String> smtpServerPort = GeneratedColumn<String>(
    'smtp_server_port',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _smtpIsSecureMeta = const VerificationMeta(
    'smtpIsSecure',
  );
  @override
  late final GeneratedColumn<bool> smtpIsSecure = GeneratedColumn<bool>(
    'smtp_is_secure',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("smtp_is_secure" IN (0, 1))',
    ),
    defaultValue: Constant(true),
  );
  static const VerificationMeta _imapServerHostMeta = const VerificationMeta(
    'imapServerHost',
  );
  @override
  late final GeneratedColumn<String> imapServerHost = GeneratedColumn<String>(
    'imap_server_host',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imapServerPortMeta = const VerificationMeta(
    'imapServerPort',
  );
  @override
  late final GeneratedColumn<String> imapServerPort = GeneratedColumn<String>(
    'imap_server_port',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(minTextLength: 1),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imapIsSecureMeta = const VerificationMeta(
    'imapIsSecure',
  );
  @override
  late final GeneratedColumn<bool> imapIsSecure = GeneratedColumn<bool>(
    'imap_is_secure',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("imap_is_secure" IN (0, 1))',
    ),
    defaultValue: Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    username,
    password,
    pop3ServerHost,
    pop3ServerPort,
    pop3IsSecure,
    smtpServerHost,
    smtpServerPort,
    smtpIsSecure,
    imapServerHost,
    imapServerPort,
    imapIsSecure,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'email_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<EmailAccount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    } else if (isInserting) {
      context.missing(_usernameMeta);
    }
    if (data.containsKey('password')) {
      context.handle(
        _passwordMeta,
        password.isAcceptableOrUnknown(data['password']!, _passwordMeta),
      );
    } else if (isInserting) {
      context.missing(_passwordMeta);
    }
    if (data.containsKey('pop3_server_host')) {
      context.handle(
        _pop3ServerHostMeta,
        pop3ServerHost.isAcceptableOrUnknown(
          data['pop3_server_host']!,
          _pop3ServerHostMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pop3ServerHostMeta);
    }
    if (data.containsKey('pop3_server_port')) {
      context.handle(
        _pop3ServerPortMeta,
        pop3ServerPort.isAcceptableOrUnknown(
          data['pop3_server_port']!,
          _pop3ServerPortMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_pop3ServerPortMeta);
    }
    if (data.containsKey('pop3_is_secure')) {
      context.handle(
        _pop3IsSecureMeta,
        pop3IsSecure.isAcceptableOrUnknown(
          data['pop3_is_secure']!,
          _pop3IsSecureMeta,
        ),
      );
    }
    if (data.containsKey('smtp_server_host')) {
      context.handle(
        _smtpServerHostMeta,
        smtpServerHost.isAcceptableOrUnknown(
          data['smtp_server_host']!,
          _smtpServerHostMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_smtpServerHostMeta);
    }
    if (data.containsKey('smtp_server_port')) {
      context.handle(
        _smtpServerPortMeta,
        smtpServerPort.isAcceptableOrUnknown(
          data['smtp_server_port']!,
          _smtpServerPortMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_smtpServerPortMeta);
    }
    if (data.containsKey('smtp_is_secure')) {
      context.handle(
        _smtpIsSecureMeta,
        smtpIsSecure.isAcceptableOrUnknown(
          data['smtp_is_secure']!,
          _smtpIsSecureMeta,
        ),
      );
    }
    if (data.containsKey('imap_server_host')) {
      context.handle(
        _imapServerHostMeta,
        imapServerHost.isAcceptableOrUnknown(
          data['imap_server_host']!,
          _imapServerHostMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_imapServerHostMeta);
    }
    if (data.containsKey('imap_server_port')) {
      context.handle(
        _imapServerPortMeta,
        imapServerPort.isAcceptableOrUnknown(
          data['imap_server_port']!,
          _imapServerPortMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_imapServerPortMeta);
    }
    if (data.containsKey('imap_is_secure')) {
      context.handle(
        _imapIsSecureMeta,
        imapIsSecure.isAcceptableOrUnknown(
          data['imap_is_secure']!,
          _imapIsSecureMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EmailAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EmailAccount(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      username:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}username'],
          )!,
      password:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}password'],
          )!,
      pop3ServerHost:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}pop3_server_host'],
          )!,
      pop3ServerPort:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}pop3_server_port'],
          )!,
      pop3IsSecure:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}pop3_is_secure'],
          )!,
      smtpServerHost:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}smtp_server_host'],
          )!,
      smtpServerPort:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}smtp_server_port'],
          )!,
      smtpIsSecure:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}smtp_is_secure'],
          )!,
      imapServerHost:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}imap_server_host'],
          )!,
      imapServerPort:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}imap_server_port'],
          )!,
      imapIsSecure:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}imap_is_secure'],
          )!,
    );
  }

  @override
  $EmailAccountsTable createAlias(String alias) {
    return $EmailAccountsTable(attachedDatabase, alias);
  }
}

class EmailAccount extends DataClass implements Insertable<EmailAccount> {
  final int id;
  final String username;
  final String password;
  final String pop3ServerHost;
  final String pop3ServerPort;
  final bool pop3IsSecure;
  final String smtpServerHost;
  final String smtpServerPort;
  final bool smtpIsSecure;
  final String imapServerHost;
  final String imapServerPort;
  final bool imapIsSecure;
  const EmailAccount({
    required this.id,
    required this.username,
    required this.password,
    required this.pop3ServerHost,
    required this.pop3ServerPort,
    required this.pop3IsSecure,
    required this.smtpServerHost,
    required this.smtpServerPort,
    required this.smtpIsSecure,
    required this.imapServerHost,
    required this.imapServerPort,
    required this.imapIsSecure,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['username'] = Variable<String>(username);
    map['password'] = Variable<String>(password);
    map['pop3_server_host'] = Variable<String>(pop3ServerHost);
    map['pop3_server_port'] = Variable<String>(pop3ServerPort);
    map['pop3_is_secure'] = Variable<bool>(pop3IsSecure);
    map['smtp_server_host'] = Variable<String>(smtpServerHost);
    map['smtp_server_port'] = Variable<String>(smtpServerPort);
    map['smtp_is_secure'] = Variable<bool>(smtpIsSecure);
    map['imap_server_host'] = Variable<String>(imapServerHost);
    map['imap_server_port'] = Variable<String>(imapServerPort);
    map['imap_is_secure'] = Variable<bool>(imapIsSecure);
    return map;
  }

  EmailAccountsCompanion toCompanion(bool nullToAbsent) {
    return EmailAccountsCompanion(
      id: Value(id),
      username: Value(username),
      password: Value(password),
      pop3ServerHost: Value(pop3ServerHost),
      pop3ServerPort: Value(pop3ServerPort),
      pop3IsSecure: Value(pop3IsSecure),
      smtpServerHost: Value(smtpServerHost),
      smtpServerPort: Value(smtpServerPort),
      smtpIsSecure: Value(smtpIsSecure),
      imapServerHost: Value(imapServerHost),
      imapServerPort: Value(imapServerPort),
      imapIsSecure: Value(imapIsSecure),
    );
  }

  factory EmailAccount.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EmailAccount(
      id: serializer.fromJson<int>(json['id']),
      username: serializer.fromJson<String>(json['username']),
      password: serializer.fromJson<String>(json['password']),
      pop3ServerHost: serializer.fromJson<String>(json['pop3ServerHost']),
      pop3ServerPort: serializer.fromJson<String>(json['pop3ServerPort']),
      pop3IsSecure: serializer.fromJson<bool>(json['pop3IsSecure']),
      smtpServerHost: serializer.fromJson<String>(json['smtpServerHost']),
      smtpServerPort: serializer.fromJson<String>(json['smtpServerPort']),
      smtpIsSecure: serializer.fromJson<bool>(json['smtpIsSecure']),
      imapServerHost: serializer.fromJson<String>(json['imapServerHost']),
      imapServerPort: serializer.fromJson<String>(json['imapServerPort']),
      imapIsSecure: serializer.fromJson<bool>(json['imapIsSecure']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'username': serializer.toJson<String>(username),
      'password': serializer.toJson<String>(password),
      'pop3ServerHost': serializer.toJson<String>(pop3ServerHost),
      'pop3ServerPort': serializer.toJson<String>(pop3ServerPort),
      'pop3IsSecure': serializer.toJson<bool>(pop3IsSecure),
      'smtpServerHost': serializer.toJson<String>(smtpServerHost),
      'smtpServerPort': serializer.toJson<String>(smtpServerPort),
      'smtpIsSecure': serializer.toJson<bool>(smtpIsSecure),
      'imapServerHost': serializer.toJson<String>(imapServerHost),
      'imapServerPort': serializer.toJson<String>(imapServerPort),
      'imapIsSecure': serializer.toJson<bool>(imapIsSecure),
    };
  }

  EmailAccount copyWith({
    int? id,
    String? username,
    String? password,
    String? pop3ServerHost,
    String? pop3ServerPort,
    bool? pop3IsSecure,
    String? smtpServerHost,
    String? smtpServerPort,
    bool? smtpIsSecure,
    String? imapServerHost,
    String? imapServerPort,
    bool? imapIsSecure,
  }) => EmailAccount(
    id: id ?? this.id,
    username: username ?? this.username,
    password: password ?? this.password,
    pop3ServerHost: pop3ServerHost ?? this.pop3ServerHost,
    pop3ServerPort: pop3ServerPort ?? this.pop3ServerPort,
    pop3IsSecure: pop3IsSecure ?? this.pop3IsSecure,
    smtpServerHost: smtpServerHost ?? this.smtpServerHost,
    smtpServerPort: smtpServerPort ?? this.smtpServerPort,
    smtpIsSecure: smtpIsSecure ?? this.smtpIsSecure,
    imapServerHost: imapServerHost ?? this.imapServerHost,
    imapServerPort: imapServerPort ?? this.imapServerPort,
    imapIsSecure: imapIsSecure ?? this.imapIsSecure,
  );
  EmailAccount copyWithCompanion(EmailAccountsCompanion data) {
    return EmailAccount(
      id: data.id.present ? data.id.value : this.id,
      username: data.username.present ? data.username.value : this.username,
      password: data.password.present ? data.password.value : this.password,
      pop3ServerHost:
          data.pop3ServerHost.present
              ? data.pop3ServerHost.value
              : this.pop3ServerHost,
      pop3ServerPort:
          data.pop3ServerPort.present
              ? data.pop3ServerPort.value
              : this.pop3ServerPort,
      pop3IsSecure:
          data.pop3IsSecure.present
              ? data.pop3IsSecure.value
              : this.pop3IsSecure,
      smtpServerHost:
          data.smtpServerHost.present
              ? data.smtpServerHost.value
              : this.smtpServerHost,
      smtpServerPort:
          data.smtpServerPort.present
              ? data.smtpServerPort.value
              : this.smtpServerPort,
      smtpIsSecure:
          data.smtpIsSecure.present
              ? data.smtpIsSecure.value
              : this.smtpIsSecure,
      imapServerHost:
          data.imapServerHost.present
              ? data.imapServerHost.value
              : this.imapServerHost,
      imapServerPort:
          data.imapServerPort.present
              ? data.imapServerPort.value
              : this.imapServerPort,
      imapIsSecure:
          data.imapIsSecure.present
              ? data.imapIsSecure.value
              : this.imapIsSecure,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EmailAccount(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('pop3ServerHost: $pop3ServerHost, ')
          ..write('pop3ServerPort: $pop3ServerPort, ')
          ..write('pop3IsSecure: $pop3IsSecure, ')
          ..write('smtpServerHost: $smtpServerHost, ')
          ..write('smtpServerPort: $smtpServerPort, ')
          ..write('smtpIsSecure: $smtpIsSecure, ')
          ..write('imapServerHost: $imapServerHost, ')
          ..write('imapServerPort: $imapServerPort, ')
          ..write('imapIsSecure: $imapIsSecure')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    username,
    password,
    pop3ServerHost,
    pop3ServerPort,
    pop3IsSecure,
    smtpServerHost,
    smtpServerPort,
    smtpIsSecure,
    imapServerHost,
    imapServerPort,
    imapIsSecure,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EmailAccount &&
          other.id == this.id &&
          other.username == this.username &&
          other.password == this.password &&
          other.pop3ServerHost == this.pop3ServerHost &&
          other.pop3ServerPort == this.pop3ServerPort &&
          other.pop3IsSecure == this.pop3IsSecure &&
          other.smtpServerHost == this.smtpServerHost &&
          other.smtpServerPort == this.smtpServerPort &&
          other.smtpIsSecure == this.smtpIsSecure &&
          other.imapServerHost == this.imapServerHost &&
          other.imapServerPort == this.imapServerPort &&
          other.imapIsSecure == this.imapIsSecure);
}

class EmailAccountsCompanion extends UpdateCompanion<EmailAccount> {
  final Value<int> id;
  final Value<String> username;
  final Value<String> password;
  final Value<String> pop3ServerHost;
  final Value<String> pop3ServerPort;
  final Value<bool> pop3IsSecure;
  final Value<String> smtpServerHost;
  final Value<String> smtpServerPort;
  final Value<bool> smtpIsSecure;
  final Value<String> imapServerHost;
  final Value<String> imapServerPort;
  final Value<bool> imapIsSecure;
  const EmailAccountsCompanion({
    this.id = const Value.absent(),
    this.username = const Value.absent(),
    this.password = const Value.absent(),
    this.pop3ServerHost = const Value.absent(),
    this.pop3ServerPort = const Value.absent(),
    this.pop3IsSecure = const Value.absent(),
    this.smtpServerHost = const Value.absent(),
    this.smtpServerPort = const Value.absent(),
    this.smtpIsSecure = const Value.absent(),
    this.imapServerHost = const Value.absent(),
    this.imapServerPort = const Value.absent(),
    this.imapIsSecure = const Value.absent(),
  });
  EmailAccountsCompanion.insert({
    this.id = const Value.absent(),
    required String username,
    required String password,
    required String pop3ServerHost,
    required String pop3ServerPort,
    this.pop3IsSecure = const Value.absent(),
    required String smtpServerHost,
    required String smtpServerPort,
    this.smtpIsSecure = const Value.absent(),
    required String imapServerHost,
    required String imapServerPort,
    this.imapIsSecure = const Value.absent(),
  }) : username = Value(username),
       password = Value(password),
       pop3ServerHost = Value(pop3ServerHost),
       pop3ServerPort = Value(pop3ServerPort),
       smtpServerHost = Value(smtpServerHost),
       smtpServerPort = Value(smtpServerPort),
       imapServerHost = Value(imapServerHost),
       imapServerPort = Value(imapServerPort);
  static Insertable<EmailAccount> custom({
    Expression<int>? id,
    Expression<String>? username,
    Expression<String>? password,
    Expression<String>? pop3ServerHost,
    Expression<String>? pop3ServerPort,
    Expression<bool>? pop3IsSecure,
    Expression<String>? smtpServerHost,
    Expression<String>? smtpServerPort,
    Expression<bool>? smtpIsSecure,
    Expression<String>? imapServerHost,
    Expression<String>? imapServerPort,
    Expression<bool>? imapIsSecure,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (username != null) 'username': username,
      if (password != null) 'password': password,
      if (pop3ServerHost != null) 'pop3_server_host': pop3ServerHost,
      if (pop3ServerPort != null) 'pop3_server_port': pop3ServerPort,
      if (pop3IsSecure != null) 'pop3_is_secure': pop3IsSecure,
      if (smtpServerHost != null) 'smtp_server_host': smtpServerHost,
      if (smtpServerPort != null) 'smtp_server_port': smtpServerPort,
      if (smtpIsSecure != null) 'smtp_is_secure': smtpIsSecure,
      if (imapServerHost != null) 'imap_server_host': imapServerHost,
      if (imapServerPort != null) 'imap_server_port': imapServerPort,
      if (imapIsSecure != null) 'imap_is_secure': imapIsSecure,
    });
  }

  EmailAccountsCompanion copyWith({
    Value<int>? id,
    Value<String>? username,
    Value<String>? password,
    Value<String>? pop3ServerHost,
    Value<String>? pop3ServerPort,
    Value<bool>? pop3IsSecure,
    Value<String>? smtpServerHost,
    Value<String>? smtpServerPort,
    Value<bool>? smtpIsSecure,
    Value<String>? imapServerHost,
    Value<String>? imapServerPort,
    Value<bool>? imapIsSecure,
  }) {
    return EmailAccountsCompanion(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      pop3ServerHost: pop3ServerHost ?? this.pop3ServerHost,
      pop3ServerPort: pop3ServerPort ?? this.pop3ServerPort,
      pop3IsSecure: pop3IsSecure ?? this.pop3IsSecure,
      smtpServerHost: smtpServerHost ?? this.smtpServerHost,
      smtpServerPort: smtpServerPort ?? this.smtpServerPort,
      smtpIsSecure: smtpIsSecure ?? this.smtpIsSecure,
      imapServerHost: imapServerHost ?? this.imapServerHost,
      imapServerPort: imapServerPort ?? this.imapServerPort,
      imapIsSecure: imapIsSecure ?? this.imapIsSecure,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (password.present) {
      map['password'] = Variable<String>(password.value);
    }
    if (pop3ServerHost.present) {
      map['pop3_server_host'] = Variable<String>(pop3ServerHost.value);
    }
    if (pop3ServerPort.present) {
      map['pop3_server_port'] = Variable<String>(pop3ServerPort.value);
    }
    if (pop3IsSecure.present) {
      map['pop3_is_secure'] = Variable<bool>(pop3IsSecure.value);
    }
    if (smtpServerHost.present) {
      map['smtp_server_host'] = Variable<String>(smtpServerHost.value);
    }
    if (smtpServerPort.present) {
      map['smtp_server_port'] = Variable<String>(smtpServerPort.value);
    }
    if (smtpIsSecure.present) {
      map['smtp_is_secure'] = Variable<bool>(smtpIsSecure.value);
    }
    if (imapServerHost.present) {
      map['imap_server_host'] = Variable<String>(imapServerHost.value);
    }
    if (imapServerPort.present) {
      map['imap_server_port'] = Variable<String>(imapServerPort.value);
    }
    if (imapIsSecure.present) {
      map['imap_is_secure'] = Variable<bool>(imapIsSecure.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EmailAccountsCompanion(')
          ..write('id: $id, ')
          ..write('username: $username, ')
          ..write('password: $password, ')
          ..write('pop3ServerHost: $pop3ServerHost, ')
          ..write('pop3ServerPort: $pop3ServerPort, ')
          ..write('pop3IsSecure: $pop3IsSecure, ')
          ..write('smtpServerHost: $smtpServerHost, ')
          ..write('smtpServerPort: $smtpServerPort, ')
          ..write('smtpIsSecure: $smtpIsSecure, ')
          ..write('imapServerHost: $imapServerHost, ')
          ..write('imapServerPort: $imapServerPort, ')
          ..write('imapIsSecure: $imapIsSecure')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $EmailAccountsTable emailAccounts = $EmailAccountsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [emailAccounts];
}

typedef $$EmailAccountsTableCreateCompanionBuilder =
    EmailAccountsCompanion Function({
      Value<int> id,
      required String username,
      required String password,
      required String pop3ServerHost,
      required String pop3ServerPort,
      Value<bool> pop3IsSecure,
      required String smtpServerHost,
      required String smtpServerPort,
      Value<bool> smtpIsSecure,
      required String imapServerHost,
      required String imapServerPort,
      Value<bool> imapIsSecure,
    });
typedef $$EmailAccountsTableUpdateCompanionBuilder =
    EmailAccountsCompanion Function({
      Value<int> id,
      Value<String> username,
      Value<String> password,
      Value<String> pop3ServerHost,
      Value<String> pop3ServerPort,
      Value<bool> pop3IsSecure,
      Value<String> smtpServerHost,
      Value<String> smtpServerPort,
      Value<bool> smtpIsSecure,
      Value<String> imapServerHost,
      Value<String> imapServerPort,
      Value<bool> imapIsSecure,
    });

class $$EmailAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $EmailAccountsTable> {
  $$EmailAccountsTableFilterComposer({
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

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pop3ServerHost => $composableBuilder(
    column: $table.pop3ServerHost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pop3ServerPort => $composableBuilder(
    column: $table.pop3ServerPort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pop3IsSecure => $composableBuilder(
    column: $table.pop3IsSecure,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get smtpServerHost => $composableBuilder(
    column: $table.smtpServerHost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get smtpServerPort => $composableBuilder(
    column: $table.smtpServerPort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get smtpIsSecure => $composableBuilder(
    column: $table.smtpIsSecure,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imapServerHost => $composableBuilder(
    column: $table.imapServerHost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imapServerPort => $composableBuilder(
    column: $table.imapServerPort,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get imapIsSecure => $composableBuilder(
    column: $table.imapIsSecure,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EmailAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $EmailAccountsTable> {
  $$EmailAccountsTableOrderingComposer({
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

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get password => $composableBuilder(
    column: $table.password,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pop3ServerHost => $composableBuilder(
    column: $table.pop3ServerHost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pop3ServerPort => $composableBuilder(
    column: $table.pop3ServerPort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pop3IsSecure => $composableBuilder(
    column: $table.pop3IsSecure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get smtpServerHost => $composableBuilder(
    column: $table.smtpServerHost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get smtpServerPort => $composableBuilder(
    column: $table.smtpServerPort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get smtpIsSecure => $composableBuilder(
    column: $table.smtpIsSecure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imapServerHost => $composableBuilder(
    column: $table.imapServerHost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imapServerPort => $composableBuilder(
    column: $table.imapServerPort,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get imapIsSecure => $composableBuilder(
    column: $table.imapIsSecure,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EmailAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EmailAccountsTable> {
  $$EmailAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get password =>
      $composableBuilder(column: $table.password, builder: (column) => column);

  GeneratedColumn<String> get pop3ServerHost => $composableBuilder(
    column: $table.pop3ServerHost,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pop3ServerPort => $composableBuilder(
    column: $table.pop3ServerPort,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get pop3IsSecure => $composableBuilder(
    column: $table.pop3IsSecure,
    builder: (column) => column,
  );

  GeneratedColumn<String> get smtpServerHost => $composableBuilder(
    column: $table.smtpServerHost,
    builder: (column) => column,
  );

  GeneratedColumn<String> get smtpServerPort => $composableBuilder(
    column: $table.smtpServerPort,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get smtpIsSecure => $composableBuilder(
    column: $table.smtpIsSecure,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imapServerHost => $composableBuilder(
    column: $table.imapServerHost,
    builder: (column) => column,
  );

  GeneratedColumn<String> get imapServerPort => $composableBuilder(
    column: $table.imapServerPort,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get imapIsSecure => $composableBuilder(
    column: $table.imapIsSecure,
    builder: (column) => column,
  );
}

class $$EmailAccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EmailAccountsTable,
          EmailAccount,
          $$EmailAccountsTableFilterComposer,
          $$EmailAccountsTableOrderingComposer,
          $$EmailAccountsTableAnnotationComposer,
          $$EmailAccountsTableCreateCompanionBuilder,
          $$EmailAccountsTableUpdateCompanionBuilder,
          (
            EmailAccount,
            BaseReferences<_$AppDatabase, $EmailAccountsTable, EmailAccount>,
          ),
          EmailAccount,
          PrefetchHooks Function()
        > {
  $$EmailAccountsTableTableManager(_$AppDatabase db, $EmailAccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$EmailAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$EmailAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$EmailAccountsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> username = const Value.absent(),
                Value<String> password = const Value.absent(),
                Value<String> pop3ServerHost = const Value.absent(),
                Value<String> pop3ServerPort = const Value.absent(),
                Value<bool> pop3IsSecure = const Value.absent(),
                Value<String> smtpServerHost = const Value.absent(),
                Value<String> smtpServerPort = const Value.absent(),
                Value<bool> smtpIsSecure = const Value.absent(),
                Value<String> imapServerHost = const Value.absent(),
                Value<String> imapServerPort = const Value.absent(),
                Value<bool> imapIsSecure = const Value.absent(),
              }) => EmailAccountsCompanion(
                id: id,
                username: username,
                password: password,
                pop3ServerHost: pop3ServerHost,
                pop3ServerPort: pop3ServerPort,
                pop3IsSecure: pop3IsSecure,
                smtpServerHost: smtpServerHost,
                smtpServerPort: smtpServerPort,
                smtpIsSecure: smtpIsSecure,
                imapServerHost: imapServerHost,
                imapServerPort: imapServerPort,
                imapIsSecure: imapIsSecure,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String username,
                required String password,
                required String pop3ServerHost,
                required String pop3ServerPort,
                Value<bool> pop3IsSecure = const Value.absent(),
                required String smtpServerHost,
                required String smtpServerPort,
                Value<bool> smtpIsSecure = const Value.absent(),
                required String imapServerHost,
                required String imapServerPort,
                Value<bool> imapIsSecure = const Value.absent(),
              }) => EmailAccountsCompanion.insert(
                id: id,
                username: username,
                password: password,
                pop3ServerHost: pop3ServerHost,
                pop3ServerPort: pop3ServerPort,
                pop3IsSecure: pop3IsSecure,
                smtpServerHost: smtpServerHost,
                smtpServerPort: smtpServerPort,
                smtpIsSecure: smtpIsSecure,
                imapServerHost: imapServerHost,
                imapServerPort: imapServerPort,
                imapIsSecure: imapIsSecure,
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

typedef $$EmailAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EmailAccountsTable,
      EmailAccount,
      $$EmailAccountsTableFilterComposer,
      $$EmailAccountsTableOrderingComposer,
      $$EmailAccountsTableAnnotationComposer,
      $$EmailAccountsTableCreateCompanionBuilder,
      $$EmailAccountsTableUpdateCompanionBuilder,
      (
        EmailAccount,
        BaseReferences<_$AppDatabase, $EmailAccountsTable, EmailAccount>,
      ),
      EmailAccount,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$EmailAccountsTableTableManager get emailAccounts =>
      $$EmailAccountsTableTableManager(_db, _db.emailAccounts);
}
