class CreateBillRequestPositionPayer {
  int id;
  int personalPrice;
  int personalParts;

  CreateBillRequestPositionPayer({
    required this.id,
    required this.personalPrice,
    required this.personalParts,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'personalPrice': personalPrice,
        'personalParts': personalParts,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateBillRequestPositionPayer &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
