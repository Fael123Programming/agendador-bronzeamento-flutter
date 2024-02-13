import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/bed_card_list_controller.dart';

class Beds extends StatelessWidget {
  Beds({super.key});
  

  @override
  Widget build(BuildContext context) {
    final BedCardListController bedCardListController = Get.put(BedCardListController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Macas'),
      ),
      body: Obx(() {
        if (bedCardListController.bedCards.isEmpty) {
          return const Center(child: Text('Sem Macas', style: TextStyle(fontSize: 30),));
        } else {
          // bedCardListController.processItemsToRemove();
          return ListView(children: bedCardListController.bedCards);
        }
      }),
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
