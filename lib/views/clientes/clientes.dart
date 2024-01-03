import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

class Clientes extends StatefulWidget {
  const Clientes({super.key});

  @override
  State<Clientes> createState() => _ClientesState();
}

class _ClientesState extends State<Clientes> {
  final List<Map> _databaseClients = [
    {"group": "A", "name": "Ana Maria do Santos"},
    {"group": "A", "name": "Angela Pinheiro Ribeiro"},
    {"group": "A", "name": "Andressa Semegova"},
    {"group": "C", "name": "Carla Pereira Neves"},
    {"group": "C", "name": "Cândida Conrado"},
    {"group": "C", "name": "Coimbra Astúcia"},
    {"group": "C", "name": "Cleuza Batista Quintino"},
    {"group": "F", "name": "Fernanda Almeida de Carvalho"},
    {"group": "F", "name": "Fabiana Fonseca"},
    {"group": "F", "name": "Fábia do Amaral"},
    {"group": "R", "name": "Rhayssa Andrade Costa"},
    {"group": "R", "name": "Rafaela Cerlat"},
    {"group": "W", "name": "Wanessa Julliana Silva"},
    {"group": "W", "name": "Wanna Guimarães"},
    {"group": "W", "name": "Watta Ribeiro"}
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
              onPressed: () {},
              foregroundColor: Colors.white,
              backgroundColor: Colors.pink,
              child: const Icon(Icons.add),
            ),
      body: GroupedListView<Map, String>(
        elements: _clientsToShow.isEmpty && !_searchClient
            ? _databaseClients
            : _clientsToShow,
        groupBy: (element) => element['group'],
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
            item1['name'].compareTo(item2['name']), // optional
        floatingHeader: true, // optional
        order: GroupedListOrder.ASC, // optional
      ),
    );
  }

  Widget _searchTextField() {
    return TextField(
      onChanged: (String s) {
        setState(() {
          _clientsToShow.clear();
          _clientsToShow.addAll(_databaseClients.where((element) =>
              element['name']
                  .toString()
                  .toLowerCase()
                  .contains(s.toLowerCase())));
        });
      },
      autofocus: true,
      cursorColor: Colors.black,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search,
      decoration: const InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        hintText: 'Pesquisar cliente',
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 20,
        ),
      ),
    );
  }
}
