import 'dart:async';

import 'package:agendador_bronzeamento/views/clients/widgets/image_input.dart';
import 'package:agendador_bronzeamento/views/clients/widgets/name_input.dart';
import 'package:agendador_bronzeamento/views/clients/widgets/observations_input.dart';
import 'package:flutter/material.dart';
import 'package:agendador_bronzeamento/views/clients/widgets/phone_number_input/phone_number_input.dart';
import 'package:get/get.dart';
import 'package:nice_buttons/nice_buttons.dart';
import 'package:agendador_bronzeamento/models/user.dart';
import 'package:agendador_bronzeamento/views/clients/widgets/form_controller.dart';

class UpdatingUserController extends GetxController {
  final RxBool updating;

  UpdatingUserController({required this.updating});
}

class ClientDetails extends StatelessWidget {
  const ClientDetails({super.key, this.clientData});

  final User? clientData;

  @override
  Widget build(context) {
    final UpdatingUserController updatingController = Get.put(UpdatingUserController(updating: (clientData != null).obs));
    final UserController userController = Get.find(); 
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
    if (clientData == null) {
      nameController.focusNode.requestFocus();
    } else {
      nameController.name.text = clientData!.name;
      phoneNumberController.phoneNumber.text = clientData!.phoneNumber;
      observationsController.observations.text = clientData?.observations == null ? '' : clientData!.observations!;
      if (clientData?.profileImage != null) {
        imageController.imageData.value = clientData!.profileImage;
        imageController.picked.value = true;
      }
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
        Get.delete<UpdatingUserController>();
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            updatingController.updating.value ? IconButton(
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
                                    'Deseja remover ${clientData!.name.split(" ")[0]}?',
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
                                            await userController.removeUser(
                                              userController.findUserByName(clientData!.name)!
                                            );
                                            Get.back();
                                            // Get.showSnackbar(
                                            //   GetSnackBar(
                                            //     titleText: Center(
                                            //       child: Text(
                                            //         '${clientData!.name.split(" ")[0]} removido com sucesso!',
                                            //         style: const TextStyle(
                                            //           color: Colors.white,
                                            //           fontSize: 20
                                            //         ),
                                            //       ),
                                            //     ),
                                            //     messageText: const Text(''),
                                            //     duration: const Duration(seconds: 1),
                                            //     backgroundColor: const Color.fromARGB(255, 0, 255, 8),
                                            //   )
                                            // );
                                            await Future.delayed(const Duration(seconds: 1));
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
                      NiceButtons(
                        startColor: Colors.pink,
                        endColor: Colors.pink,
                        borderColor: Colors.pink,
                        stretch: false,
                        progress: false,
                        gradientOrientation: GradientOrientation.Horizontal,
                        onTap: (finish) async {
                          if (formController.formKey.currentState!.validate()) {
                            if (clientData == null) {
                              await userController.addUser(
                                User(
                                  name: nameController.name.text,
                                  phoneNumber: phoneNumberController.phoneNumber.text,
                                  bronzes: 0,
                                  timestamp: DateTime.now(),
                                  observations: observationsController.observations.text,
                                  profileImage: imageController.picked.value ? imageController.imageData.value : null
                                )
                              );
                            } else {
                              final oldUser = userController.findUserByName(nameController.name.text)!;
                              await userController.updateUser(
                                oldUser,
                                User(
                                  name: nameController.name.text,
                                  phoneNumber: phoneNumberController.phoneNumber.text,
                                  bronzes: oldUser.bronzes,
                                  timestamp: oldUser.timestamp,
                                  observations: observationsController.observations.text,
                                  profileImage: imageController.picked.value ? imageController.imageData.value : null
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
                          updatingController.updating.value ? 'Salvar' : 'Adicionar',
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
