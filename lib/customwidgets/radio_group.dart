import 'package:flutter/material.dart';

class RadioGroup extends StatefulWidget {
  final String groupValue;
  final String label;
  final List<String> items;
  final Function(String) onItemSelected;

  const RadioGroup({
    super.key,
    required this.groupValue,
    required this.label,
    required this.items,
    required this.onItemSelected,
  });

  @override
  State<RadioGroup> createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {
  late String groupValue;
  @override
  void initState() {
    groupValue = widget.groupValue;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(widget.label),
            for(int i = 0; i < widget.items.length; i++)
              Row(
                children: [
                  Radio(
                    value: widget.items[i],
                    groupValue: groupValue,
                    onChanged: (value) {
                      setState(() {
                        groupValue = value!;
                      });
                      widget.onItemSelected(value!);
                    }
                  ),
                  Text(widget.items[i]),
                ],
              )
          ],
        ),
      ),
    );
  }
}
