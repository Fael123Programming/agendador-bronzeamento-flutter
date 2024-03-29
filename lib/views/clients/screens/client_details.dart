import 'dart:async';

import 'package:agendador_bronzeamento/utils/validator.dart';
import 'package:agendador_bronzeamento/views/clients/widgets/image_input.dart';
import 'package:agendador_bronzeamento/views/clients/widgets/name_input.dart';
import 'package:agendador_bronzeamento/views/clients/widgets/observations_input.dart';
import 'package:flutter/material.dart';
import 'package:agendador_bronzeamento/views/clients/widgets/phone_number_input/phone_number_input.dart';
import 'package:get/get.dart';
import 'package:nice_buttons/nice_buttons.dart';
import 'package:agendador_bronzeamento/database/models/client.dart';
import 'package:agendador_bronzeamento/views/clients/widgets/form_controller.dart';

class ClientDetailsController extends GetxController {
  final RxBool validValues = false.obs;

  void checkValues() {
    final NameInputController nameController = Get.find();
    final PhoneNumberInputController phoneController = Get.find();
    validValues.value = nameController.name.text.isNotEmpty && Validator.validatePhoneNumber(phoneController.phoneNumber.text) == null;
  }
}

class UpdatingClientController extends GetxController {
  final bool isUpdating;
  final int clientId;

  UpdatingClientController({required this.isUpdating, required this.clientId});
}

class ClientDetails extends StatelessWidget {
  final Client? client;

  const ClientDetails({super.key, this.client});

  @override
  Widget build(context) {
    final ClientDetailsController clientDetailsController = Get.put(ClientDetailsController());
    final UpdatingClientController updatingController = Get.put(
      UpdatingClientController(
        isUpdating: client != null,
        clientId: client == null ? -1 : client!.id
      )
    );
    final ClientController clientController = Get.find(); 
    final ImageInputController imageController = Get.put(ImageInputController());
    final FormController formController = Get.put(FormController());
    final ObservationsInputController observationsController = Get.put(
      ObservationsInputController(
        onEditingComplete: () => FocusManager.instance.primaryFocus!.unfocus(),
        hintText: 'Observações', 
        icon: Icons.edit_note
      )
    );
    final PhoneNumberInputController phoneNumberController = Get.put(
      PhoneNumberInputController(
        onEditingComplete: () => observationsController.focusNode.requestFocus()
      )
    );
    final NameInputController nameController = Get.put(
      NameInputController(
        onEditingComplete: () => phoneNumberController.focusNode.requestFocus()
      )
    );
    if (client == null) {
      Timer.periodic(const Duration(milliseconds: 500), (timer) { 
        nameController.focusNode.requestFocus();
        timer.cancel();
      });
    } else {
      nameController.name.text = client!.name;
      phoneNumberController.phoneNumber.text = client!.phoneNumber;
      observationsController.observations.text = client?.observations == null ? '' : client!.observations!;
      if (client?.picture != null) {
        imageController.imageData.value = client!.picture;
        imageController.picked.value = true;
      }
      clientDetailsController.validValues.value = true;
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
        Get.delete<ImageInputController>();
        Get.delete<UpdatingClientController>();
        Get.delete<ClientDetailsController>();
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            updatingController.isUpdating ? IconButton(
              onPressed: () async {
                Get.dialog(
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Material(
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  const Text(
                                    'Remover Cliente',
                                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    'Deseja remover ${client!.name.split(" ")[0]}?',
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: const Size(0, 45),
                                            backgroundColor: const Color.fromARGB(255, 255, 17, 0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () => Get.back(),
                                          child: const Text(
                                            'Não',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: const Size(0, 45),
                                            backgroundColor: const Color.fromARGB(255, 0, 255, 8),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          onPressed: () async {
                                            await clientController.delete(client!);
                                            Get.back();
                                            // await Future.delayed(const Duration(seconds: 1));
                                            if (!context.mounted) {
                                              return;
                                            }
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text(
                                            'Sim',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }, 
              icon: const Icon(Icons.delete, color: Color.fromARGB(255, 255, 17, 0))
            ) : Container()
          ],
        ),
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
                      Obx(() => NiceButtons(
                        startColor: clientDetailsController.validValues.value ? Colors.pink : Colors.grey,
                        endColor: clientDetailsController.validValues.value ? Colors.pink : Colors.grey,
                        borderColor: clientDetailsController.validValues.value ? Colors.pink : Colors.grey,
                        disabled: !clientDetailsController.validValues.value,
                        stretch: false,
                        progress: false,
                        gradientOrientation: GradientOrientation.Horizontal,
                        onTap: (finish) async {
                          if (clientDetailsController.validValues.value && formController.formKey.currentState!.validate()) {
                            if (client == null) {
                              await clientController.insert(
                                Client.toSave(
                                  name: nameController.name.text,
                                  phoneNumber: phoneNumberController.phoneNumber.text,
                                  observations: observationsController.observations.text,
                                  picture: imageController.imageData.value
                                )
                              );
                            } else {
                              clientController.doUpdate(
                                Client(
                                  id: client!.id,
                                  name: nameController.name.text,
                                  phoneNumber: phoneNumberController.phoneNumber.text,
                                  since: client!.since,
                                  bronzes: client!.bronzes,
                                  observations: observationsController.observations.text,
                                  picture: imageController.imageData.value
                                )
                              );
                            }
                            await Future.delayed(const Duration(seconds: 1));
                            if (!context.mounted) {
                              return;
                            }
                            Navigator.of(context).pop();
                          } else {
                            formController.error.value = true;
                          }
                        },
                        child: Text(
                          updatingController.isUpdating ? 'Salvar' : 'Adicionar',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ))
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
