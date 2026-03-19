import 'package:fluent_ui/fluent_ui.dart';
import '../expenses/expense_model.dart';

class FolderWidget extends StatelessWidget {
  final String title;
  final List<Expense> expenses;
  final void Function(Expense) onExpenseTap;
  final void Function() onAddNew;

  const FolderWidget({
    super.key,
    required this.title,
    required this.expenses,
    required this.onExpenseTap,
    required this.onAddNew,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(FluentIcons.folder),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: FluentTheme.of(context).typography.bodyStrong,
                  ),
                ),
                IconButton(
                  icon: const Icon(FluentIcons.add),
                  onPressed: onAddNew,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (expenses.isEmpty)
              Text(
                'No expenses in this folder',
                style: FluentTheme.of(context).typography.caption?.copyWith(
                  color: Colors.grey[100],
                ),
              )
            else
              ...expenses.map((expense) => _ExpenseItem(
                expense: expense,
                onTap: () => onExpenseTap(expense),
              )),
          ],
        ),
      ),
    );
  }
}

class _ExpenseItem extends StatelessWidget {
  final Expense expense;
  final VoidCallback onTap;

  const _ExpenseItem({
    required this.expense,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(expense.title),
        subtitle: Text(
          expense.isSupplier 
              ? 'Supplier' 
              : '\$${expense.cost.toStringAsFixed(2)} - ${expense.processed ? "Processed" : "Pending"}',
        ),
        trailing: expense.isSupplier 
            ? const Icon(FluentIcons.organization)
            : Icon(
                expense.processed ? FluentIcons.completed : FluentIcons.clock,
                color: expense.processed ? Colors.green : Colors.orange,
              ),
        onPressed: onTap,
      ),
    );
  }
}