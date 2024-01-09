import 'package:agendador_bronzeamento/views/beds/widgets/search_client_input.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/turn_around_input.dart';
import 'package:flutter/material.dart';

class BedDetails extends StatefulWidget {
  final Map<dynamic, dynamic>? bedData;

  const BedDetails({super.key, this.bedData});

  @override
  State<BedDetails> createState() => _BedDetails();
}

class _BedDetails extends State<BedDetails> {
  final _formKey = GlobalKey<FormState>();
  final searchClientInputController = TextEditingController();
  final turnAroundInputController = TextEditingController();
  late FocusNode searchClientInputFocusNode, turnAroundFocusNode;
  final String defaultTurnAroundNumber = '4';

  @override
  void initState() {
    super.initState();
    searchClientInputFocusNode = FocusNode();
    turnAroundFocusNode = FocusNode();
    searchClientInputFocusNode.requestFocus();
  }

  @override
  void dispose() {
    searchClientInputFocusNode.dispose();
    turnAroundFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Container(
            margin: const EdgeInsets.only(top: 50),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SearchClientInput(
                          controller: searchClientInputController,
                          focusNode: searchClientInputFocusNode,
                          onEditingComplete: () {
                            setState(
                              () => turnAroundInputController.text =
                                  defaultTurnAroundNumber,
                            );
                          },
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        TurnAroundInput(
                          controller: turnAroundInputController,
                          focusNode: turnAroundFocusNode,
                          onEditingComplete: () {},
                        ),
                        // Text('Tempo'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
