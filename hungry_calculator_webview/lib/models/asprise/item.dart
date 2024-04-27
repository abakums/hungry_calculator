class Item {
  double amount;
  String description;
  double qty;
  double unitPrice;

  Item({
    required this.amount,
    required this.description,
    required this.qty,
    required this.unitPrice,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        amount: json['amount'],
        description: json['description'],
        qty: json['qty'],
        unitPrice: json['unitPrice'],
      );

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'description': description,
        'qty': qty,
        'unitPrice': unitPrice
      };

  @override
  String toString() {
    return description;
  }
}
