import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/printer.dart';
import '../services/printer_service.dart';
import '../widgets/animated_button.dart';

class PrinterManagementPage extends StatefulWidget {
  const PrinterManagementPage({super.key});

  @override
  State<PrinterManagementPage> createState() => _PrinterManagementPageState();
}

class _PrinterManagementPageState extends State<PrinterManagementPage> {
  Printer? editingPrinter;

  @override
  Widget build(BuildContext context) {
    final service = context.watch<PrinterService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Printers')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openEditor(context, service),
        icon: const Icon(Icons.add),
        label: const Text('Add Printer'),
      ),
      body: service.printers.isEmpty
          ? const Center(child: Text('No printers available'))
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: service.printers.length,
              itemBuilder: (context, index) {
                final printer = service.printers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(printer.name.isNotEmpty ? printer.name[0] : '?'),
                    ),
                    title: Text(printer.name),
                    subtitle: Text('${printer.type} • \$${printer.price.toStringAsFixed(2)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _openEditor(context, service, printer: printer),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _confirmDelete(context, service, printer),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _openEditor(BuildContext context, PrinterService service, {Printer? printer}) async {
    final result = await showDialog<Printer>(
      context: context,
      builder: (_) => _PrinterEditorDialog(printer: printer),
    );

    if (result == null) return;

    if (printer == null) {
      service.addPrinter(result);
    } else {
      service.updatePrinter(result);
    }
  }

  void _confirmDelete(BuildContext context, PrinterService service, Printer printer) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remove printer?'),
        content: Text('Remove ${printer.name} from the lineup?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              service.removePrinter(printer.id);
              Navigator.pop(context);
            },
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }
}

class _PrinterEditorDialog extends StatefulWidget {
  final Printer? printer;
  const _PrinterEditorDialog({this.printer});

  @override
  State<_PrinterEditorDialog> createState() => _PrinterEditorDialogState();
}

class _PrinterEditorDialogState extends State<_PrinterEditorDialog> {
  late final TextEditingController nameController;
  late final TextEditingController typeController;
  late final TextEditingController priceController;
  late final TextEditingController ratingController;
  late final TextEditingController descriptionController;
  late final TextEditingController highlightsController;
  bool onSale = false;

  @override
  void initState() {
    super.initState();
    final p = widget.printer;
    nameController = TextEditingController(text: p?.name ?? '');
    typeController = TextEditingController(text: p?.type ?? '');
    priceController = TextEditingController(
      text: p != null ? p.price.toStringAsFixed(2) : '',
    );
    ratingController = TextEditingController(
      text: p != null ? p.rating.toStringAsFixed(1) : '',
    );
    descriptionController = TextEditingController(text: p?.description ?? '');
    highlightsController = TextEditingController(text: p?.highlights.join(', ') ?? '');
    onSale = p?.onSale ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.printer == null ? 'Add Printer' : 'Edit Printer'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: typeController,
              decoration: const InputDecoration(labelText: 'Type (Laser, Inkjet, etc.)'),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: ratingController,
              decoration: const InputDecoration(labelText: 'Rating (0-5)'),
              keyboardType: TextInputType.number,
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('On Sale'),
              value: onSale,
              onChanged: (value) => setState(() => onSale = value),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 2,
            ),
            TextField(
              controller: highlightsController,
              decoration: const InputDecoration(
                labelText: 'Highlights (comma separated)',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        AnimatedActionButton(
          onPressed: () {
            final name = nameController.text.trim();
            final type = typeController.text.trim();
            final price = double.tryParse(priceController.text) ?? 0;
            final rating = double.tryParse(ratingController.text) ?? 0;
            final highlights = highlightsController.text
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();

            if (name.isEmpty || type.isEmpty) return;

            final printer = (widget.printer ?? Printer(
              name: name,
              type: type,
              onSale: onSale,
              rating: rating,
              price: price,
              image: 'images/printers/canon_inkjet.png',
              description: descriptionController.text.trim(),
              highlights: highlights,
            ))
                .copyWith(
              name: name,
              type: type,
              price: price,
              rating: rating,
              onSale: onSale,
              description: descriptionController.text.trim(),
              highlights: highlights.isEmpty ? ['No highlights provided'] : highlights,
            );

            Navigator.pop(context, printer);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
