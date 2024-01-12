import 'package:agendador_bronzeamento/views/beds/widgets/turn_around_blocks/turn_around_blocks.dart';
import 'package:flutter/material.dart';

class BedCard extends StatefulWidget {
  final String clientName;
  final int bedNumber;
  final void Function() onAllBlocksFinished;

  const BedCard({
    super.key,
    required this.clientName,
    required this.bedNumber,
    required this.onAllBlocksFinished,
  });

  @override
  State<BedCard> createState() => _BedCardState();
}

class _BedCardState extends State<BedCard> {
  Color borderColor = Colors.white;
  TurnAroundBlocksController turnController = TurnAroundBlocksController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
          color: Colors.red,
        ),
        alignment: AlignmentDirectional.center,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      onDismissed: (direction) {
        widget.onAllBlocksFinished();
        dispose();
      },
      key: ValueKey<String>(widget.clientName),
      child: GestureDetector(
        onTap: turnController.verify,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.pink[50],
            border: Border.all(color: borderColor),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.clientName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '#${widget.bedNumber}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              TurnAroundBlocks(
                blocks: 4,
                durationPerBlock: Duration(seconds: 1),
                onAllBlocksFinished: widget.onAllBlocksFinished,
                onBlockFinished: switchBorderColor,
                controller: turnController,
              )
            ],
          ),
        ),
      ),
    );
  }

  void switchBorderColor() {
    setState(() =>
        borderColor = borderColor == Colors.white ? Colors.pink : Colors.white);
  }
}
