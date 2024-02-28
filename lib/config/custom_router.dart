import 'package:agendador_bronzeamento/views/beds/screens/bed_details.dart';
import 'package:agendador_bronzeamento/views/beds/screens/search_bed.dart';
import 'package:agendador_bronzeamento/views/clients/screens/search_client.dart';
import 'package:agendador_bronzeamento/views/home.dart';
import 'package:agendador_bronzeamento/views/clients/screens/client_details.dart';
import 'package:flutter/material.dart';
import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:agendador_bronzeamento/views/splash/splash.dart';
import 'package:agendador_bronzeamento/views/settings/screens/general.dart';
import 'package:agendador_bronzeamento/models/user.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case '/':
      //   return MaterialPageRoute(
      //     builder: (context) => const Home(),
      //     settings: const RouteSettings(
      //       name: RoutePaths.home,
      //     ),
      //   );
      case RoutePaths.home:
        return MaterialPageRoute(
          builder: (context) => const Home(),
          settings: const RouteSettings(
            name: RoutePaths.home,
          ),
        );
      case RoutePaths.splash:
        return MaterialPageRoute(
          builder: (context) => const Splash(),
          settings: RouteSettings(
            name: RoutePaths.splash,
            arguments: settings.arguments,
          ),
        );
      default:
        return _errorRoute();
    }
  }

  static Route onGenerateNestedRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.clientDetails:
        User? clientData;
        if (settings.arguments != null) {
          clientData = settings.arguments as User;
        }
        return MaterialPageRoute(
          builder: (context) => ClientDetails(
            clientData: clientData,
          ),
          settings: const RouteSettings(name: RoutePaths.clientDetails),
        );
      case RoutePaths.bedDetails:
        Map<dynamic, dynamic>? bedArgs;
        if (settings.arguments != null) {
          bedArgs = settings.arguments as Map<dynamic, dynamic>;
        }
        return MaterialPageRoute(
          builder: (context) => BedDetails(
            bedData: bedArgs,
          ),
          settings: const RouteSettings(name: RoutePaths.clientDetails),
        );
      case RoutePaths.searchClient:
        return MaterialPageRoute(
          builder: (context) => const SearchClient(),
          settings: const RouteSettings(name: RoutePaths.searchClient)
        );
      case RoutePaths.searchBed:
        return MaterialPageRoute(
          builder: (context) => const SearchBed(),
          settings: const RouteSettings(name: RoutePaths.searchBed)
        );
      case RoutePaths.general:
        // Map<dynamic, dynamic>? bedArgs;
        // if (settings.arguments != null) {
        //   bedArgs = settings.arguments as Map<dynamic, dynamic>;
        // }
        return MaterialPageRoute(
          builder: (context) => const General(),
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
