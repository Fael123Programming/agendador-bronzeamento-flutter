import 'package:agendador_bronzeamento/views/clients/widgets/image_input.dart';
import 'package:agendador_bronzeamento/views/clients/widgets/name_input.dart';
import 'package:agendador_bronzeamento/views/clients/widgets/text_area_input.dart';
import 'package:flutter/material.dart';
import 'package:agendador_bronzeamento/views/clients/widgets/phone_number_input/phone_number_input.dart';
import 'package:get/get.dart';
import 'package:nice_buttons/nice_buttons.dart';
import 'package:agendador_bronzeamento/models/user.dart';
import 'dart:async';

class HideHintTextController extends GetxController {
  RxBool hide = false.obs;
}

class ClientDetails extends StatelessWidget {
  // final Map<String, dynamic>? clientData;
  ClientDetails({super.key, this.clientData});

  final User? clientData;

  final formKey = GlobalKey<FormState>();
  final nameFieldController = TextEditingController();
  final phoneNumberInputController = TextEditingController();
  final obervationsController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode(), phoneFocusNode = FocusNode(), observationsFocusNode = FocusNode();

  @override
  Widget build(context) {
    if (clientData == null) {
      nameFocusNode.requestFocus();
    } else {
      nameFieldController.text = clientData!.name;
      phoneNumberInputController.text = clientData!.phoneNumber;
      obervationsController.text = clientData!.observations;
    }
    Get.put(HideHintTextController());
    return PopScope(
      onPopInvoked: (didPop) {
        nameFocusNode.dispose();
        phoneFocusNode.dispose();
        observationsFocusNode.dispose();
        Get.delete<HideHintTextController>();
      },
      child: Scaffold(
        appBar: AppBar(),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const ImageInput(width: 120, height: 120),
                Obx(() =>
                  Form(
                  key: formKey,
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
                        controller: phoneNumberInputController,
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
                        progress: false,
                        gradientOrientation: GradientOrientation.Horizontal,
                        onTap: (finish) {
                          if (formKey.currentState!.validate()) {
                            Get.showSnackbar(
                              const GetSnackBar(
                                title: 'Cadastrado com sucesso!',
                                messageText: Text(''),
                                duration: Duration(seconds: 1),
                                backgroundColor: Color.fromARGB(255, 0, 255, 8),
                              )
                            );
                          } else {
                            Get.showSnackbar(
                              const GetSnackBar(
                                title: 'Preencha os campos corretamente',
                                messageText: Text(''),
                                duration: Duration(seconds: 1),
                                backgroundColor: Color.fromARGB(255, 255, 17, 0),
                              )
                            );
                          }
                        },
                        child: Text(
                          clientData == null ? 'Adicionar' : 'Salvar',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
