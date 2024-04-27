class CreateBillResponsePosition {
  int id;
  String title;

  CreateBillResponsePosition({
    required this.id,
    required this.title,
  });

  factory CreateBillResponsePosition.fromJson(Map<String, dynamic> json) =>
      CreateBillResponsePosition(
        id: json['id'],
        title: json['title'],
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateBillResponsePosition &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
