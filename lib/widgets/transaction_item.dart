import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deleteTx,
  }) : super(key: key);

  final Transaction transaction;
  final Function deleteTx;

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color _bdColor;

  @override
  void initState() {
    const availaleColors = [
      Colors.red,
      Colors.redAccent,
      Colors.black,
      Colors.amber,
      Colors.amberAccent,
      Colors.blue,
      Colors.blueAccent,
      Colors.purple,
      Colors.purpleAccent,
      Colors.green,
      Colors.greenAccent,
      Colors.pink,
      Colors.pinkAccent,
    ];
    // _bdColor = availaleColors[Random().nextInt(availaleColors.length)];
    _bdColor = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      elevation: 5,
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: _bdColor,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(
              child: Text(
                  '₹:' + '${widget.transaction.amount.toStringAsFixed(2)}'),
            ),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(widget.transaction.date),
          style: TextStyle(
            color: Colors.grey,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: MediaQuery.of(context).size.width > 460
            ? TextButton.icon(
                onPressed: () => widget.deleteTx(widget.transaction.id),
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                label: Text(
                  "Delete",
                  style: TextStyle(color: Theme.of(context).errorColor),
                ),
              )
            : IconButton(
                icon: Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () => widget.deleteTx(widget.transaction.id),
              ),
      ),
    );
  }
}
