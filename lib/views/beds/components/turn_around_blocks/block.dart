import 'package:flutter/material.dart';

class BlockController {
  late void Function() switchColor;
}

class Block extends StatefulWidget {
  final BlockController controller;

  const Block({super.key, required this.controller});

  @override
  // ignore: no_logic_in_create_state
  State<Block> createState() => _BlockState(controller);
}

class _BlockState extends State<Block> {
  _BlockState(BlockController controller) {
    controller.switchColor = switchColor;
  }

  Color? color = Colors.pink[100];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 15,
      height: 15,
      margin: const EdgeInsets.all(5),
      color: color,
    );
  }

  void switchColor() {
    setState(() => color = Colors.pink);
  }
}
