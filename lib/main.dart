import 'dart:io' show Platform;
import './widgets/chart.dart';
import './widgets/transaction_list.dart';
import './widgets/new_transaction.dart';
import 'package:flutter/material.dart';
import './models/transaction.dart';
import 'package:flutter/cupertino.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown ,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // brightness: Brightness.dark,
        primarySwatch: Colors.purple,
        accentColor: Colors.amberAccent,
        errorColor: Colors.red,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransaction = [];
  bool _ShowChart = false;

  List<Transaction> get _recenttransaction {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addTransaction(String txtitle, double txamount, DateTime chosendate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txtitle,
        amount: txamount,
        date: chosendate);

    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: NewTransaction(addTx: _addTransaction));
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransaction.removeWhere((element) => element.id == id);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaquery, AppBar appbar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Show Chart",
            style: Theme.of(context).textTheme.title,
          ),
          Switch.adaptive(
              activeColor: Theme.of(context).accentColor,
              value: _ShowChart,
              onChanged: (value) {
                setState(() {
                  _ShowChart = value;
                });
              }),
        ],
      ),
      _ShowChart
          ? Container(
              height: (mediaquery.size.height -
                      appbar.preferredSize.height -
                      mediaquery.padding.top) *
                  0.7,
              child: Chart(
                _recenttransaction,
              ),
            )
          : txListWidget
    ];
  }

  List<Widget> _buildportraitContent(
      MediaQueryData mediaquery, AppBar appbar, Widget txListWidget) {
    return [
      Container(
        height: (mediaquery.size.height -
                appbar.preferredSize.height -
                mediaquery.padding.top) *
            0.3,
        child: Chart(
          _recenttransaction,
        ),
      ),
      txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    final isLandscape = mediaquery.orientation == Orientation.landscape;
    final PreferredSizeWidget _appbar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              "Expense app",
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                ),
              ],
            ),
          )
        : AppBar(
            title: Text(
              "Expense app",
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () => _startAddNewTransaction(context),
                icon: Icon(Icons.add),
              ),
            ],
          );

    var txListWidget = Container(
      height: (mediaquery.size.height -
              _appbar.preferredSize.height -
              mediaquery.padding.top) *
          0.7,
      child: TransactionList(
          transactions: _userTransaction, deleteTx: _deleteTransaction),
    );
    var pagebody = SafeArea(
      child: SingleChildScrollView(
        // scrollDirection: Axis.horizontal,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (isLandscape)
              ..._buildLandscapeContent(mediaquery, _appbar, txListWidget),
            if (!isLandscape)
              ..._buildportraitContent(mediaquery, _appbar, txListWidget),
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: _appbar,
            child: pagebody,
          )
        : Scaffold(
            appBar: _appbar,
            body: pagebody,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _startAddNewTransaction(context),
                    child: Icon(Icons.add),
                  ),
          );
  }
}
