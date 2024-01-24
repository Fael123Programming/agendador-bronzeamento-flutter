import 'package:flutter/material.dart';

class TurnAroundBlocks extends StatelessWidget {
  final int totalBlocks;
  final int paintedBlocks;

  const TurnAroundBlocks({super.key, required this.totalBlocks, required this.paintedBlocks});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _drawBlocks(),
    );
  }

  List<Widget> _drawBlocks() {
    List<Widget> widgets = [];
    Widget container = Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      child: const Icon(
        Icons.circle,
        size: 24,
        color: Color.fromARGB(255, 248, 187, 208),
      ),
    );
    Widget marked = Container(
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      child: const Icon(
        Icons.check_circle,
        size: 24,
        color: Colors.pink,
      ),
    );
    for (int i = 0; i < totalBlocks; i++) {
      if (i < paintedBlocks) {
        widgets.add(marked);
      } else {
        widgets.add(container);
      }
    }
    return widgets;
  }
}
