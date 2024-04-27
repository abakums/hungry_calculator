import 'create_bill_request_position_payer.dart';

class CreateBillRequestPosition {
  String title;
  int price;
  int parts;
  List<CreateBillRequestPositionPayer> payers;

  CreateBillRequestPosition({
    required this.title,
    required this.price,
    required this.parts,
    required this.payers,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'price': price,
        'parts': parts,
        'payers': payers.map((payer) => payer.toJson()).toList(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateBillRequestPosition &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          price == other.price &&
          parts == other.parts &&
          payers == other.payers;

  @override
  int get hashCode =>
      title.hashCode ^ price.hashCode ^ parts.hashCode ^ payers.hashCode;
}
