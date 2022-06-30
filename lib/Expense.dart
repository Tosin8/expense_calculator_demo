import 'package:intl/intl.dart';

class Expense {
  final int id;
  final double amount;
  final DateTime date;
  final String category;

  String get formattedDate {
    var formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  static final columns = ['id', 'amount', 'date', 'category'];
  Expense(this.id, this.amount, this.date, this.category);

  factory Expense.fromMap(Map<String, dynamic> date) {
    return Expense(date['id'], date['amount'], DateTime.parse(date['date']),
        date['category']);
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'amount': amount,
        'date': date.toString(),
        'category': category,
      };
}
