import 'package:flutter/material.dart';

class _MultiSelectDialog extends StatefulWidget {
  final String title;
  final List<String> options;
  final List<String> initialSelected;

  const _MultiSelectDialog({
    required this.title,
    required this.options,
    required this.initialSelected,
  });

  @override
  State<_MultiSelectDialog> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<_MultiSelectDialog> {
  late List<String> selectedItems;

  @override
  void initState() {
    super.initState();
    selectedItems = List.from(widget.initialSelected);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          children: widget.options.map((item) {
            final isSelected = selectedItems.contains(item);
            return CheckboxListTile(
              value: isSelected,
              title: Text(item),
              onChanged: (checked) {
                setState(() {
                  if (checked == true) {
                    selectedItems.add(item);
                  } else {
                    selectedItems.remove(item);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, selectedItems),
          child: const Text('Xong'),
        ),
      ],
    );
  }
}

