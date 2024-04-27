import 'create_bill_request_position.dart';

class CreateBillRequest {
  String groupId;
  List<CreateBillRequestPosition> positions;

  CreateBillRequest({
    required this.groupId,
    required this.positions,
  });

  Map<String, dynamic> toJson() => {
        'groupId': groupId,
        'positions': positions.map((position) => position.toJson()).toList(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateBillRequest &&
          runtimeType == other.runtimeType &&
          groupId == other.groupId &&
          positions == other.positions;

  @override
  int get hashCode => groupId.hashCode ^ positions.hashCode;
}
