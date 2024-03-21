import 'package:agendador_bronzeamento/utils/validator.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/hours_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MinsPickerController extends GetxController {
  final TextEditingController mins = TextEditingController();
  final FocusNode focusNode = FocusNode();
  Function()? onEditingComplete;
}

class MinsPicker extends StatelessWidget {
  const MinsPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final HoursPickerController hoursControlller = Get.find();
    final MinsPickerController minsController = Get.find();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Center(
      child: SizedBox(
        width: width * 0.2,
        height: height * 0.07,
        child: Center(
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: minsController.mins,
                  onChanged: (value) {
                    String valStr;
                    if (Validator.isInteger(value) && int.parse(value) < 60) {
                      valStr = int.parse(value).toString();
                    } else {
                      valStr = '';
                    }
                    minsController.mins.text = valStr;
                    hoursControlller.updateOnChangedValueMayProceed();
                  },
                  onEditingComplete: minsController.onEditingComplete,
                  focusNode: minsController.focusNode,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Mins',
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
