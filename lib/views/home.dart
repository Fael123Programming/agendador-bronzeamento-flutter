import 'package:agendador_bronzeamento/navigator/bottom_nav_item.dart';
import 'package:agendador_bronzeamento/navigator/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final pageViewController = PageController();
  final Rx<BottomNavItem> selectedItem = BottomNavItem.beds.obs;

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

  void goToBronzes() {
    goTo(BottomNavItem.bronzes);
  }

  void goToDashboard() {
    goTo(BottomNavItem.dashboard);
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
    BottomNavItem.bronzes: GlobalKey<NavigatorState>(),
    BottomNavItem.dashboard: GlobalKey<NavigatorState>(),
    BottomNavItem.clients: GlobalKey<NavigatorState>(),
    BottomNavItem.config: GlobalKey<NavigatorState>(),
  };

  final Map<BottomNavItem, Map<String, dynamic>> items = {
    BottomNavItem.beds: {
      'iconFocused': Icons.hotel,
      'icon': Icons.hotel_outlined,
      'bottomNavItemLabel': 'Macas',
    },
    BottomNavItem.bronzes: {
      'iconFocused': Icons.wb_sunny,
      'icon': Icons.wb_sunny_outlined,
      'bottomNavItemLabel': 'Bronzes',
    },
    BottomNavItem.dashboard: {
      'iconFocused': Icons.query_stats,
      'icon': Icons.query_stats_outlined,
      'bottomNavItemLabel': 'Dashboard',
    },
    BottomNavItem.clients: {
      'iconFocused': Icons.person_2,
      'icon': Icons.person_2_outlined,
      'bottomNavItemLabel': 'Clientes'
    },
    BottomNavItem.config: {
      'iconFocused': Icons.settings,
      'icon': Icons.settings_outlined,
      'bottomNavItemLabel': 'Ajustes'
    },
  };
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    return Obx(() => Scaffold(
      // appBar: AppBar(
      //   title: const Text(''),
      // ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (pop) async {
          homeController.navigatorKeys[homeController.selectedItem.value]
              ?.currentState
              ?.popUntil((route) => route.isFirst);
        },
      //   child: Stack(
          // children: homeController.items
          //     .map(
          //       (item, _) => MapEntry(
          //         item,
          //         _buildOffstageNavigator(item, item == homeController.selectedItem.value),
          //       ),
          //     )
          //     .values
          //     .toList(),
      //   ),
      // ),
        child: PageView(
          controller: homeController.pageViewController,
          children: homeController.items
              .map(
                (item, _) => MapEntry(
                  item,
                  _buildOffstageNavigator(item, item == homeController.selectedItem.value),
                ),
              )
              .values
              .toList(),
          onPageChanged: (index) {
            final currentSelectedItem = BottomNavItem.values[index];
            homeController.clean(currentSelectedItem);
            homeController.goTo(currentSelectedItem);
          },
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
          homeController.pageViewController.jumpToPage(index);
          // final currentSelectedItem = BottomNavItem.values[index];
          // homeController.clean(currentSelectedItem);
          // homeController.goTo(currentSelectedItem);
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
