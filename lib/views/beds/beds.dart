import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/turn_around_blocks.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/bed_card_list_controller.dart';

class Beds extends StatelessWidget {
  final BedCardListController bedCardListController = Get.put(BedCardListController());

  Beds({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Macas'),
      ),
      body: Obx(() => ListView.builder(
        itemCount: bedCardListController.bedCards.length,
        itemBuilder: (context, index) {
          final card = bedCardListController.bedCards[index];
          if (card.dismissed.value) {
            return Container();
          }
          card.controller.startTimer();
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
              bedCardListController.dismissCard(index);
              // bedCardListController.removeCard(index);
              // bedCards.remove(bedCards.where((element) => element.bedNumber == bedCards[index].bedNumber).first);
            },
            key: ValueKey<String>(card.clientName),
            child: GestureDetector(
              onTap: () {
                if (card.controller.stopped.value) {
                  if (card.controller.paintedCircles.value == card.controller.totalCircles) {
                    bedCardListController.dismissCard(index);
                  } else {
                    card.controller.startTimer();
                  }
                } 
                //else {
                  // bedCardListController.dismissCard(index);
                  // bedCardListController.removeCard(index);
                  // bedCards.remove(bedCards.where((element) => element.bedNumber == bedCards[index].bedNumber).first);
                // }
              },
              child: Obx(() => Container(
                decoration: BoxDecoration(
                  color: Colors.pink[50],
                  border: Border.all(color: card.controller.color.value),
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
                          card.clientName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '#${card.bedNumber}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TurnAroundBlocks(
                          totalBlocks: card.controller.totalCircles,
                          paintedBlocks: card.controller.paintedCircles.value,
                        ),
                        card.controller.stopped.value ? 
                          Icon(card.controller.paintedCircles.value == card.controller.totalCircles ? Icons.done_all : Icons.double_arrow, color: card.controller.paintedCircles.value == card.controller.totalCircles ? Colors.green : Colors.black,)
                          : Text(card.controller.remainingTime.value.toString().split('.')[0])
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
        },
      ),),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, RoutePaths.bedDetails),
        foregroundColor: Colors.white,
        backgroundColor: Colors.pink,
        heroTag: 'Add new bed',
        child: const Icon(Icons.add),
      ),
    );
  }
}
