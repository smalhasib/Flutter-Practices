import 'dart:io';

import 'package:expense_tracker/widgets/chart.dart';
import 'package:expense_tracker/widgets/new_transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../models/Transaction.dart';
import '../widgets/transaction_list.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Colors.red,
          primarySwatch: Colors.purple,
        ),
        primarySwatch: Colors.purple,
        fontFamily: 'Lato',
        textTheme: ThemeData.light().textTheme.copyWith(
              titleSmall: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
              ),
              titleMedium: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(key),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage(Key? key) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _uuid = const Uuid();
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 69.99,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'Weekly Groceries',
    //   amount: 16.53,
    //   date: DateTime.now(),
    // ),
  ];
  bool _showSwitch = true;

  List<Transaction> get _recentTransactions {
    return _userTransactions
        .where((element) => element.date
            .isAfter(DateTime.now().subtract(const Duration(days: 7))))
        .toList();
  }

  void _addNewTransaction(String title, double amount, DateTime chosenDate) {
    final newTx = Transaction(
        id: _uuid.v1(), title: title, amount: amount, date: chosenDate);

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  void _showAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }

  void _toggleSwitch(bool value) {
    setState(() {
      _showSwitch = value;
    });
  }

  List<Widget> _buildLandscapeContent(
      double screenHeight, Widget txListWidget) {
    return [
      Container(
        padding: EdgeInsets.only(top: screenHeight * 0.05),
        height: screenHeight * 0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Show Chart',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            Switch.adaptive(
              value: _showSwitch,
              activeColor: Theme.of(context).colorScheme.secondary,
              onChanged: _toggleSwitch,
            )
          ],
        ),
      ),
      _showSwitch
          ? SizedBox(
              height: screenHeight * 0.8,
              child: Chart(_recentTransactions),
            )
          : txListWidget
    ];
  }

  List<Widget> _buildPortraitContent(double screenHeight, Widget txListWidget) {
    return [
      SizedBox(
        height: screenHeight * 0.4,
        child: Chart(_recentTransactions),
      ),
      txListWidget
    ];
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text('Expense Tracker'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: const Icon(CupertinoIcons.add),
                  onTap: () => _showAddNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            title: const Text('Expense Tracker'),
            actions: [
              IconButton(
                onPressed: () => _showAddNewTransaction(context),
                icon: const Icon(Icons.add),
              )
            ],
          ) as PreferredSizeWidget;

    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double screenHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final SizedBox transactionListWidget = SizedBox(
      height: screenHeight * 0.6,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    final SafeArea pageBody = SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isLandscape)
                ..._buildLandscapeContent(screenHeight, transactionListWidget),
              if (!isLandscape)
                ..._buildPortraitContent(screenHeight, transactionListWidget),
            ],
          ),
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar as ObstructingPreferredSizeWidget,
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () => _showAddNewTransaction(context),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
