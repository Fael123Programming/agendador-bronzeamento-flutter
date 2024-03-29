import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:agendador_bronzeamento/database/models/client.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:agendador_bronzeamento/utils/sender.dart';
import 'package:agendador_bronzeamento/utils/validator.dart';

class Clients extends StatelessWidget {
  const Clients({super.key});

  @override
  Widget build(context) {
    final ClientController clientController = Get.find();
    double width = MediaQuery.of(context).size.width;
    return PopScope(
      onPopInvoked: (didPop) {},
      child: Obx(() => Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const Text(
                'Clientes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'DancingScript'
                ),
              ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: width * .05),
                            child: Row(
                              children: [
                                const Icon(Icons.supervised_user_circle_outlined),
                                Obx(() => Container(
                                  margin: EdgeInsets.only(left: width * .02),
                                  child: Text(
                                      clientController.clients.length.toString(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                )
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(right: width * .02),
                            child: Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: IconButton(
                                    color: Colors.pink,
                                    icon: Icon(
                                      clientController.order.value == Order.increasing ?
                                        Icons.arrow_upward :
                                        Icons.arrow_downward
                                      ),
                                    onPressed: () async {
                                      if (clientController.order.value == Order.increasing) {
                                        clientController.order.value = Order.decreasing;
                                      } else {
                                        clientController.order.value = Order.increasing;
                                      }
                                      clientController.sort();
                                    }, 
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: IconButton(
                                    color: Colors.pink,
                                    icon: Icon(
                                      clientController.sortingMethod.value == SortingMethod.name ?
                                        Icons.abc : 
                                        clientController.sortingMethod.value == SortingMethod.since ? 
                                        Icons.date_range :
                                        Icons.sunny
                                      ),
                                    onPressed: () async {
                                      SortingMethod sortingMethod;
                                      if (clientController.sortingMethod.value == SortingMethod.name) {
                                        sortingMethod = SortingMethod.since;
                                      } else if (clientController.sortingMethod.value == SortingMethod.since) {
                                        sortingMethod = SortingMethod.bronzes;
                                      } else {
                                        sortingMethod = SortingMethod.name;
                                      }
                                      clientController.sortingMethod.value = sortingMethod;
                                      clientController.sort();
                                    }, 
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                            padding: const EdgeInsets.only(bottom: 60),
                              itemCount: clientController.clients.length,
                              itemBuilder: (context, index) {
                                Widget? subtitle;
                                const style = TextStyle(fontWeight: FontWeight.bold);
                                if (clientController.sortingMethod.value ==
                                    SortingMethod.since) {
                                  subtitle = Obx(() => Text(
                                      Validator.formatDatetime(clientController.clients[index].since), 
                                      style: style,
                                    )
                                  );
                                } else if (clientController.sortingMethod.value ==
                                    SortingMethod.bronzes) {
                                  subtitle = Obx(() => Text(clientController.clients[index].bronzes.value.toString(), style: style));
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
                                          Obx(() => clientController.clients[index].bronzes.value > 0 ? CircleAvatar(
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
                                          ) : Container()),
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
                                              : const FittedBox(
                                                  fit: BoxFit.cover,
                                                  child: CircleAvatar(
                                                    backgroundColor: Colors.white,
                                                    radius: 20,
                                                    child: Icon(Icons.person_2),
                                                  ),
                                                ) 
                                               ),
                                );
                              }
                        ),
                      ),
                    ],
                  ),
            ),
          )
      ),
    );
  }
}
