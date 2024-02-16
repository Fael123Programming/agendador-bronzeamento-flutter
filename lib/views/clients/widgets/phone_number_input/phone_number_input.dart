import 'package:agendador_bronzeamento/views/clients/widgets/phone_number_input/br_phone_number_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../utils/validator.dart';

class PhoneNumberInput extends StatelessWidget {
  final FocusNode? focusNode;
  final Function()? onEditingComplete;
  final TextEditingController? controller;

  const PhoneNumberInput({
    Key? key,
    this.focusNode,
    this.onEditingComplete,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController textFormFieldController =
        controller != null ? controller! : TextEditingController();
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
                  onEditingComplete: onEditingComplete,
                  focusNode: focusNode,
                  enableInteractiveSelection: false,
                  controller: textFormFieldController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Telefone',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  inputFormatters: <TextInputFormatter>[
                    BrPhoneNumberFormatter()
                  ],
                  onTap: () {
                    textFormFieldController.selection =
                        TextSelection.fromPosition(
                      TextPosition(
                        offset: textFormFieldController.text.length,
                      ),
                    );
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
