import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agendador_bronzeamento/database/models/client.dart';

const suggestionCount = 1;

class SearchClientInputController extends GetxController {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  Function()? onEditingComplete;
  RxList<User> usersToShow = <User>[].obs;
  RxBool chosen = false.obs;
}

class SearchClientInput extends StatelessWidget {
  const SearchClientInput({super.key});
  
  @override
  Widget build(context) {
    final UserController userController = Get.find();
    final SearchClientInputController searchController = Get.find();
    searchController.focusNode.requestFocus();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                        String? realName = userController.getRealName(userController.getIdleUsers(), value);
                        if (realName != null) {
                          searchController.controller.text = realName;
                          searchController.usersToShow.clear();
                          searchController.chosen.value = true;
                          searchController.focusNode.unfocus();
                          searchController.onEditingComplete != null && searchController.onEditingComplete!();
                        } else if (value.isNotEmpty) {
                          searchController.usersToShow.value = _fetchUsersThatMatch(value);
                          searchController.chosen.value = false;
                        } else {
                          searchController.usersToShow.clear();
                          searchController.chosen.value = false;
                        }
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
        Column(
          children: _drawUsersCards(searchController.usersToShow.toList(), context),
        )
      ],
    ));
  }

  List<User> _fetchUsersThatMatch(String name) {
    final UserController userController = Get.find();
    List<User> usersToReturn = <User>[];
    usersToReturn.addAll(
      userController
          .getIdleUsers()
          .where(
            (user) => user.name.toLowerCase().contains(
                  name.toLowerCase()
                )
          )
          .take(suggestionCount),
    );
    return usersToReturn;
  }

  List<Widget> _drawUsersCards(List<User> users, BuildContext context) {
    final SearchClientInputController searchController = Get.find();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<Widget> userCards = [];
    userCards.addAll(
      users.map(
        (user) => GestureDetector(
          onTap: () {
            searchController.controller.text = user.name;
            searchController.chosen.value = true;
            searchController.usersToShow.clear();
            searchController.focusNode.unfocus();
            searchController.onEditingComplete != null && searchController.onEditingComplete!();
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
                    user.profileImage == null ?
                    const Icon(
                      Icons.person_2,
                      color: Colors.grey,
                    ) : FittedBox(
                          fit: BoxFit.cover,
                          child: CircleAvatar(
                            backgroundImage: Image.memory(user.profileImage!).image,
                            radius: 20,
                          ),
                        ),
                    SizedBox(
                      width: width * 0.04,
                    ),
                    Expanded(
                      child: Text(
                        user.name,
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    return userCards;
  }
}
