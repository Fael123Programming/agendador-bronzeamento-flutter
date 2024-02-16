import 'package:agendador_bronzeamento/views/clients/widgets/image_input.dart';
import 'package:agendador_bronzeamento/views/clients/widgets/name_input.dart';
import 'package:agendador_bronzeamento/views/clients/widgets/text_area_input.dart';
import 'package:flutter/material.dart';
import 'package:agendador_bronzeamento/views/clients/widgets/phone_number_input/phone_number_input.dart';
import 'package:get/get.dart';
import 'package:nice_buttons/nice_buttons.dart';
import 'package:agendador_bronzeamento/models/user.dart';
import 'package:agendador_bronzeamento/views/clients/widgets/form_controller.dart';

class ClientDetails extends StatelessWidget {
  // final Map<String, dynamic>? clientData;
  ClientDetails({super.key, this.clientData});

  final User? clientData;
  // final formKey = GlobalKey<FormState>();
  final nameFieldController = TextEditingController();
  final phoneNumberInputController = TextEditingController();
  final obervationsController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode(), observationsFocusNode = FocusNode();

  @override
  Widget build(context) {
    final FormController formController = Get.put(FormController());
    final TextAreaInputController textAreaController = Get.put(TextAreaInputController(hintText: 'Observações', icon: Icons.edit_note));
    final PhoneNumberInputController phoneNumberController = Get.put(PhoneNumberInputController(onEditingComplete: () => textAreaController.focusNode.requestFocus()));
    final NameInputController nameController = Get.put(NameInputController(onEditingComplete: () => phoneNumberController.focusNode.requestFocus()));
    if (clientData == null) {
      nameController.focusNode.requestFocus();
    } else {
      nameController.name.text = clientData!.name;
      phoneNumberController.phoneNumber.text = clientData!.phoneNumber;
      textAreaController.textArea.text = clientData!.observations;
    }
    return PopScope(
      onPopInvoked: (didPop) {
        nameController.focusNode.dispose();
        phoneNumberController.focusNode.dispose();
        textAreaController.focusNode.dispose();
        Get.delete<NameInputController>();
        Get.delete<PhoneNumberInputController>();
        Get.delete<TextAreaInputController>();
        Get.delete<FormController>();
      },
      child: Scaffold(
        appBar: AppBar(),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const ImageInput(width: 120, height: 120),
                  Form(
                  key: formController.formKey,
                  child: Column(
                    children: <Widget>[
                      const NameInput(),
                      const SizedBox(
                        height: 25,
                      ),
                      const PhoneNumberInput(),
                      const SizedBox(
                        height: 25,
                      ),
                      const TextAreaInput(),
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
                          if (formController.formKey.currentState!.validate()) {
                            Get.showSnackbar(
                              const GetSnackBar(
                                titleText: Center(
                                  child: Text(
                                    'Cadastrado com sucesso!', 
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20
                                    ),
                                  ),
                                ),
                                messageText: Text(''),
                                duration: Duration(seconds: 1),
                                backgroundColor: Color.fromARGB(255, 0, 255, 8),
                              )
                            );
                          } else {
                            Get.showSnackbar(
                              const GetSnackBar(
                                titleText: Center(
                                  child: Text(
                                    'Preencha os campos corretamente', 
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20
                                    ),
                                  ),
                                ),
                                messageText: Text(''),
                                duration: Duration(seconds: 1),
                                backgroundColor: Color.fromARGB(255, 255, 17, 0),
                              )
                            );
                            // formKey.currentState!.reset();
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
