import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchClient extends StatelessWidget {
  const SearchClient({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 40,
          width: 290,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 5),
          decoration: const BoxDecoration(
            color: Color.fromARGB(150, 231, 231, 231),
            borderRadius: BorderRadius.all(Radius.circular(30))
          ),
          child: TextField(
            onChanged: (String s) {
              // ClientsToShowController clientsController = Get.find();
              // final UserController userController = Get.find();
              //   clientsController.clients.clear();
              //   clientsController.clients.addAll(
              //     userController.users!.toList().where(
              //       (user) => user.name.toString().toLowerCase().contains(
              //             s.toLowerCase(),
              //           ),
              //     ),
              //   );
            },
            autofocus: true,
            cursorColor: Colors.black,
            style: const TextStyle(
              color: Colors.black,
            ),
            textInputAction: TextInputAction.search,
            textAlign: TextAlign.left,
            textAlignVertical: TextAlignVertical.center,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(10),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: 'Pesquisar cliente',
              hintStyle: TextStyle(
                color: Color.fromARGB(180, 0, 0, 0),
                fontWeight: FontWeight.normal
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Text('Search Client'),
      ),
    );
  }
}