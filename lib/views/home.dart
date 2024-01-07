import 'package:agendador_bronzeamento/navigator/bottom_nav_item.dart';
import 'package:agendador_bronzeamento/navigator/tab_navigator.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  BottomNavItem selectedItem = BottomNavItem.one;

  final Map<BottomNavItem, GlobalKey<NavigatorState>> navigatorKeys = {
    BottomNavItem.one: GlobalKey<NavigatorState>(),
    BottomNavItem.two: GlobalKey<NavigatorState>(),
    BottomNavItem.three: GlobalKey<NavigatorState>(),
  };

  final Map<BottomNavItem, Map<String, dynamic>> items = const {
    BottomNavItem.one: {
      'icon': Icons.sunny,
      'bottomNavItemLabel': 'Macas',
    },
    BottomNavItem.two: {
      'icon': Icons.supervisor_account,
      'bottomNavItemLabel': 'Clientes'
    },
    BottomNavItem.three: {
      'icon': Icons.settings,
      'bottomNavItemLabel': 'Configurações'
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvoked: (pop) async {
          navigatorKeys[selectedItem]
              ?.currentState
              ?.popUntil((route) => route.isFirst);
        },
        child: Stack(
          children: items
              .map(
                (item, _) => MapEntry(
                  item,
                  _buildOffstageNavigator(item, item == selectedItem),
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
        currentIndex: BottomNavItem.values.indexOf(selectedItem),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (index) {
          final currentSelectedItem = BottomNavItem.values[index];
          if (selectedItem == currentSelectedItem) {
            navigatorKeys[selectedItem]
                ?.currentState
                ?.popUntil((route) => route.isFirst);
          }
          setState(() {
            selectedItem = currentSelectedItem;
          });
        },
        items: items
            .map(
              (item, itemData) => MapEntry(
                item.toString(),
                BottomNavigationBarItem(
                  label: itemData['bottomNavItemLabel'],
                  icon: Icon(
                    itemData['icon'],
                    size: 30.0,
                    color: item == selectedItem ? Colors.pink : Colors.grey,
                  ),
                ),
              ),
            )
            .values
            .toList(),
      ),
    );
  }

  Widget _buildOffstageNavigator(BottomNavItem currentItem, bool isSelected) {
    return Offstage(
      offstage: !isSelected,
      child: TabNavigator(
        navigatorKey: navigatorKeys[currentItem]!,
        item: currentItem,
      ),
    );
  }
}
