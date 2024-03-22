import 'package:agendador_bronzeamento/views/beds/screens/bed_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agendador_bronzeamento/database/models/client.dart';

const suggestionCount = 1;

class SearchClientInputController extends GetxController {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  Function()? onEditingComplete;
  RxList<Client> clientsToShow = <Client>[].obs;
  RxBool chosen = false.obs;
}

class SearchClientInput extends StatelessWidget {
  const SearchClientInput({super.key});
  
  @override
  Widget build(context) {
    final BedDetailsController bedController = Get.find();
    final ClientController clientController = Get.find();
    final SearchClientInputController searchController = Get.find();
    searchController.focusNode.requestFocus();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Obx(() => Column(
      children: [
        Center(
          child: Container(
            width: width * 0.8,
            height: height * 0.07,
            padding: EdgeInsets.all(width * 0.03),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            child: Center(
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: width * 0.04,
                  ),
                  Expanded(
                    child: TextFormField(
                      onChanged: (value) {
                        String? realName = clientController.getRealName(clientController.getIdle(), value);
                        if (realName != null) {
                          searchController.controller.text = realName;
                          searchController.clientsToShow.clear();
                          searchController.chosen.value = true;
                          searchController.focusNode.unfocus();
                          searchController.onEditingComplete != null && searchController.onEditingComplete!();
                        } else if (value.isNotEmpty) {
                          searchController.clientsToShow.value = _fetchClientsThatMatch(value);
                          searchController.chosen.value = false;
                        } else {
                          searchController.clientsToShow.clear();
                          searchController.chosen.value = false;
                        }
                        bedController.checkValues();
                      },
                      // onEditingComplete: searchController.onEditingComplete,
                      focusNode: searchController.focusNode,
                      controller: searchController.controller,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Cliente',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        searchController.clientsToShow.isEmpty 
        ? SizedBox(height: height * 0.08) 
        : Container(
          margin: EdgeInsets.only(bottom: height * 0.01),
          child: Column(
            children: _drawClientCards(searchController.clientsToShow, context),
          ),
        )
        ,
    ],
    ));
  }

  List<Client> _fetchClientsThatMatch(String name) {
    final ClientController clientController = Get.find();
    List<Client> fetchedClients = clientController
      .getIdle()
      .where(
        (client) => client.name.toLowerCase().contains(
          name.toLowerCase()
        )
      ).take(suggestionCount).toList();
    return fetchedClients;
  }

  List<Widget> _drawClientCards(List<Client> clients, BuildContext context) {
    final SearchClientInputController searchController = Get.find();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    List<Widget> clientCards = clients.map(
        (client) => GestureDetector(
          onTap: () {
            searchController.controller.text = client.name;
            searchController.chosen.value = true;
            searchController.clientsToShow.clear();
            searchController.focusNode.unfocus();
            if (searchController.onEditingComplete != null) {
              searchController.onEditingComplete!();
            }
          },
          child: Center(
            child: Container(
              width: width * 0.8,
              height: height * 0.07,
              padding: EdgeInsets.all(width * 0.03),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: Center(
                child: Row(
                  children: [
                    client.picture == null ?
                    const Icon(
                      Icons.person_2,
                      color: Colors.grey,
                    ) : FittedBox(
                          fit: BoxFit.cover,
                          child: CircleAvatar(
                            backgroundImage: Image.memory(client.picture!).image,
                            radius: 20,
                          ),
                        ),
                    SizedBox(
                      width: width * 0.04,
                    ),
                    Expanded(
                      child: Text(
                        client.name,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ).toList();
    return clientCards;
  }
}
