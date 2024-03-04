import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:agendador_bronzeamento/models/config.dart';
import 'package:agendador_bronzeamento/models/user.dart';
import 'package:agendador_bronzeamento/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:agendador_bronzeamento/utils/sender.dart';

class Clients extends StatelessWidget {
  const Clients({super.key});

  @override
  Widget build(context) {
    final ConfigController configController = Get.find();
    final UserController userController = Get.find();
    return PopScope(
      onPopInvoked: (didPop) {},
      child: Obx(() {
        if (userController.loaded.value) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(''),
              actions: userController.users.isNotEmpty ? <Widget>[
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
              () => userController.users.isEmpty
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
                                configController.config.value.increasing ?
                                  Icons.arrow_upward :
                                  Icons.arrow_downward
                                ),
                              onPressed: () async {
                                await configController.updateConfig(increasing: !configController.config.value.increasing);
                                await userController.fetchUsers();
                              }, 
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: IconButton(
                              color: Colors.pink,
                              icon: Icon(
                                configController.config.value.sortBy == 'name' ?
                                  Icons.abc : 
                                  configController.config.value.sortBy == 'timestamp' ? 
                                  Icons.date_range :
                                  Icons.sunny
                                ),
                              onPressed: () async {
                                String newSortingMethod = '';
                                if (configController.config.value.sortBy == 'name') {
                                  newSortingMethod = 'timestamp';
                                } else if (configController.config.value.sortBy == 'timestamp') {
                                  newSortingMethod = 'bronze';
                                } else {
                                  newSortingMethod = 'name';
                                }
                                await configController.updateConfig(sortBy: newSortingMethod);
                                await userController.fetchUsers();
                              }, 
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: userController.users.length,
                            itemBuilder: (context, index) {
                              Text? subtitle;
                              const style = TextStyle(fontWeight: FontWeight.bold);
                              if (configController.config.value.sortBy ==
                                  'timestamp') {
                                DateTime timestamp = userController.users[index].timestamp;
                                subtitle = Text('${timestamp.day.toString().padLeft(2, '0')}/${timestamp.month.toString().padLeft(2, '0')}/${timestamp.year}', style: style);
                              } else if (configController.config.value.sortBy ==
                                  'bronze') {
                                subtitle = Text(userController.users[index].bronzes.toString(), style: style);
                              }
                              return Container(
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
                                          arguments: userController.users[index],
                                        ),
                                    title: Text(userController.users[index].name),
                                    subtitle: subtitle,
                                    trailing: CircleAvatar(
                                      backgroundColor: Colors.green,
                                      child: IconButton(
                                        alignment: Alignment.center,
                                        icon: const FaIcon(
                                          FontAwesomeIcons.whatsapp,
                                          color: Colors.white,
                                        ),
                                        onPressed: () async => sendWppMessage(
                                            userController.users[index].name
                                                .split(' ')[0],
                                            userController.users[index].phoneNumber),
                                      ),
                                    ),
                                    leading:
                                        userController.users[index].profileImage !=
                                                null
                                            ? FittedBox(
                                                fit: BoxFit.cover,
                                                child: CircleAvatar(
                                                  backgroundImage: Image.memory(
                                                          userController.users[index]
                                                              .profileImage!)
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
          );
        } else {
          return const Loading();
        }
      }),
    );
  }
}
