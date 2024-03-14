import 'package:agendador_bronzeamento/config/config.dart';
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
    secsController.secs.text = configController.getDefaultSecs();
    final MinsPickerController minsController = Get.put(MinsPickerController());
    minsController.mins.text = configController.getDefaultMins();
    minsController.onEditingComplete = () => secsController.focusNode.requestFocus();
    final HoursPickerController hoursController = Get.put(HoursPickerController());
    hoursController.hours.text = configController.getDefaultHours();
    hoursController.onEditingComplete = () => minsController.focusNode.requestFocus();
    minsController.focusNode.requestFocus();
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
                  Container(
                    margin: const EdgeInsets.only(top: 40),
                    child: Center(
                      child: NiceButtons(
                        startColor: Colors.pink,
                        endColor: Colors.pink,
                        borderColor: Colors.pink,
                        stretch: false,
                        progress: false,
                        gradientOrientation: GradientOrientation.Horizontal,
                        onTap: (finish) async {
                          finish();
                          if (
                              isValidDuration()
                          ) {
                            // await Future.delayed(const Duration(seconds: 1));
                            await configController.setDefaultHours(hoursController.hours.text);
                            await configController.setDefaultMins(minsController.mins.text);
                            await configController.setDefaultSecs(secsController.secs.text);
                            if (!context.mounted) {
                              return;
                            }
                            Navigator.of(context).pop();
                          } else {
                            Get.showSnackbar(
                              const GetSnackBar(
                                title: 'Humm... Algum Dado está Incorreto',
                                message: 'Por favor, verifique os valores padrão e tente novamente!',
                                duration: Duration(seconds: 2),
                                backgroundColor: Color.fromARGB(255, 255, 17, 0),
                              )
                            );
                          }
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
                  ),
                  const SizedBox(height: 50)
                ],
              ),
          ),
        ),
      )
    );
  }
}
