import 'package:agendador_bronzeamento/views/clients/screens/client_details.dart';
import 'package:agendador_bronzeamento/views/clients/widgets/form_controller.dart';
import 'package:agendador_bronzeamento/views/clients/widgets/name_input.dart';
import 'package:agendador_bronzeamento/views/clients/widgets/phone_number_input/br_phone_number_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:agendador_bronzeamento/utils/validator.dart';
import 'package:get/get.dart';

class PhoneNumberInputController extends GetxController {
  final TextEditingController phoneNumber = TextEditingController();
  final FocusNode focusNode = FocusNode();
  Function()? onEditingComplete;

  PhoneNumberInputController({this.onEditingComplete});
}

class PhoneNumberInput extends StatelessWidget {

  const PhoneNumberInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ClientDetailsController clientDetailsController = Get.find();
    final FormController formController = Get.find();
    final PhoneNumberInputController phoneNumberController = Get.find();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Center(
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
            children: [
              const Icon(
                Icons.phone_android,
                color: Colors.grey,
              ),
              SizedBox(
                width: width * 0.04,
              ),
              Expanded(
                child: TextFormField(
                  onChanged: (value) => clientDetailsController.checkValues(),
                  onEditingComplete: phoneNumberController.onEditingComplete,
                  focusNode: phoneNumberController.focusNode,
                  enableInteractiveSelection: false,
                  controller: phoneNumberController.phoneNumber,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Telefone',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 12
                    ),
                  ),
                  inputFormatters: <TextInputFormatter>[
                    BrPhoneNumberFormatter()
                  ],
                  onTap: () {
                    phoneNumberController.phoneNumber.selection =
                        TextSelection.fromPosition(
                      TextPosition(
                        offset: phoneNumberController.phoneNumber.text.length,
                      ),
                    );
                    if (formController.error.value) {
                      final NameInputController nameController = Get.find();
                      String name = nameController.name.text;
                      String phone = phoneNumberController.phoneNumber.text;
                      formController.formKey.currentState?.reset();
                      formController.error.value = false;
                      if (formController.component.value != 'phone_number_input') {
                        phoneNumberController.phoneNumber.text = phone;
                      } else {
                        nameController.name.text = name;
                      }
                      formController.component.value = '';
                    }
                  },
                  validator: (value) {
                    String ? result = Validator.validatePhoneNumber(value);
                    if (result != null) {
                      formController.component.value = 'phone_number_input';
                    }
                    return result;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
