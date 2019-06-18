import 'package:meta/meta.dart';

class Column {
  Column({
    @required this.name,
    @required String type,
    @required this.notNull,
  }) : type = type.toUpperCase();

  factory Column.decodeDB(Map<String, dynamic> map) => Column(
        name: map['name'] as String,
        type: map['type'] as String,
        notNull: (map['notnull'] as int ?? 0) != 0,
      );

  final String name;
  final String type;
  final bool notNull;

  String get sqlDefinition {
    var def = '"$name" $type';
    if (notNull) {
      def += ' NOT NULL';
    }
    return def;
  }

  @override
  int get hashCode => name.hashCode ^ type.hashCode ^ notNull.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Column &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          type == other.type &&
          notNull == other.notNull;
}
