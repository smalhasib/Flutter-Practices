import 'package:expense_tracker/widgets/chart_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/Transaction.dart';

class Chart extends StatelessWidget {
  final List<Transaction> _recentTransactions;

  const Chart(this._recentTransactions);

  List<Map<String, Object>> get _groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      final totalSum = _recentTransactions.where((element) {
        var tx = element.date;
        return tx.day == weekDay.day &&
            tx.month == weekDay.month &&
            tx.year == weekDay.year;
      }).fold(
          0.0,
          (previousValue, element) =>
              (previousValue as double) + element.amount);

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
      };
    });
  }

  double get _totalSpending {
    return _groupedTransactionValues.fold(
        0.0,
        (previousValue, element) =>
            previousValue + (element['amount'] as double));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _groupedTransactionValues
              .map((e) => Flexible(
                    fit: FlexFit.tight,
                    child: CharBar(
                        e['day'] as String,
                        e['amount'] as double,
                        _totalSpending == 0.0
                            ? 0.0
                            : (e['amount'] as double) / _totalSpending),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
