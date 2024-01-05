import 'package:agendador_bronzeamento/views/clients/components/client_details.dart';
import 'package:flutter/material.dart';
import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:agendador_bronzeamento/views/splash/splash.dart';
import 'package:agendador_bronzeamento/views/home.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/'),
          builder: (_) => const Scaffold(),
        );
      case RoutePaths.splash:
        return MaterialPageRoute(
          builder: (context) => const Splash(),
          settings: RouteSettings(
            name: RoutePaths.splash,
            arguments: settings.arguments,
          ),
        );
      case RoutePaths.home:
        return MaterialPageRoute(
          builder: (context) => const Home(),
          settings: const RouteSettings(
            name: RoutePaths.home,
          ),
        );

      default:
        return _errorRoute();
    }
  }

  static Route onGenerateNestedRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.clientDetails:
        return MaterialPageRoute(
          builder: (context) => const ClientDetails(),
          settings: const RouteSettings(name: RoutePaths.clientDetails),
        );
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(50),
                child: const Text('Something went wrong...'),
              ),
              Container(
                margin: const EdgeInsets.all(50),
                child: const Icon(
                  Icons.report_problem_sharp,
                  color: Colors.red,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
