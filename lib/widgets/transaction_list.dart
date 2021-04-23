import 'package:expense_planner/widgets/transaction_item.dart';
import '../models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  TransactionList({this.transactions, this.deleteTx});

  @override
  Widget build(BuildContext context) {
    var center = Center(
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              "No transaction added yet!",
              style: Theme.of(context).textTheme.title,
            ),
            SizedBox(
              height: constraints.maxHeight * 0.08,
            ),
            Container(
                height: constraints.maxHeight * 0.6,
                child: Image.asset(
                  'assets/image/waiting.png',
                  fit: BoxFit.cover,
                )),
          ],
        );
      }),
    );
    var listView = ListView(
      children: transactions
          .map(
            (tx) => TransactionItem(
                key: ValueKey(tx.id), transaction: tx, deleteTx: deleteTx),
          )
          .toList(),
    );
    return transactions.isEmpty ? center : listView;
  }
}
