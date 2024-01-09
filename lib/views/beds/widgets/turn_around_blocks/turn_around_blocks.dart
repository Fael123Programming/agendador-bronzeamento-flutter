import 'dart:async';

import 'package:agendador_bronzeamento/views/beds/widgets/turn_around_blocks/block.dart';
import 'package:flutter/material.dart';

class TurnAroundBlocks extends StatefulWidget {
  final int blocks;
  final Duration durationPerBlock;
  final void Function() onFinished;

  const TurnAroundBlocks({
    super.key,
    required this.blocks,
    required this.durationPerBlock,
    required this.onFinished,
  });

  @override
  State<TurnAroundBlocks> createState() => _TurnAroundBlocksState();
}

class _TurnAroundBlocksState extends State<TurnAroundBlocks> {
  final _second = const Duration(seconds: 1);
  final List<Map> _blocks = [];
  int _finishedBlocks = 0;
  late Duration _tempDuration;
  bool _currentFinished = false;

  @override
  void initState() {
    super.initState();
    _tempDuration = widget.durationPerBlock;
    for (int i = 0; i < widget.blocks; i++) {
      final controller = BlockController();
      _blocks.add({
        'controller': controller,
        'block': Block(
          controller: controller,
        )
      });
    }
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: _getBlocks(_blocks),
        ),
        _createHandle(),
      ],
    );
  }

  Widget _createHandle() {
    Widget toReturn;
    if (_currentFinished) {
      if (_finishedBlocks == widget.blocks) {
        toReturn = GestureDetector(
          onTap: widget.onFinished,
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            padding: const EdgeInsets.all(5),
            child: const Icon(
              Icons.done_all,
              size: 22,
              color: Colors.green,
            ),
          ),
        );
      } else {
        toReturn = GestureDetector(
          onTap: () {
            setState(() {
              _currentFinished = false;
              _tempDuration = widget.durationPerBlock;
              _startCountdown();
            });
          },
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            padding: const EdgeInsets.all(5),
            child: const Icon(
              Icons.double_arrow,
              size: 22,
              color: Colors.pink,
            ),
          ),
        );
      }
    } else {
      toReturn = Container(
        padding: const EdgeInsets.all(5),
        child: Text(
          _tempDuration.toString().split('.')[0],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    return toReturn;
  }

  void _startCountdown() {
    Timer.periodic(_second, (timer) {
      if (_tempDuration.inSeconds > 1) {
        setState(() => _tempDuration -= _second);
      } else {
        timer.cancel();
        (_blocks[_finishedBlocks++]['controller'] as BlockController)
            .switchColor();
        setState(() => _currentFinished = true);
      }
    });
  }

  List<Block> _getBlocks(List<Map> blocks) {
    List<Block> toReturn = [];
    for (int i = 0; i < blocks.length; i++) {
      toReturn.add(blocks[i]['block']);
    }
    return toReturn;
  }
}
