class TransactionModel {
  var id;
  var user_id;
  var amount;
  var ta;
  var rec_id;

  TransactionModel(
      {required this.id,
        required this.user_id,
        required this.amount,
        required this.ta,
        required this.rec_id});

  factory TransactionModel.fromJSON(Map<String, dynamic> json) {
    return TransactionModel(
        id: int.parse(json['id'].toString()),
        user_id: json['user_id'],
        amount: json['amount'],
        ta: json['eta'],
        rec_id: json['rec_id']);
  }
}
