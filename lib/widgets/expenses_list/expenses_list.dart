import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  const ExpensesList(
      {super.key, required this.expenses, required this.onRemove});

  final List<Expense> expenses;
  final void Function(Expense exp) onRemove;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) {
        return Dismissible(
          secondaryBackground: Card(
            color:
                Theme.of(context).colorScheme.errorContainer.withOpacity(0.75),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
          background: Card(
            color: Theme.of(context)
                .colorScheme
                .tertiaryContainer
                .withOpacity(0.75),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.centerLeft,
              child: Icon(
                Icons.archive,
                color: Theme.of(context).colorScheme.onTertiaryContainer,
              ),
            ),
          ),
          key: ValueKey(expenses[index].id),
          child: ExpenseItem(
            expenses[index],
          ),
          onDismissed: (_) => onRemove(expenses[index]),
        );
      },
    );
  }
}
