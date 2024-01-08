import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

class Clients extends StatefulWidget {
  const Clients({super.key});

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  final List<Map> _databaseClients = [
    {
      'name': 'Ana Maria do Santos',
      'phone_number': '(64) 99211-3720',
      'observations': '',
    },
    {
      'name': 'Angela Pinheiro Ribeiro',
      'phone_number': '(64) 99211-3720',
      'observations': 'Tem alergia e sensibilidade na pele',
    },
    {
      'name': 'Andressa Semegova',
      'phone_number': '(64) 99211-3720',
      'observations': 'Tem alergia e sensibilidade na pele',
    },
    {
      'name': 'Carla Pereira Neves',
      'phone_number': '(64) 99211-3720',
      'observations': 'Tem alergia e sensibilidade na pele',
    },
    {
      'name': 'Cândida Conrado',
      'phone_number': '(64) 99211-3720',
      'observations': 'Tem alergia e sensibilidade na pele',
    },
    {
      'name': 'Coimbra Astúcia',
      'phone_number': '(64) 99211-3720',
      'observations': 'Tem alergia e sensibilidade na pele',
    },
    {
      'name': 'Cleuza Batista Quintino',
      'phone_number': '(64) 99211-3720',
      'observations': 'Tem alergia e sensibilidade na pele',
    },
    {
      'name': 'Fernanda Almeida de Carvalho',
      'phone_number': '(64) 99211-3720',
      'observations': '',
    },
    {
      'name': 'Fabiana Fonseca',
      'phone_number': '(64) 99211-3720',
      'observations': 'Tem alergia e sensibilidade na pele',
    },
    {
      'name': 'Fábia do Amaral',
      'phone_number': '(64) 99211-3720',
      'observations': 'Tem alergia e sensibilidade na pele',
    },
    {
      'name': 'Rhayssa Andrade Costa',
      'phone_number': '(64) 99211-3720',
      'observations': '',
    },
    {
      'name': 'Rafaela Cerlat',
      'phone_number': '(64) 99211-3720',
      'observations': 'Tem alergia e sensibilidade na pele',
    },
    {
      'name': 'Wanessa Julliana Silva',
      'phone_number': '(64) 99211-3720',
      'observations': 'Tem alergia e sensibilidade na pele',
    },
    {
      'name': 'Wanna Guimarães',
      'phone_number': '(64) 99211-3720',
      'observations': 'Tem alergia e sensibilidade na pele',
    },
    {
      'name': 'Watta Ribeiro',
      'phone_number': '(64) 99211-3720',
      'observations': 'Tem alergia e sensibilidade na pele',
    },
  ];

  final List<Map> _clientsToShow = List.empty(growable: true);

  bool _searchClient = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _searchClient
            ? _searchTextField()
            : const Text(
                'Clientes',
              ),
        actions: _searchClient
            ? [
                IconButton(
                  onPressed: () => setState(() {
                    _searchClient = false;
                    _clientsToShow.clear();
                  }),
                  icon: const Icon(Icons.clear),
                )
              ]
            : [
                IconButton(
                  onPressed: () => setState(() => _searchClient = true),
                  icon: const Icon(Icons.search),
                )
              ],
      ),
      floatingActionButton: _searchClient
          ? null
          : FloatingActionButton(
              onPressed: () =>
                  Navigator.pushNamed(context, RoutePaths.clientDetails),
              foregroundColor: Colors.white,
              backgroundColor: Colors.pink,
              child: const Icon(Icons.add),
            ),
      body: GroupedListView<Map, String>(
        elements: _clientsToShow.isEmpty && !_searchClient
            ? _databaseClients
            : _clientsToShow,
        groupBy: (element) => element['name'][0].toString().toUpperCase(),
        groupSeparatorBuilder: (String groupByValue) => Container(
          decoration: BoxDecoration(
            color: Colors.pink,
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(10),
          child: Text(
            groupByValue,
            textAlign: TextAlign.start,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        itemBuilder: (context, dynamic element) => Container(
          margin: const EdgeInsets.all(10),
          child: ListTile(
            onTap: () => Navigator.pushNamed(
              context,
              RoutePaths.clientDetails,
              arguments: element,
            ),
            tileColor: Colors.pink[50],
            title: Text(element["name"]),
            leading: const Icon(Icons.person_2),
            // leading: CircleAvatar(
            // backgroundImage: AssetImage("..."),
            // backgroundColor: Colors.pink[50],
            // ),
          ),
        ),
        itemComparator: (item1, item2) =>
            item1['name'].compareTo(item2['name']),
        floatingHeader: true,
        order: GroupedListOrder.ASC,
      ),
    );
  }

  Widget _searchTextField() {
    return TextField(
      onChanged: (String s) {
        setState(() {
          _clientsToShow.clear();
          _clientsToShow.addAll(
            _databaseClients.where(
              (element) => element['name'].toString().toLowerCase().contains(
                    s.toLowerCase(),
                  ),
            ),
          );
        });
      },
      autofocus: true,
      cursorColor: Colors.black,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        icon: Image.asset('assets/tanning.png', width: 30, height: 30),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        hintText: 'Pesquisar cliente',
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 20,
        ),
      ),
    );
  }
}
