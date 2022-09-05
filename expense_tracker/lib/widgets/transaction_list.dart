import 'package:expense_tracker/widgets/transaction_item.dart';
import 'package:flutter/material.dart';

import '../models/Transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransaction;
  final Function deleteTx;

  TransactionList(this.userTransaction, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return userTransaction.isEmpty
        ? LayoutBuilder(builder: (context, constraints) {
            final double maxHeight = constraints.maxHeight;

            return Padding(
              padding: EdgeInsets.only(top: maxHeight * 0.05),
              child: Column(
                children: [
                  Text(
                    'No transactions added yet!',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: maxHeight * 0.05),
                    height: maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/ledger.jpg',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
            );
          })
        : ListView.builder(
            itemBuilder: (context, index) =>
                TransactionItem(userTransaction[index], deleteTx),
            itemCount: userTransaction.length,
          );
  }
}
