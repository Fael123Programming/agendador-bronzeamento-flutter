import 'dart:async';

import 'package:agendador_bronzeamento/navigator/bottom_nav_item.dart';
import 'package:agendador_bronzeamento/navigator/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:move_to_background/move_to_background.dart';

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

  void goToBeds({bool animated = true}) async {
    await goTo(BottomNavItem.beds, animated: animated);
  }

  void goToBronzes({bool animated = true}) async {
    await goTo(BottomNavItem.bronzes, animated: animated);
  }

  void goToDashboard({bool animated = true}) async {
    await goTo(BottomNavItem.dashboard, animated: animated);
  }

  void goToClients({bool animated = true}) async {
    await goTo(BottomNavItem.clients, animated: animated);
  }

  void goToConfig({bool animated = true}) {
    goTo(BottomNavItem.config, animated: animated);
  }

  Future<void> goTo(BottomNavItem item, {bool animated = true}) async {
    clean(item);
    selectedItem.value = item;
    if (animated) {
      await pageViewController.animateToPage(
      item.index, 
      duration: const Duration(milliseconds: 100), 
      curve: Curves.easeIn
      );
    } else {
      pageViewController.jumpToPage(item.index);
    }
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
    return Obx(() {
      return PopScope(
      onPopInvoked: (didPop) async {
        if (Get.isOverlaysClosed) {
          Get.dialog(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(73, 255, 255, 255),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Material(
                        color: Color.fromARGB(0, 255, 255, 255),
                        child: Column(
                          children: [
                            Text(
                              'Novamente para minimizar',
                              style: TextStyle(
                                fontSize: 20, 
                                fontWeight: FontWeight.bold
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            transitionDuration: const Duration(milliseconds: 100),
            transitionCurve: Curves.easeInOut
          );
          Timer(const Duration(seconds: 1), () async {
            if (Get.isOverlaysOpen) {
              Get.back();
            } else {
              await MoveToBackground.moveTaskToBack();
            }
          });
        }
      },
      child: Scaffold(
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
            onPageChanged: (index) async {
              await homeController.goTo(BottomNavItem.values[index]);
            },
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).primaryColorLight,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          currentIndex: BottomNavItem.values.indexOf(homeController.selectedItem.value),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          onTap: (index) async {
            await homeController.goTo(BottomNavItem.values[index], animated: false);
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
                      color: item == homeController.selectedItem.value ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
              )
              .values
              .toList(),
          ),
        ),
      );
    });
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
