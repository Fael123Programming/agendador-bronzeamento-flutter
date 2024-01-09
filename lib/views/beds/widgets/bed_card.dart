import 'package:agendador_bronzeamento/views/beds/widgets/turn_around_blocks/turn_around_blocks.dart';
import 'package:flutter/material.dart';

class BedCard extends StatefulWidget {
  final String clientName;
  final int bedNumber;
  final void Function() onFinished;

  const BedCard({
    super.key,
    required this.clientName,
    required this.bedNumber,
    required this.onFinished,
  });

  @override
  State<BedCard> createState() => _BedCardState();
}

class _BedCardState extends State<BedCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.pink[50],
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
                "#${widget.bedNumber}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          TurnAroundBlocks(
            blocks: 4,
            durationPerBlock: Duration(seconds: 10),
            onFinished: widget.onFinished,
          )
        ],
      ),
    );
  }
}
