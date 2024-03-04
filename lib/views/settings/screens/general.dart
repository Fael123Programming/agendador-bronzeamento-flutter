import 'package:agendador_bronzeamento/models/config.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/price_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/hours_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/mins_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/secs_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/time_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/turn_around_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    final configController = Get.put(ConfigController());
    final turnController = Get.put(TurnAroundInputController());
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
    return Scaffold(
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
              divider
            ],
          ),
      ),
    );
  }
}
