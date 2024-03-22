import 'package:agendador_bronzeamento/database/models/config.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/hours_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/mins_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/secs_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nice_buttons/nice_buttons.dart';

class ChangeDuration extends StatelessWidget {
  const ChangeDuration({super.key});

  @override
  Widget build(BuildContext context) {
    final ConfigController configController = Get.find();
    final SecsPickerController secsController = Get.put(SecsPickerController());
    (() async => secsController.secs.text = (await configController.config).defaultSecs.toString())();
    final MinsPickerController minsController = Get.put(MinsPickerController());
    (() async => minsController.mins.text = (await configController.config).defaultMins.toString())();
    minsController.onEditingComplete = () => secsController.focusNode.requestFocus();
    final HoursPickerController hoursController = Get.put(HoursPickerController());
    (() async => hoursController.hours.text = (await configController.config).defaultHours.toString())();
    hoursController.onEditingComplete = () => minsController.focusNode.requestFocus();
    minsController.focusNode.requestFocus();
    hoursController.onChangedValueMayProceed.value = true;
    return PopScope(
        onPopInvoked: (didPop) {
          secsController.focusNode.dispose();
          minsController.focusNode.dispose();
          hoursController.focusNode.dispose();
          Get.delete<HoursPickerController>();
          Get.delete<MinsPickerController>();
          Get.delete<SecsPickerController>();
        },
        child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Duração',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'DancingScript'
            ),
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: const TimePicker()
                  ),
                  Obx(() => Container(
                    margin: const EdgeInsets.only(top: 40),
                    child: Center(
                      child: NiceButtons(
                        startColor: hoursController.onChangedValueMayProceed.value ? Colors.pink : Colors.grey,
                        endColor: hoursController.onChangedValueMayProceed.value ? Colors.pink : Colors.grey,
                        borderColor: hoursController.onChangedValueMayProceed.value ? Colors.pink : Colors.grey,
                        stretch: false,
                        progress: false,
                        disabled: !hoursController.onChangedValueMayProceed.value,
                        gradientOrientation: GradientOrientation.Horizontal,
                        onTap: (finish) async {
                          finish();
                          if (!isValidDuration()) {
                            return;
                          }
                          // await Future.delayed(const Duration(seconds: 1));
                          await configController.updateDefaultHours(int.parse(hoursController.hours.text));
                          await configController.updateDefaultMins(int.parse(minsController.mins.text));
                          await configController.updateDefaultSecs(int.parse(secsController.secs.text));
                          if (!context.mounted) {
                            return;
                          }
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Atualizar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  )),
                  const SizedBox(height: 50)
                ],
              ),
          ),
        ),
      )
    );
  }
}
