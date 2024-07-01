import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final inputFormat = DateFormat('dd/MM/yyyy');

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAdd});

  final void Function(Expense expense) onAdd;

  @override
  State<NewExpense> createState() {
    return _NewExpenseState();
  }
}

class _NewExpenseState extends State<NewExpense> {
  Category? _category;

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _dateController = TextEditingController();
  final _categoryController = TextEditingController();

  void _showDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1);

    var selectedDate = await showDatePicker(
      context: context,
      firstDate: firstDate,
      lastDate: now,
      initialDate: now,
    );

    setState(() {
      if (selectedDate != null) {
        _dateController.text = inputFormat.format(selectedDate);
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
        child: Column(
          children: [
            TextField(
              maxLength: 50,
              decoration: const InputDecoration(
                label: Text('Title'),
              ),
              controller: _titleController,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      label: Text('Amount'),
                      prefixText: '\$ ',
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: _amountController,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      label: Text('Date'),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    onTap: _showDatePicker,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: _dateController,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButton(
                    isExpanded: false,
                    value: _category,
                    items: Category.values
                        .map(
                          (Category cat) => DropdownMenuItem<Category>(
                            value: cat,
                            child: Text(
                              cat.name.toUpperCase(),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _category = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                      foregroundColor:
                          Theme.of(context).colorScheme.onPrimaryContainer),
                  child: const Text('Cancel'),
                ),
                const SizedBox(
                  width: 8,
                ),
                ElevatedButton(
                  onPressed: () {
                    double? amount = double.tryParse(_amountController.text);

                    if (_titleController.text.trim().isEmpty ||
                        amount == null ||
                        amount < 0 ||
                        _dateController.text.isEmpty ||
                        _category == null) {
                      SnackBar snackBar = SnackBar(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        behavior: SnackBarBehavior.floating,
                        content: const Text(
                            'Please make sure a valid title, amount, date and category was entered.'),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }

                    Expense newExpense = Expense(
                      title: _titleController.text,
                      amount: amount,
                      date: inputFormat.parse(_dateController.text),
                      category: _category!,
                    );

                    widget.onAdd(newExpense);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    foregroundColor:
                        Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  child: const Text('Save'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
