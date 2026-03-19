import 'package:fluent_ui/fluent_ui.dart';
import '../expenses/expense_model.dart';

class SupplierWindow extends StatelessWidget {
  final Expense supplier;
  final List<Expense> orders;
  final void Function(Expense) onOrderTap;
  final void Function() onAddOrder;

  const SupplierWindow({
    super.key,
    required this.supplier,
    required this.orders,
    required this.onOrderTap,
    required this.onAddOrder,
  });

  @override
  Widget build(BuildContext context) {
    final totalAmount = orders.fold(0.0, (sum, order) => sum + order.cost);
    final processedAmount = orders
        .where((order) => order.processed)
        .fold(0.0, (sum, order) => sum + order.cost);

    return ContentDialog(
      title: Text('Supplier: ${supplier.title}'),
      content: SizedBox(
        width: 600,
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Supplier Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      supplier.title,
                      style: FluentTheme.of(context).typography.subtitle,
                    ),
                    const SizedBox(height: 8),
                    if (supplier.notes.isNotEmpty)
                      Text(supplier.notes),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            title: 'Total Orders',
                            value: orders.length.toString(),
                            icon: FluentIcons.package,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _StatCard(
                            title: 'Total Amount',
                            value: '\$${totalAmount.toStringAsFixed(2)}',
                            icon: FluentIcons.money,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _StatCard(
                            title: 'Processed',
                            value: '\$${processedAmount.toStringAsFixed(2)}',
                            icon: FluentIcons.completed,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Orders Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Orders',
                    style: FluentTheme.of(context).typography.bodyStrong,
                  ),
                ),
                Button(
                  onPressed: onAddOrder,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(FluentIcons.add),
                      SizedBox(width: 4),
                      Text('Add Order'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Orders List
            Expanded(
              child: orders.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(FluentIcons.package, size: 48, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(
                            'No orders for this supplier',
                            style: FluentTheme.of(context).typography.caption?.copyWith(
                              color: Colors.grey[100],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return _OrderCard(
                          order: order,
                          onTap: () => onOrderTap(order),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        Button(
          child: const Text('Close'),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: FluentTheme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: FluentTheme.of(context).typography.bodyStrong,
          ),
          Text(
            title,
            style: FluentTheme.of(context).typography.caption?.copyWith(
              color: Colors.grey[100],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Expense order;
  final VoidCallback onTap;

  const _OrderCard({
    required this.order,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(order.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('\$${order.cost.toStringAsFixed(2)}'),
            if (order.items.isNotEmpty)
              Text(
                order.items.take(3).join(', ') + 
                (order.items.length > 3 ? '...' : ''),
                style: FluentTheme.of(context).typography.caption,
              ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: order.processed 
                ? Colors.green.withOpacity(0.1) 
                : Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: order.processed ? Colors.green : Colors.orange,
            ),
          ),
          child: Text(
            order.processed ? 'Processed' : 'Pending',
            style: TextStyle(
              color: order.processed ? Colors.green : Colors.orange,
              fontSize: 12,
            ),
          ),
        ),
        onPressed: onTap,
      ),
    );
  }
}