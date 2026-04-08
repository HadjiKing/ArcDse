import 'package:arcdse/features/expenses/expense_model.dart';
import 'package:arcdse/features/expenses/expenses_store.dart';
import 'package:arcdse/features/settings/settings_stores.dart';
import 'package:arcdse/services/localization/locale.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

/// Shows the orders/invoices list for a selected supplier.
class SupplierWindow extends StatelessWidget {
  final List<Expense> orders;
  final Expense supplier;
  final VoidCallback onClose;

  const SupplierWindow({
    super.key,
    required this.orders,
    required this.supplier,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final currency = globalSettings.get("currency_______").value;
    final totalDue = orders
        .where((o) => !o.processed)
        .fold(0.0, (s, o) => s + o.cost);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Container(
          color: FluentTheme.of(context).inactiveBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(FluentIcons.back),
                onPressed: onClose,
              ),
              const SizedBox(width: 8),
              Text(supplier.title,
                  style: FluentTheme.of(context).typography.subtitle),
              const Spacer(),
              if (totalDue > 0)
                InfoBadge(
                  source: Text('$totalDue $currency'),
                ),
            ],
          ),
        ),
        // Orders list
        Expanded(
          child: orders.isEmpty
              ? Center(child: Text(txt("noResultsFound")))
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, i) {
                    final order = orders[i];
                    return _OrderTile(order: order, currency: currency);
                  },
                ),
        ),
      ],
    );
  }
}

class _OrderTile extends StatefulWidget {
  final Expense order;
  final String currency;
  const _OrderTile({required this.order, required this.currency});

  @override
  State<_OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<_OrderTile> {
  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    return ListTile(
      leading: Icon(
        order.processed
            ? FluentIcons.fabric_folder_confirm
            : FluentIcons.file_request,
        color:
            order.processed ? Colors.successPrimaryColor : Colors.warningPrimaryColor,
      ),
      title: Text(
          DateFormat('d MMM yyyy').format(order.date)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              '${order.cost.toStringAsFixed(2)} ${widget.currency}'),
          if (order.notes.isNotEmpty) Text(order.notes),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Checkbox(
            checked: order.processed,
            onChanged: (v) {
              setState(() {
                expenses.set(order..processed = v ?? false);
              });
            },
            content: Text(txt("paid")),
          ),
          IconButton(
            icon: const Icon(FluentIcons.delete),
            onPressed: () {
              expenses.set(
                  order..archived = !(order.archived ?? false));
            },
          ),
        ],
      ),
    );
  }
}
