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
  IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(30),
        ),
        color: color,
      ),
      padding: const EdgeInsets.all(5),
      margin: const EdgeInsets.all(5),
      child: Icon(
        icon,
        size: 10,
        color: Colors.white,
      ),
    );
  }

  void switchColor() {
    setState(() {
      color = Colors.pink;
      icon = Icons.done;
    });
  }
}
