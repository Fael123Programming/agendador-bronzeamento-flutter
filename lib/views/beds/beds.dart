import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agendador_bronzeamento/database/models/client.dart';
import 'package:agendador_bronzeamento/views/clients/screens/client_details.dart';
import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:agendador_bronzeamento/views/home.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/bed_card.dart';

class Beds extends StatelessWidget {
  const Beds({super.key});
  
  @override
  Widget build(BuildContext context) {
    final BedCardListController bedCardListController = Get.find();
    final HomeController homeController = Get.find();
    final ClientController clientController = Get.find();
    return Obx(() => Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Macas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'DancingScript'
          ),
        ),
        actions: bedCardListController.list.isNotEmpty ? <Widget>[
          IconButton(
            onPressed: () =>
                Navigator.pushNamed(context, RoutePaths.searchBed),
            icon: const Icon(Icons.search),
          )
        ] : null,
      ),
      body: bedCardListController.list.isEmpty ? 
          Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  const Icon(
                    Icons.hotel_outlined, 
                    size: 80, 
                    color: Colors.pink
                  ), 
                  const Text(
                    'Sem macas', 
                    style: TextStyle(
                      fontSize: 30, 
                      color: Colors.pink
                    ),
                  ),
                  clientController.clients.isEmpty ? 
                  Container(
                    margin: const EdgeInsets.only(top: 50),
                    child: TextButton(
                      child: const Text(
                        'Comece adicionando uma nova cliente!',
                        style: TextStyle(
                          fontSize: 30, 
                          color: Colors.black, 
                          decoration: TextDecoration.underline,
                          fontFamily: 'DancingScript',
                          fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () {
                        homeController.goToClients();
                        Get.to(
                          const ClientDetails(), 
                          curve: Curves.easeInOut,
                          duration: const Duration(seconds: 1),
                          opaque: true
                        );
                      },
                    ),
                  ) : Container()
                ]
              )
            )
        : ListView(
          padding: const EdgeInsets.only(bottom: 50),
          children: bedCardListController.list
        ),
      floatingActionButton: clientController.clients.isNotEmpty ? FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, RoutePaths.bedDetails),
        foregroundColor: Colors.white,
        backgroundColor: Colors.pink,
        heroTag: 'Adicionar maca',
        tooltip: 'Adicionar maca',
        child: const Icon(Icons.add),
      ) : null,
    ));
  }
}
