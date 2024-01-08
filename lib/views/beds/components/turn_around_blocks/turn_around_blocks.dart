import 'dart:async';

import 'package:agendador_bronzeamento/views/beds/components/turn_around_blocks/block.dart';
import 'package:flutter/material.dart';

class TurnAroundBlocks extends StatefulWidget {
  final int blocks;
  final Duration durationPerBlock;
  final void Function() onFinished;

  const TurnAroundBlocks(
      {super.key,
      required this.blocks,
      required this.durationPerBlock,
      required this.onFinished});

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
              color: Colors.pink,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            padding: const EdgeInsets.all(5),
            child: const Text(
              'Terminar',
              style: TextStyle(
                color: Colors.white,
              ),
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
              color: Colors.green,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            padding: const EdgeInsets.all(5),
            child: const Text(
              'Próxima',
              style: TextStyle(
                color: Colors.white,
              ),
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
        setState(() => _currentFinished = true);
        (_blocks[_finishedBlocks++]['controller'] as BlockController)
            .switchColor();
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
