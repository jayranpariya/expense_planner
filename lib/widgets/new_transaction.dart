import 'dart:io';

import 'package:expense_planner/widgets/adaptive_flat_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;
  NewTransaction({this.addTx});

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = new TextEditingController();
  final _amountController = new TextEditingController();

  DateTime _selectedDate;

  void _submitData() {
    if (_amountController.text.isEmpty == null) {
      return;
    }
    final enteredtitle = _titleController.text;
    final enteredamount = double.parse(_amountController.text);

    if (enteredtitle.isEmpty || enteredamount <= 0 || _selectedDate == null) {
      return;
    }
    widget.addTx(enteredtitle, enteredamount, _selectedDate);
    Navigator.of(context).pop();
  }

  void _presentDatepicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        _selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double bottompadding = MediaQuery.of(context).viewInsets.bottom + 15;
    return SingleChildScrollView(
      child: Card(
      
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: bottompadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                      hintText: 'title',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      )),
                  controller: _titleController,
                  onSubmitted: (_) => _submitData(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Amount',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                  controller: _amountController,
                  onSubmitted: (_) => _submitData(),
                ),
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Text(_selectedDate == null
                        ? 'No Date chosen!'
                        : 'picked Date :  ${DateFormat.yMd().format(_selectedDate)}'),
                  ),
                  AdaptiveFlatButton('choose Date', _presentDatepicker),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: ElevatedButton(
                  onPressed: () => _submitData(),
                  child: Text('Add Transaction'),
                  style: ElevatedButton.styleFrom(
                    enabledMouseCursor: MouseCursor.defer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
