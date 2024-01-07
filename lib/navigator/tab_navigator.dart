import 'package:agendador_bronzeamento/config/custom_router.dart';
import 'package:agendador_bronzeamento/navigator/bottom_nav_item.dart';
import 'package:agendador_bronzeamento/views/beds/beds.dart';
import 'package:agendador_bronzeamento/views/clients/clients.dart';
import 'package:agendador_bronzeamento/views/settings/settings.dart';
import 'package:flutter/material.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = '/';

  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavItem item;

  const TabNavigator({Key? key, required this.navigatorKey, required this.item})
      : super(key: key);
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
      case BottomNavItem.one:
        return const Beds();
      case BottomNavItem.two:
        return const Clients();
      case BottomNavItem.three:
        return const Settings();
      default:
        return const Scaffold();
    }
  }
}
