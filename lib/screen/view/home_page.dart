import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/expense_controller.dart';
import '../../helper/db_helper.dart';
import '../../modal/db_modal.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  get index => null;

  @override
  Widget build(BuildContext context) {
    ExpenseController expenseController = Get.put(ExpenseController());

    void addExpense() {
      TextEditingController titleController = TextEditingController();
      TextEditingController amountController = TextEditingController();
      TextEditingController categoryController = TextEditingController();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Add New ',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                      labelText: 'Title', border: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(
                      labelText: 'Amount', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                      labelText: 'Category', border: OutlineInputBorder()),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty &&
                      amountController.text.isNotEmpty &&
                      categoryController.text.isNotEmpty) {
                    Expense ex = Expense(
                        title: titleController.text,
                        amount: double.parse(amountController.text),
                        date: DateTime.now(),
                        category: categoryController.text);
                    expenseController.add(ex);
                    Get.back();
                  }
                },
                child: const Text('Add'),
              ),
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    }

    void showEditDialog(BuildContext context, Expense expense) {
      final TextEditingController titleController =
          TextEditingController(text: expense.title);
      final TextEditingController amountController =
          TextEditingController(text: expense.amount.toString());
      final TextEditingController categoryController =
          TextEditingController(text: expense.category);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edit Expense'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final updatedExpense = Expense(
                    id: expense.id,
                    title: titleController.text,
                    amount: double.tryParse(amountController.text) ?? 0.0,
                    category: categoryController.text,
                    date: expense.date,
                  );
                  // expenseController.updateExpense(updatedExpense);  // Update in controller
                  DBHelper.updateExpense(updatedExpense); // Update in database
                  Navigator.of(context).pop();
                },
                child: const Text('Save'),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              expenseController.allDataStoreToDataBase();
            },
            icon: const Icon(
              Icons.cloud,
              color: Colors.white,
            ),
          ),
        ],
        title: const Text(
          'Expense Tracker App ',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: Obx(() {
        if (expenseController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: expenseController.expenseList.length,
          itemBuilder: (context, index) {
            final expense = expenseController.expenseList[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  onTap: () {
                    showEditDialog(context, expense);
                  },
                  title: Text(expense.title),
                  subtitle: Text('${expense.amount} - ${expense.category}'),
                  trailing:
                      Text(expense.date.toLocal().toString().split(' ')[0]),
                  leading: InkWell(
                    onTap: () {
                      DBHelper.deleteExpense(
                          expenseController.expenseList[index].id!);
                    },
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: addExpense,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
