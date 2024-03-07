import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:agendador_bronzeamento/database/models/client.dart';
import 'package:agendador_bronzeamento/utils/sender.dart';

class SearchClient extends StatelessWidget {
  const SearchClient({super.key});

  @override
  Widget build(context) {
    final UserController userController = Get.find();
    RxList<User> filtered = <User>[].obs;
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
                filtered.clear();
                if (s.isNotEmpty) {
                  filtered.addAll(
                    userController.users.where(
                      (user) => user.name.toString().toLowerCase().contains(
                            s.toLowerCase(),
                          ),
                    ),
                  );
                }
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
      body: Obx(() =>
        filtered.isEmpty ? Container() : 
        ListView.builder(
          itemCount: filtered.length,
          itemBuilder: (context, index) => Container(
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
                arguments: filtered[index],
              ),
              title: Text(filtered[index].name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  filtered[index].bronzes > 0 ? CircleAvatar(
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
                        arguments: userController.users[index],
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
                          filtered[index].name
                              .split(' ')[0],
                          filtered[index].phoneNumber),
                    ),
                  )
                ],
              ),
              leading:
              filtered[index].profileImage !=
                  null
                  ? FittedBox(
                fit: BoxFit.cover,
                child: CircleAvatar(
                  backgroundImage: Image.memory(
                      filtered[index]
                          .profileImage!)
                      .image,
                  radius: 20,
                ),
              )
                  : const Icon(Icons.person_2)),
        )
        )
      )
    );
  }
}