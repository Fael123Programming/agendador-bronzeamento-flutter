import 'package:flutter/material.dart';

class SearchClientInput extends StatefulWidget {
  final FocusNode? focusNode;
  final Function()? onEditingComplete;
  final TextEditingController? controller;

  const SearchClientInput({
    Key? key,
    this.focusNode,
    this.onEditingComplete,
    this.controller,
  }) : super(key: key);

  @override
  State<SearchClientInput> createState() => _SearchClientInputState();
}

class _SearchClientInputState extends State<SearchClientInput> {
  final controller = TextEditingController();
  late TextEditingController textFormFieldController;
  List<Map> usersToShow = [];

  @override
  void initState() {
    super.initState();
    textFormFieldController =
        widget.controller != null ? widget.controller! : controller;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Center(
          child: Container(
            width: width * 0.8,
            height: height * 0.07,
            padding: EdgeInsets.all(width * 0.03),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.white,
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            child: Center(
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: width * 0.04,
                  ),
                  Expanded(
                    child: TextFormField(
                      onChanged: (value) => setState(() {
                        if (value.isNotEmpty) {
                          usersToShow = _fetchUsersThatMatch(value);
                        } else {
                          usersToShow = [];
                        }
                      }),
                      onEditingComplete: widget.onEditingComplete,
                      focusNode: widget.focusNode,
                      controller: textFormFieldController,
                      // autofocus: true,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Cliente',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Column(
          children: _drawUsersCards(usersToShow),
        )
      ],
    );
  }

  List<Map> _fetchUsersThatMatch(String name) {
    final List<Map> databaseClients = [
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
    List<Map> toReturn = [];
    toReturn.addAll(
      databaseClients
          .where(
            (element) => element['name'].toString().toLowerCase().contains(
                  name.toLowerCase(),
                ),
          )
          .take(3),
    );
    return toReturn;
  }

  List<Widget> _drawUsersCards(List<Map> users) {
    List<Widget> toReturn = [];
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    toReturn.addAll(
      users.map(
        (e) => GestureDetector(
          onTap: () => setState(() {
            textFormFieldController.text = e['name'];
            usersToShow = [];
            FocusScope.of(context).unfocus();
            widget.onEditingComplete != null && widget.onEditingComplete!();
          }),
          child: Center(
            child: Container(
              width: width * 0.8,
              height: height * 0.07,
              padding: EdgeInsets.all(width * 0.03),
              // margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.white,
                border: Border.all(
                  color: Colors.grey,
                ),
              ),
              child: Center(
                child: Row(
                  children: [
                    const Icon(
                      Icons.person_2,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: width * 0.04,
                    ),
                    Expanded(
                      child: Text(
                        e['name'],
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    return toReturn;
  }
}
