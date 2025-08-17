class Transaction {
  String id;
  double amount;
  String description;
  DateTime date;

  Transaction({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      amount: map['amount'],
      description: map['description'],
      date: DateTime.parse(map['date']),
    );
  }
}
