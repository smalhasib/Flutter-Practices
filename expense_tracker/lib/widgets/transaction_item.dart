import 'package:expense_tracker/models/Transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final Function deleteTx;

  const TransactionItem(this.transaction, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(
              child: Text('\$${transaction.amount}'),
            ),
          ),
        ),
        title: Text(
          transaction.title,
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Text(DateFormat.yMMMd().format(transaction.date)),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          color: Theme.of(context).errorColor,
          onPressed: () => deleteTx(transaction.id),
        ),
      ),
    );
  }
}
