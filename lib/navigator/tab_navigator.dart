import 'package:agendador_bronzeamento/config/custom_router.dart';
import 'package:agendador_bronzeamento/navigator/bottom_nav_item.dart';
import 'package:agendador_bronzeamento/views/beds/beds.dart';
import 'package:agendador_bronzeamento/views/clients/clients.dart';
import 'package:agendador_bronzeamento/views/bronzes/bronzes.dart';
import 'package:agendador_bronzeamento/views/dashboard/dashboard.dart';
import 'package:agendador_bronzeamento/views/settings/settings.dart';
import 'package:flutter/material.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = '/';

  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavItem item;

  const TabNavigator({super.key, required this.navigatorKey, required this.item});
  
  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilder();
    return Navigator(
      key: navigatorKey,
      initialRoute: tabNavigatorRoot,
      onGenerateInitialRoutes: (_, initialRoute) {
        return [
          MaterialPageRoute(
            settings: const RouteSettings(name: tabNavigatorRoot),
            builder: (context) => routeBuilders[initialRoute]!(context),
          )
        ];
      },
      onGenerateRoute: CustomRouter.onGenerateNestedRoute,
    );
  }

  Map<String, WidgetBuilder> _routeBuilder() {
    return {tabNavigatorRoot: (context) => _getScreen(context, item)};
  }

  _getScreen(BuildContext context, BottomNavItem item) {
    switch (item) {
      case BottomNavItem.beds:
        return const Beds();
      case BottomNavItem.bronzes:
        return const Bronzes();
      case BottomNavItem.dashboard:
        return const Dashboard(); 
      case BottomNavItem.clients:
        return const Clients();
      case BottomNavItem.config:
        return const Settings();
      default:
        return const Scaffold();
    }
  }
}
