import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agendador_bronzeamento/models/user.dart';

const suggestionCount = 1;

class SearchClientInputController extends GetxController {
  final TextEditingController controller = TextEditingController();
  RxList<User> usersToShow = <User>[].obs;
}

class SearchClientInput extends StatelessWidget {
  final FocusNode? focusNode;
  final Function()? onEditingComplete;

  const SearchClientInput({
    Key? key,
    this.focusNode,
    this.onEditingComplete,
  }) : super(key: key);
  
  @override
  Widget build(context) {
    final SearchClientInputController searchController = Get.find();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    focusNode?.requestFocus();

    return Column(
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
                        if (value.isNotEmpty) {
                          searchController.usersToShow = _fetchUsersThatMatch(value).obs;
                        } else {
                          searchController.usersToShow = <User>[].obs;
                        }
                      },
                      onEditingComplete: onEditingComplete,
                      focusNode: focusNode,
                      controller: searchController.controller,
                      // autofocus: true,
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
        Obx(() => Column(
          children: _drawUsersCards(searchController.usersToShow.toList(), context),
        ))
      ],
    );
  }

  List<User> _fetchUsersThatMatch(String name) {
    final UserController userController = Get.find();
    List<User> userstoReturn = [];
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
            searchController.usersToShow = <User>[].obs;
            FocusScope.of(context).unfocus();
            onEditingComplete != null && onEditingComplete!();
          },
          child: Center(
            child: Container(
              width: width * 0.8,
              height: height * 0.07,
              padding: EdgeInsets.all(width * 0.03),
              // margin: EdgeInsets.all(5),
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
                    const Icon(
                      Icons.person_2,
                      color: Colors.grey,
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
