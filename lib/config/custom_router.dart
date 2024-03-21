import 'package:agendador_bronzeamento/views/beds/screens/bed_details.dart';
import 'package:agendador_bronzeamento/views/beds/screens/search_bed.dart';
import 'package:agendador_bronzeamento/views/bronzes/bronzes.dart';
import 'package:agendador_bronzeamento/views/clients/screens/client_history.dart';
import 'package:agendador_bronzeamento/views/dashboard/dashboard.dart';
import 'package:agendador_bronzeamento/views/clients/screens/search_client.dart';
import 'package:agendador_bronzeamento/views/home.dart';
import 'package:agendador_bronzeamento/views/clients/screens/client_details.dart';
import 'package:agendador_bronzeamento/views/initialization/screens/set_default_values.dart';
import 'package:agendador_bronzeamento/views/initialization/screens/welcome.dart';
import 'package:agendador_bronzeamento/views/settings/screens/about/about.dart';
import 'package:agendador_bronzeamento/views/settings/screens/database/database.dart';
import 'package:agendador_bronzeamento/views/settings/screens/default_values/change_duration.dart';
import 'package:agendador_bronzeamento/views/settings/screens/default_values/change_price.dart';
import 'package:agendador_bronzeamento/views/settings/screens/default_values/change_turn_arounds.dart';
import 'package:flutter/material.dart';
import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:agendador_bronzeamento/views/initialization/screens/splash.dart';
import 'package:agendador_bronzeamento/views/settings/screens/default_values/default_values.dart';
import 'package:agendador_bronzeamento/database/models/client.dart';

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
      case RoutePaths.welcome:
        return MaterialPageRoute(
          builder: (context) => const Welcome(),
          settings: const RouteSettings(
            name: RoutePaths.welcome,
          ),
        );
      case RoutePaths.splash:
        return MaterialPageRoute(
          builder: (context) => Splash(),
          settings: RouteSettings(
            name: RoutePaths.splash,
            arguments: settings.arguments,
          ),
        );
      case RoutePaths.setDefaultValues:
        return MaterialPageRoute(
          builder: (context) => const SetDefaultValues(),
          settings: RouteSettings(
            name: RoutePaths.setDefaultValues,
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
        Client? client;
        if (settings.arguments != null) {
          client = settings.arguments as Client;
        }
        return MaterialPageRoute(
          builder: (context) => ClientDetails(
            client: client,
          ),
          settings: const RouteSettings(name: RoutePaths.clientDetails),
        );
      case RoutePaths.clientHistory:
        Client client = settings.arguments as Client;
        return MaterialPageRoute(
          builder: (context) => ClientHistory(
            client: client,
          ),
          settings: const RouteSettings(name: RoutePaths.clientHistory),
        );
      case RoutePaths.bedDetails:
        return MaterialPageRoute(
          builder: (context) => const BedDetails(),
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
      case RoutePaths.defaultValues:
        // Map<dynamic, dynamic>? bedArgs;
        // if (settings.arguments != null) {
        //   bedArgs = settings.arguments as Map<dynamic, dynamic>;
        // }
        return MaterialPageRoute(
          builder: (context) => const DefaultValues(),
          settings: const RouteSettings(name: RoutePaths.defaultValues),
        );
      case RoutePaths.about:
        return MaterialPageRoute(
          builder: (context) => const About(),
          settings: const RouteSettings(name: RoutePaths.about),
        );
      case RoutePaths.changeTurnArounds:
        return MaterialPageRoute(
          builder: (context) => const ChangeTurnArounds(),
          settings: const RouteSettings(name: RoutePaths.changeTurnArounds),
        );
      case RoutePaths.changeDuration:
        return MaterialPageRoute(
          builder: (context) => const ChangeDuration(),
          settings: const RouteSettings(name: RoutePaths.changeDuration),
        );
      case RoutePaths.changePrice:
        return MaterialPageRoute(
          builder: (context) => const ChangePrice(),
          settings: const RouteSettings(name: RoutePaths.changePrice),
        );
      case RoutePaths.dashboard:
        return MaterialPageRoute(
          builder: (context) => const Dashboard(),
          settings: const RouteSettings(name: RoutePaths.dashboard),
        );
      case RoutePaths.bronzes:
        return MaterialPageRoute(
          builder: (context) => const Bronzes(),
          settings: const RouteSettings(name: RoutePaths.bronzes),
        );
      case RoutePaths.database:
        return MaterialPageRoute(
          builder: (context) => const Database(),
          settings: const RouteSettings(name: RoutePaths.database),
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
