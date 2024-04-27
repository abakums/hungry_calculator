import 'create_bill_response_position.dart';

class CreateBillResponse {
  List<CreateBillResponsePosition> positions;

  CreateBillResponse({required this.positions});

  factory CreateBillResponse.fromJson(Map<String, dynamic> json) =>
      CreateBillResponse(
          positions: List<CreateBillResponsePosition>.from(json['positions']
              ?.map((positionJson) =>
                  CreateBillResponsePosition.fromJson(positionJson))));

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateBillResponse &&
          runtimeType == other.runtimeType &&
          positions == other.positions;

  @override
  int get hashCode => positions.hashCode;
}
