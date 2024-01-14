import 'package:expense_tracker/expense_data.dart';
import 'package:expense_tracker/expense_item.dart';
import 'package:expense_tracker/expense_summary.dart';
import 'package:expense_tracker/expense_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final newExpenseNameController = TextEditingController();
  final newExpenseAmountController = TextEditingController();

  void addNewExpense() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add new Expense'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: newExpenseNameController,
              decoration: const InputDecoration(
                hintText: "Expense name",
              ),
            ),
            TextField(
              controller: newExpenseAmountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Amount in Rupees",
              ),
            ),
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: save,
            child: const Text('Save'),
          ),
          MaterialButton(
            onPressed: cancel,
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void save() {
    ExpenseItem newExpense = ExpenseItem(
      name: newExpenseNameController.text,
      amount: newExpenseAmountController.text,
      dateTime: DateTime.now(),
    );

    Provider.of<ExpenseData>(context, listen: false).addNewExpense(newExpense);
    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newExpenseNameController.clear();
    newExpenseAmountController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExpenseData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: FloatingActionButton(
          onPressed: addNewExpense,
          backgroundColor: Colors.black,
          child: const Icon(Icons.add, color: Colors.white,),
        ),
        body: ListView(children: [

          ExpenseSummary(startOfWeek: value.startOfWeekDate()),
          const SizedBox(height: 20,),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
          itemCount: value.getAllExpenseList().length,
          itemBuilder: (context, index) => ExpenseTile(
            name: value.getAllExpenseList()[index].name,
            amount: '₹${value.getAllExpenseList()[index].amount}',
            dateTime: value.getAllExpenseList()[index].dateTime,
          ),
        )
        ],),
      ),
    );
  }
}
