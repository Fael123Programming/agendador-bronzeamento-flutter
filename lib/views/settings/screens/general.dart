import 'package:agendador_bronzeamento/database/models/config.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/price_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/hours_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/mins_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/secs_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/time_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/turn_around_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nice_buttons/nice_buttons.dart';

class General extends StatelessWidget {
  const General({super.key});

  @override
  Widget build(BuildContext context) {
    const divider = Divider(
      height: 80,
      indent: 100,
      endIndent: 100,
      color: Colors.pink,
      thickness: 2,
    );
    final ConfigController configController = Get.find();
    final TurnAroundInputController turnController = Get.put(TurnAroundInputController());
    turnController.turnAround.text = configController.config.value.turnArounds;
    final SecsPickerController secsController = Get.put(SecsPickerController());
    secsController.secs.text = configController.config.value.defaultSecs;
    final MinsPickerController minsController = Get.put(MinsPickerController());
    minsController.mins.text = configController.config.value.defaultMins;
    minsController.onEditingComplete = () => secsController.focusNode.requestFocus();
    final HoursPickerController hoursController = Get.put(HoursPickerController());
    hoursController.hours.text = configController.config.value.defaultHours;
    hoursController.onEditingComplete = () => minsController.focusNode.requestFocus();
    final priceController = Get.put(PricePickerController());
    priceController.price.text = configController.config.value.defaultPrice;
    return PopScope(
        onPopInvoked: (didPop) {
          secsController.focusNode.dispose();
          minsController.focusNode.dispose();
          hoursController.focusNode.dispose();
          Get.delete<PricePickerController>();
          Get.delete<HoursPickerController>();
          Get.delete<MinsPickerController>();
          Get.delete<SecsPickerController>();
          Get.delete<TurnAroundInputController>();
        },
        child: Scaffold(
        appBar: AppBar(
          title: const Text(''),
        ),
        body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                divider,
                Container(
                  margin: const EdgeInsets.only(left: 20, bottom: 20),
                  child: const Text(
                      'Viradas Padrão:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  ),
                ),
                const TurnAroundInput(),
                divider,
                Container(
                  margin: const EdgeInsets.only(left: 20, bottom: 20),
                  child: const Text(
                      'Duração Padrão:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  ),
                ),
                const TimePicker(),
                divider,
                Container(
                  margin: const EdgeInsets.only(left: 20, bottom: 20),
                  child: const Text(
                    'Preço Padrão:',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    ),
                  ),
                ),
                const PricePicker(),
                divider,
                Center(
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
                          turnController.isValid() &&
                          isValidDuration() &&
                          priceController.isValid()
                      ) {
                        // await Future.delayed(const Duration(seconds: 1));
                        await configController.updateConfig(
                          turnArounds: turnController.turnAround.text,
                          hours: hoursController.hours.text,
                          mins: minsController.mins.text,
                          secs: secsController.secs.text,
                          price: priceController.price.text
                        );
                        await configController.fetchConfig();
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
                const SizedBox(height: 50)
              ],
            ),
        ),
      )
    );
  }
}
