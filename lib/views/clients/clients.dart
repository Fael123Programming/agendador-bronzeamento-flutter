import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:agendador_bronzeamento/models/user.dart';
import 'package:agendador_bronzeamento/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:get/get.dart';

class Clients extends StatelessWidget {
  const Clients({super.key});

  @override
  Widget build(context) {
    final UserController userController = Get.find();

    return PopScope(
        onPopInvoked:(didPop) {
        },
        child: Obx(() =>
      userController.loaded.value ? Scaffold(
        appBar: AppBar(
          title: const Text(
            'Clientes',
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () => Navigator.pushNamed(context, RoutePaths.searchClient),
              icon: const Icon(Icons.search),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              Navigator.pushNamed(context, RoutePaths.clientDetails),
          foregroundColor: Colors.white,
          backgroundColor: Colors.pink,
          child: const Icon(Icons.add),
        ),
          body: Obx(() => userController.users!.toList().isEmpty ? 
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  Icon(
                    Icons.person_outlined, 
                    size: 80, 
                    color: Colors.pink
                  ), 
                  Text(
                    'Sem clientes', 
                    style: TextStyle(
                      fontSize: 30, 
                      color: Colors.pink
                    ),
                  )
                ]
              )
            ) : ListView.builder(
                itemBuilder: (context, index) => Container(
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
                    arguments: userController.users![index],
                  ),
                  title: Text(userController.users![index].name),
                  // leading: const Icon(Icons.person_2),
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage("assets/girl.jpg"),
                    // backgroundColor: Colors.pink[50],
                  ),
                ),
              ),
            ),
          ),
        )
    : const Loading(),
    ),
    );
  }
}
