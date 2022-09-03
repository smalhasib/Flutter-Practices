import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addNewTx;

  NewTransaction(this.addNewTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty) return;

    String title = _titleController.text;
    double amount = double.parse(_amountController.text);

    if (title.isEmpty || amount < 1 || _selectedDate == null) return;

    widget.addNewTx.call(title, amount, _selectedDate);

    Navigator.of(context).pop();
  }

  void _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) return;
      setState(() {
        _selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              maxLines: 1,
              onSubmitted: (_) => _submitData(),
            ),
            TextField(
              keyboardType: TextInputType.number,
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              maxLines: 1,
              onSubmitted: (_) => _submitData(),
            ),
            SizedBox(
              height: 80,
              child: Row(
                children: [
                  Expanded(
                    child: Text(_selectedDate != null
                        ? 'Picked Date: ${DateFormat.yMd().format(_selectedDate!)}'
                        : 'No Date Chosen'),
                  ),
                  TextButton(
                    onPressed: _showDatePicker,
                    child: Text(
                      'Chose Date',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                onPressed: _submitData,
                child: const Text(
                  'Add Transaction',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
