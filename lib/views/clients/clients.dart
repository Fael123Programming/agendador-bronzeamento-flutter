import 'package:agendador_bronzeamento/config/config.dart';
import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:agendador_bronzeamento/database/models/client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:agendador_bronzeamento/utils/sender.dart';

import '../../utils/validator.dart';



class Clients extends StatelessWidget {
  const Clients({super.key});

  @override
  Widget build(context) {
    final ConfigController configController = Get.find();
    final ClientController clientController = Get.find();
    return PopScope(
      onPopInvoked: (didPop) {},
      child: Obx(() => Scaffold(
            appBar: AppBar(
              title: const Text(''),
              actions: clientController.clients.isNotEmpty ? <Widget>[
                IconButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, RoutePaths.searchClient),
                  icon: const Icon(Icons.search),
                )
              ] : null,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () =>
                  Navigator.pushNamed(context, RoutePaths.clientDetails),
              foregroundColor: Colors.white,
              backgroundColor: Colors.pink,
              child: const Icon(Icons.add),
            ),
            body: Obx(
              () => clientController.clients.isEmpty
                  ? const Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          Icon(Icons.person_2_outlined,
                              size: 80, color: Colors.pink),
                          Text(
                            'Sem clientes',
                            style: TextStyle(fontSize: 30, color: Colors.pink),
                          )
                        ]))
                  : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: IconButton(
                              color: Colors.pink,
                              icon: Icon(
                                configController.getIncreasing() ?
                                  Icons.arrow_upward :
                                  Icons.arrow_downward
                                ),
                              onPressed: () async {
                                await configController.setIncreasing(!configController.getIncreasing());
                                await clientController.fetch();
                              }, 
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: IconButton(
                              color: Colors.pink,
                              icon: Icon(
                                configController.getSortBy() == ConfigController.name ?
                                  Icons.abc : 
                                  configController.getSortBy() == ConfigController.timestamp ? 
                                  Icons.date_range :
                                  Icons.sunny
                                ),
                              onPressed: () async {
                                String newSortingMethod = '';
                                if (configController.getSortBy() == ConfigController.name) {
                                  newSortingMethod = ConfigController.timestamp;
                                } else if (configController.getSortBy() == ConfigController.timestamp) {
                                  newSortingMethod = ConfigController.bronze;
                                } else {
                                  newSortingMethod = 'name';
                                }
                                await configController.setSortBy(newSortingMethod);
                                await clientController.fetch();
                              }, 
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: clientController.clients.length,
                            itemBuilder: (context, index) {
                              Text? subtitle;
                              const style = TextStyle(fontWeight: FontWeight.bold);
                              if (configController.getSortBy() ==
                                  ConfigController.timestamp) {
                                DateTime timestamp = clientController.clients[index].since;
                                subtitle = Text(Validator.formatDatetime(timestamp));
                                // subtitle = Text('${timestamp.day.toString().padLeft(2, '0')}/${timestamp.month.toString().padLeft(2, '0')}/${timestamp.year}', style: style);
                              } else if (configController.getSortBy() ==
                                  ConfigController.bronze) {
                                subtitle = Text(clientController.clients[index].bronzes.toString(), style: style);
                              }
                              return Container(
                                height: 80,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.pink[50],
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                                margin: const EdgeInsets.all(10),
                                child: ListTile(
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      RoutePaths.clientDetails,
                                      arguments: clientController.clients[index],
                                    ),
                                    title: Text(clientController.clients[index].name),
                                    subtitle: subtitle,
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        clientController.clients[index].bronzes > 0 ? CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          child: IconButton(
                                            alignment: Alignment.center,
                                            icon: const FaIcon(
                                              FontAwesomeIcons.clockRotateLeft,
                                              color: Colors.white,
                                            ),
                                            onPressed: () => Navigator.pushNamed(
                                              context,
                                              RoutePaths.clientHistory,
                                              arguments: clientController.clients[index],
                                            ),
                                          ),
                                        ) : Container(),
                                        const SizedBox(width: 50),
                                        CircleAvatar(
                                          backgroundColor: Colors.green,
                                          child: IconButton(
                                            alignment: Alignment.center,
                                            icon: const FaIcon(
                                              FontAwesomeIcons.whatsapp,
                                              color: Colors.white,
                                            ),
                                            onPressed: () async => await sendWppMessage(
                                                clientController.clients[index].name
                                                    .split(' ')[0],
                                                clientController.clients[index].phoneNumber),
                                          ),
                                        )
                                      ],
                                    ),
                                    leading:
                                        clientController.clients[index].picture !=
                                                null
                                            ? FittedBox(
                                                fit: BoxFit.cover,
                                                child: CircleAvatar(
                                                  backgroundImage: Image.memory(
                                                          clientController.clients[index]
                                                              .picture!)
                                                      .image,
                                                  radius: 20,
                                                ),
                                              )
                                            : const Icon(Icons.person_2)),
                              );
                            }),
                      ),
                    ],
                  ),
            ),
          )
      ),
    );
  }
}
