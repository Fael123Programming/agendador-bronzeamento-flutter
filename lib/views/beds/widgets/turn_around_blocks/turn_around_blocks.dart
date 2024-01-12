import 'dart:async';

import 'package:agendador_bronzeamento/views/beds/widgets/turn_around_blocks/block.dart';
import 'package:flutter/material.dart';

enum TurnState {
  ready,
  ongoing,
  end;
}

class TurnAroundBlocksController {
  late void Function() onTapEventReady;
  late void Function() onTapEventEnd;
  late TurnState state;

  void verify() {
    switch (state) {
      case TurnState.ready:
        onTapEventReady();
        break;
      case TurnState.end:
        onTapEventEnd();
      default:
        break;
    }
  }
}

class TurnAroundBlocks extends StatefulWidget {
  final int blocks;
  final Duration durationPerBlock;
  final void Function() onAllBlocksFinished;
  final void Function() onBlockFinished;
  final TurnAroundBlocksController controller;

  const TurnAroundBlocks({
    super.key,
    required this.blocks,
    required this.durationPerBlock,
    required this.onAllBlocksFinished,
    required this.onBlockFinished,
    required this.controller,
  });

  @override
  // ignore: no_logic_in_create_state
  State<TurnAroundBlocks> createState() => _TurnAroundBlocksState(controller);
}

class _TurnAroundBlocksState extends State<TurnAroundBlocks> {
  late TurnAroundBlocksController stateController;

  _TurnAroundBlocksState(TurnAroundBlocksController controller) {
    controller.onTapEventReady = onTapEventReady;
    controller.onTapEventEnd = onTapEventEnd;
    controller.state = TurnState.ongoing;
    stateController = controller;
  }

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
        stateController.state = TurnState.end;
        // setState(() => stateController.state = TurnState.end);
        toReturn = Container(
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
        );
      } else {
        stateController.state = TurnState.ready;
        // setState(() => stateController.state = TurnState.ready);
        toReturn = Container(
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
        );
      }
    } else {
      stateController.state = TurnState.ongoing;
      // setState(() => stateController.state = TurnState.ongoing);
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
        widget.onBlockFinished();
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

  void onTapEventReady() {
    widget.onBlockFinished();
    setState(() {
      _currentFinished = false;
      _tempDuration = widget.durationPerBlock;
      _startCountdown();
    });
  }

  void onTapEventEnd() {
    widget.onAllBlocksFinished();
  }
}
