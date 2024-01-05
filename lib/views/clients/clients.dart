import 'package:agendador_bronzeamento/views/clients/components/client_details.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

class Clients extends StatefulWidget {
  const Clients({super.key});

  @override
  State<Clients> createState() => _ClientsState();
}

class _ClientsState extends State<Clients> {
  final List<Map> _databaseClients = [
    {"name": "Ana Maria do Santos"},
    {"name": "Angela Pinheiro Ribeiro"},
    {"name": "Andressa Semegova"},
    {"name": "Carla Pereira Neves"},
    {"name": "Cândida Conrado"},
    {"name": "Coimbra Astúcia"},
    {"name": "Cleuza Batista Quintino"},
    {"name": "Fernanda Almeida de Carvalho"},
    {"name": "Fabiana Fonseca"},
    {"name": "Fábia do Amaral"},
    {"name": "Rhayssa Andrade Costa"},
    {"name": "Rafaela Cerlat"},
    {"name": "Wanessa Julliana Silva"},
    {"name": "Wanna Guimarães"},
    {"name": "Watta Ribeiro"}
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
              onPressed: () => widget.key,
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
