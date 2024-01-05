import 'package:flutter/material.dart';
import 'package:agendador_bronzeamento/views/home.dart';
import 'package:agendador_bronzeamento/views/clients/components/client_details.dart';

var routes = <String, WidgetBuilder>{
  '/': (BuildContext ctx) => const App(),
  '/detalhesdecliente': (BuildContext ctx) => const ClientDetails()
};
