import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/hours_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/mins_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/secs_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/time_picker.dart';
import 'package:agendador_bronzeamento/views/initialization/screens/set_default_values.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DurationDefault extends StatelessWidget {
  const DurationDefault({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final PageViewController pageController = Get.find();
    final HoursPickerController hoursController = Get.find();
    final SecsPickerController secsController = Get.put(SecsPickerController());
    final MinsPickerController minsController = Get.put(MinsPickerController());
    minsController.onEditingComplete = () => secsController.focusNode.requestFocus();
    hoursController.onEditingComplete = () => minsController.focusNode.requestFocus();
    hoursController.focusNode.requestFocus();
    secsController.onEditingComplete = () {
      if (hoursController.onChangedValueMayProceed.value) {
        pageController.nextPage();
      }
    };
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: height * .05),
                child: const Text(
                  'Qual é a duração de cada virada?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'DancingScript'
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: const TimePicker()
              ),
              Container(
                margin: const EdgeInsets.only(right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Obx(() => IconButton(
                      onPressed: () {
                        if (hoursController.onChangedValueMayProceed.value) {
                          pageController.nextPage();
                        }
                      }, 
                      icon: Icon(
                        Icons.arrow_circle_right_rounded,
                        color: hoursController.onChangedValueMayProceed.value ? Colors.pink : Colors.grey,
                        size: 50,
                      )
                    ))
                  ],
                ),
              ),
              const SizedBox(height: 50)
            ],
          ),
      ),
    );
  }
}
