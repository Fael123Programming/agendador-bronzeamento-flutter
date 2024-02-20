import 'package:agendador_bronzeamento/views/clients/widgets/image_input.dart';
import 'package:agendador_bronzeamento/views/clients/widgets/name_input.dart';
import 'package:agendador_bronzeamento/views/clients/widgets/observations_input.dart';
import 'package:flutter/material.dart';
import 'package:agendador_bronzeamento/views/clients/widgets/phone_number_input/phone_number_input.dart';
import 'package:get/get.dart';
import 'package:nice_buttons/nice_buttons.dart';
import 'package:agendador_bronzeamento/models/user.dart';
import 'package:agendador_bronzeamento/views/clients/widgets/form_controller.dart';

class ClientDetails extends StatelessWidget {
  const ClientDetails({super.key, this.clientData});

  final User? clientData;

  @override
  Widget build(context) {
    final UserController userController = Get.find(); 
    final FormController formController = Get.put(FormController());
    final ObservationsInputController observationsController = Get.put(ObservationsInputController(hintText: 'Observações', icon: Icons.edit_note));
    final PhoneNumberInputController phoneNumberController = Get.put(PhoneNumberInputController(onEditingComplete: () => observationsController.focusNode.requestFocus()));
    final NameInputController nameController = Get.put(NameInputController(onEditingComplete: () => phoneNumberController.focusNode.requestFocus()));
    if (clientData == null) {
      nameController.focusNode.requestFocus();
    } else {
      nameController.name.text = clientData!.name;
      phoneNumberController.phoneNumber.text = clientData!.phoneNumber;
      observationsController.observations.text = clientData?.observations == null ? '' : clientData!.observations!;
    }
    return PopScope(
      onPopInvoked: (didPop) {
        nameController.focusNode.dispose();
        phoneNumberController.focusNode.dispose();
        observationsController.focusNode.dispose();
        Get.delete<NameInputController>();
        Get.delete<PhoneNumberInputController>();
        Get.delete<ObservationsInputController>();
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
                      const ObservationsInput(),
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
                        onTap: (finish) async {
                          if (formController.formKey.currentState!.validate()) {
                            await userController.addUser(
                              User(
                                name: nameController.name.text,
                                phoneNumber: phoneNumberController.phoneNumber.text,
                                observations: observationsController.observations.text
                              )
                            );
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
