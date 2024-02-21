import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agendador_bronzeamento/models/user.dart';

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
                        if (searchController.chosen.value) {
                          searchController.chosen.value = false;
                        }
                        if (value.isNotEmpty) {
                          searchController.usersToShow.value = _fetchUsersThatMatch(value);
                        } else {
                          searchController.usersToShow.clear();
                        }
                      },
                      onEditingComplete: searchController.onEditingComplete,
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
    List<User> userstoReturn = <User>[];
    userstoReturn.addAll(
      userController
          .users
          !.toList()
          .where(
            (user) => user.name.toLowerCase().contains(
                  name.toLowerCase(),
                ),
          )
          .take(suggestionCount),
    );
    return userstoReturn;
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
            searchController.usersToShow.clear();
            searchController.focusNode.unfocus();
            searchController.onEditingComplete != null && searchController.onEditingComplete!();
            searchController.chosen.value = true;
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
