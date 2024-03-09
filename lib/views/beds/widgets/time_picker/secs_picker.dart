import 'package:agendador_bronzeamento/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecsPickerController extends GetxController {
  final TextEditingController secs = TextEditingController();
  final FocusNode focusNode = FocusNode();
  Function()? onEditingComplete;
}

class SecsPicker extends StatelessWidget {
  const SecsPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final SecsPickerController secsController = Get.find();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width * 0.2,
      height: height * 0.07,
      child: Center(
        child: TextFormField(
          controller: secsController.secs,
          onChanged: (value) {
            String valStr;
            if (Validator.isInteger(value) && int.parse(value) < 60) {
              valStr = int.parse(value).toString();
            } else {
              valStr = '';
            }
            secsController.secs.text = valStr;
          },
          onEditingComplete: secsController.onEditingComplete,
          focusNode: secsController.focusNode,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          decoration: const InputDecoration.collapsed(
            hintText: 'Secs',
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
