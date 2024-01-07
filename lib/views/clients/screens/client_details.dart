import 'package:agendador_bronzeamento/views/clients/widgets/image_input.dart';
import 'package:agendador_bronzeamento/views/clients/widgets/name_input.dart';
import 'package:agendador_bronzeamento/views/clients/widgets/text_area_input.dart';
import 'package:flutter/material.dart';
import '../widgets/phone_number_input/phone_number_input.dart';
import 'package:nice_buttons/nice_buttons.dart';
import 'dart:async';

class ClientDetails extends StatefulWidget {
  // final Map<String, dynamic>? clientData;
  final Map<String, dynamic>? clientData;

  const ClientDetails({super.key, this.clientData});

  @override
  State<ClientDetails> createState() => _ClientDetailsState();
}

class _ClientDetailsState extends State<ClientDetails> {
  final _formKey = GlobalKey<FormState>();
  final nameFieldController = TextEditingController();
  final phoneNumberInputController = GlobalKey<PhoneNumberInputState>();
  final obervationsController = TextEditingController();
  late FocusNode nameFocusNode, phoneFocusNode, observationsFocusNode;

  @override
  void initState() {
    super.initState();
    nameFocusNode = FocusNode();
    phoneFocusNode = FocusNode();
    observationsFocusNode = FocusNode();
    if (widget.clientData == null) {
      nameFocusNode.requestFocus();
    } else {
      nameFieldController.text = widget.clientData!['name'].toString();
      phoneNumberInputController.currentState!.textFormFieldController.text =
          widget.clientData!['phone_number'].toString();
      obervationsController.text =
          widget.clientData!['observations'].toString();
    }
  }

  @override
  void dispose() {
    nameFocusNode.dispose();
    phoneFocusNode.dispose();
    observationsFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const ImageInput(width: 120, height: 120),
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      NameInput(
                        controller: nameFieldController,
                        focusNode: nameFocusNode,
                        onEditingComplete: () => phoneFocusNode.requestFocus(),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      PhoneNumberInput(
                        key: phoneNumberInputController,
                        focusNode: phoneFocusNode,
                        onEditingComplete: () =>
                            observationsFocusNode.requestFocus(),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextAreaInput(
                        focusNode: observationsFocusNode,
                        controller: obervationsController,
                        hintText: 'Observações',
                        icon: Icons.edit_note,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      NiceButtons(
                        startColor: Colors.pink,
                        endColor: Colors.pink,
                        borderColor: Colors.pink,
                        stretch: false,
                        progress: true,
                        gradientOrientation: GradientOrientation.Horizontal,
                        onTap: (finish) {
                          // print('On tap called');
                          Timer(const Duration(seconds: 2), () {
                            finish();
                            // print('Finish');
                            Navigator.pop(context);
                          });
                        },
                        child: Text(
                          widget.clientData == null ? 'Adicionar' : 'Salvar',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
