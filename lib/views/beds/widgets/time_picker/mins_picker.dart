import 'package:agendador_bronzeamento/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MinsPickerController extends GetxController {
  final TextEditingController mins = TextEditingController();
}

class MinsPicker extends StatelessWidget {
  final Function()? onEditingComplete;
  final FocusNode? focusNode;

  const MinsPicker({
    super.key,
    this.focusNode,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    final MinsPickerController controller = Get.find();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Center(
      child: Container(
        margin: const EdgeInsets.all(15),
        width: width * 0.2,
        height: height * 0.07,
        padding: const EdgeInsets.all(15),
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
              Expanded(
                child: TextFormField(
                  controller: controller.mins,
                  onChanged: (value) {
                    String valStr;
                    if (Validator.isInteger(value)) {
                      valStr = value.toString();
                    } else {
                      valStr = '0';
                    }
                    controller.mins.text = valStr;
                  },
                  onEditingComplete: onEditingComplete,
                  focusNode: focusNode,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'mins',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}