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
    final RxList<User> clientsToShow = Get.put(<User>[].obs);
    RxBool searchClient = false.obs;
    
    if (userController.loaded.value) {
      return Scaffold(
        appBar: AppBar(
          title: Obx(() => searchClient.value
              ? searchTextField()
              : const Text(
                  'Clientes',
                )),
          actions: searchClient.value
              ? [
                  IconButton(
                    onPressed: () {
                      searchClient = false.obs;
                      clientsToShow.clear();
                    },
                    icon: const Icon(Icons.clear),
                  )
                ]
              : [
                  IconButton(
                    onPressed: () => searchClient = true.obs,
                    icon: const Icon(Icons.search),
                  )
                ],
        ),
        floatingActionButton: searchClient.value
            ? null
            : FloatingActionButton(
                onPressed: () =>
                    Navigator.pushNamed(context, RoutePaths.clientDetails),
                foregroundColor: Colors.white,
                backgroundColor: Colors.pink,
                child: const Icon(Icons.add),
              ),
        body: GroupedListView<User, String>(
          elements: clientsToShow.isEmpty && !searchClient.value
              ? userController.users!.toList()
              : clientsToShow.toList(),
          groupBy: (user) => user.name[0].toString().toUpperCase(),
          groupSeparatorBuilder: (String groupByValue) => Container(
            decoration: BoxDecoration(
              color: Colors.pink,
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: Text(
              groupByValue,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          itemBuilder: (context, User user) => Container(
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
                arguments: user,
              ),
              title: Text(user.name),
              // leading: const Icon(Icons.person_2),
              leading: const CircleAvatar(
                backgroundImage: AssetImage("assets/girl.jpg"),
                // backgroundColor: Colors.pink[50],
              ),
            ),
          ),
          itemComparator: (user1, user2) =>
              user1.name.compareTo(user2.name),
          floatingHeader: true,
          order: GroupedListOrder.ASC,
        ),
      );
    } else {
      return const Loading();
    }
  }

  Widget searchTextField() {
    return TextField(
      onChanged: (String s) {
        RxList<User> clientsToShow = Get.find();
        final UserController userController = Get.find();
          clientsToShow.clear();
          clientsToShow.addAll(
            userController.users!.toList().where(
              (user) => user.name.toString().toLowerCase().contains(
                    s.toLowerCase(),
                  ),
            ),
          );
      },
      autofocus: true,
      cursorColor: Colors.black,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        icon: Image.asset('assets/tanning.png', width: 30, height: 30),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        hintText: 'Pesquisar cliente',
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 20,
        ),
      ),
    );
  }
}
