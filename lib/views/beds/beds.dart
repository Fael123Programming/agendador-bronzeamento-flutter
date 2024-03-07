import 'package:flutter/material.dart';

// import 'package:google_fonts/google_fonts.dart';

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
    final UserController userController = Get.find();
    return Obx(() => Scaffold(
      appBar: AppBar(
        title: const Text(''),
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
                  userController.users.isEmpty ? 
                  Container(
                    margin: const EdgeInsets.only(top: 50),
                    child: TextButton(
                      child: const Text(
                        'Comece adicionando um novo cliente!',
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
                        Get.to(const ClientDetails());
                      },
                    ),
                  ) : Container()
                ]
              )
            )
        : ListView(
          padding: const EdgeInsets.only(bottom: 50),
          children: bedCardListController.list.toList()
        ),
      floatingActionButton: userController.users.isNotEmpty ? FloatingActionButton(
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
