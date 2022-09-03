import 'package:expense_tracker/widgets/transaction_item.dart';
import 'package:flutter/material.dart';

import '../models/Transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> userTransaction;
  final Function deleteTx;


  TransactionList(this.userTransaction, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 460,
        child: userTransaction.isEmpty
            ? Column(
                children: [
                  Text(
                    'No transactions added yet!',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    height: 200,
                    child: Image.asset(
                      'assets/images/ledger.jpg',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              )
            : ListView.builder(
                itemBuilder: (context, index) =>
                    TransactionItem(userTransaction[index], deleteTx),
                itemCount: userTransaction.length,
              ));
  }
}
