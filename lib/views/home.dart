import 'package:agendador_bronzeamento/navigator/bottom_nav_item.dart';
import 'package:agendador_bronzeamento/navigator/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  Rx<BottomNavItem> selectedItem = BottomNavItem.beds.obs;

  void clean(BottomNavItem item) {
    if (selectedItem.value == item) {
      navigatorKeys[selectedItem.value]
          ?.currentState
          ?.popUntil((route) => route.isFirst);
    }
  }

  void goToBeds() {
    goTo(BottomNavItem.beds);
  }

  void goToClients() {
    goTo(BottomNavItem.clients);
  }

  void goToConfig() {
    goTo(BottomNavItem.config);
  }

  void goTo(BottomNavItem item) {
    clean(item);
    selectedItem.value = item;
  }

  final Map<BottomNavItem, GlobalKey<NavigatorState>> navigatorKeys = {
    BottomNavItem.beds: GlobalKey<NavigatorState>(),
    BottomNavItem.clients: GlobalKey<NavigatorState>(),
    BottomNavItem.config: GlobalKey<NavigatorState>(),
  };

  final Map<BottomNavItem, Map<String, dynamic>> items = {
    BottomNavItem.beds: {
      'iconFocused': Icons.sunny,
      'icon': Icons.wb_sunny_outlined,
      'bottomNavItemLabel': 'Macas',
    },
    BottomNavItem.clients: {
      'iconFocused': Icons.person_2,
      'icon': Icons.person_2_outlined,
      'bottomNavItemLabel': 'Clientes'
    },
    BottomNavItem.config: {
      'iconFocused': Icons.settings,
      'icon': Icons.settings_outlined,
      'bottomNavItemLabel': 'Configurações'
    },
  };
}

class Home extends StatelessWidget {
  const Home({super.key});  

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    return Obx(() => Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvoked: (pop) async {
          homeController.navigatorKeys[homeController.selectedItem.value]
              ?.currentState
              ?.popUntil((route) => route.isFirst);
        },
        child: Stack(
          children: homeController.items
              .map(
                (item, _) => MapEntry(
                  item,
                  _buildOffstageNavigator(item, item == homeController.selectedItem.value),
                ),
              )
              .values
              .toList(),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        currentIndex: BottomNavItem.values.indexOf(homeController.selectedItem.value),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (index) {
          final currentSelectedItem = BottomNavItem.values[index];
          homeController.clean(currentSelectedItem);
          homeController.goTo(currentSelectedItem);
        },
        items: homeController.items
            .map(
              (item, itemData) => MapEntry(
                item.toString(),
                BottomNavigationBarItem(
                  label: itemData['bottomNavItemLabel'],
                  icon: Icon(
                    item == homeController.selectedItem.value ? itemData['iconFocused'] : itemData['icon'],
                    size: item == homeController.selectedItem.value ? 35.0 : 30.0,
                    color: item == homeController.selectedItem.value ? Colors.pink : Colors.grey,
                  ),
                ),
              ),
            )
            .values
            .toList(),
      ),
    ));
  }

  Widget _buildOffstageNavigator(BottomNavItem currentItem, bool isSelected) {
    final HomeController homeController = Get.find();
    return Offstage(
      offstage: !isSelected,
      child: TabNavigator(
        navigatorKey: homeController.navigatorKeys[currentItem]!,
        item: currentItem,
      ),
    );
  }
}
