import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:agendador_bronzeamento/models/user.dart';
import 'package:agendador_bronzeamento/utils/loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> sendMessage(String clientName, String phoneNumber) async {
  int hour = DateTime.now().hour;
  String hourTxt;
  if (hour < 12) {
    hourTxt = 'Bom dia';
  } else if (hour < 18) {
    hourTxt = 'Boa tarde';
  } else {
    hourTxt = 'Boa noite';
  }
  const toReplace = '()+/';
  String localPhone = phoneNumber;
  for (final c in toReplace.characters) {
    if (localPhone.contains(c)) {
      localPhone = localPhone.replaceFirst(c, '');
    }
  }
  final message = 'Olá, $clientName! $hourTxt!';
  final url = 'https://wa.me/$localPhone/?text=${Uri.encodeFull(message)}';
  await launchUrl(Uri.parse(url));
}

class Clients extends StatelessWidget {
  const Clients({super.key});

  @override
  Widget build(context) {
    final UserController userController = Get.find();
    return PopScope(
        onPopInvoked:(didPop) {
        },
        child: Obx(() {
          if (userController.loaded.value) {
            return Scaffold(
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
                        Icons.person_2_outlined, 
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
                    itemCount: userController.users!.length,
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
                      trailing: CircleAvatar(
                        backgroundColor: Colors.green,
                        child: IconButton(
                          alignment: Alignment.center,
                          icon: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white,),
                          onPressed: () async => sendMessage(userController.users![index].name.split(' ')[0], userController.users![index].phoneNumber),
                        ),
                      ),
                      leading: userController.users![index].profileImage != null ? 
                        FittedBox(
                          fit: BoxFit.cover,
                          child: CircleAvatar(
                            backgroundImage: Image.memory(userController.users![index].profileImage!).image,
                            radius: 20,
                          ),
                        ) : const Icon(Icons.person_2)
                      ),
                    ),
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
