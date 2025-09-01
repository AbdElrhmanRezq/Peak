import 'package:flutter/material.dart';

class Scroller extends StatefulWidget {
  final String axix;
  final int value;
  final String type;
  final ValueChanged<int> onChanged; // 🔥 callback

  const Scroller({
    super.key,
    this.axix = 'vertical',
    required this.value,
    this.type = 'height',
    required this.onChanged,
  });

  @override
  State<Scroller> createState() => _ScrollerState();
}

class _ScrollerState extends State<Scroller> {
  late int currentValue;

  @override
  void initState() {
    super.initState();
    currentValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return ListWheelScrollView.useDelegate(
      itemExtent: height * 0.07,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged: (value) {
        final newValue = widget.type == 'weight'
            ? value + 50
            : widget.type == 'age'
            ? value + 10
            : value + 120;

        setState(() => currentValue = newValue);

        widget.onChanged(newValue);
      },
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: 100,
        builder: (context, index) {
          final displayValue = widget.type == 'weight'
              ? index + 50
              : widget.type == 'age'
              ? index + 10
              : index + 120;

          return Container(
            height: height * 0.05,
            child: Center(
              child: Text(
                displayValue.toString(),
                style: TextStyle(
                  fontSize: width * 0.08,
                  color: displayValue == currentValue
                      ? Colors.white
                      : Colors.grey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
