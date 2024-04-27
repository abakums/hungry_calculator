import 'package:tuple/tuple.dart';

import 'group_participant.dart';

class BillPosition {
  int? id;
  String title;
  int price;
  int parts;
  Map<GroupParticipant, Tuple2<int, int>> personalParts;

  BillPosition({
    this.id,
    required this.title,
    required this.price,
    required this.parts,
    required this.personalParts,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillPosition &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          price == other.price &&
          parts == other.parts &&
          personalParts == other.personalParts;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      price.hashCode ^
      parts.hashCode ^
      personalParts.hashCode;
}
