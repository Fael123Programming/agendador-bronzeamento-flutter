import 'package:agendador_bronzeamento/views/clients/widgets/form_controller.dart';
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FormController formController = Get.find();
    final PhoneNumberInputController phoneNumberController = Get.find();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
                    formController.formKey.currentState?.reset();
                  },
                  validator: (value) => Validator.validatePhoneNumber(value),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
