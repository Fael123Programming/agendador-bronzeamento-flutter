import 'package:agendador_bronzeamento/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HoursPickerController extends GetxController {
  final TextEditingController hours = TextEditingController();
  final FocusNode focusNode = FocusNode();
  Function()? onEditingComplete;
}

class HoursPicker extends StatelessWidget {
  const HoursPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final HoursPickerController hoursController = Get.find();
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
                  controller: hoursController.hours,
                  onChanged: (value) {
                    String valStr;
                    if (Validator.isInteger(value)) {
                      valStr = int.parse(value).toString();
                    } else {
                      valStr = '';
                    }
                    hoursController.hours.text = valStr;
                  },
                  onEditingComplete: hoursController.onEditingComplete,
                  focusNode: hoursController.focusNode,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'hrs',
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
