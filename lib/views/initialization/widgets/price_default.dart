import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:agendador_bronzeamento/database/database_helper.dart';
import 'package:agendador_bronzeamento/database/models/config.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/price_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/hours_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/mins_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/secs_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/turn_around_input.dart';
import 'package:agendador_bronzeamento/views/initialization/screens/set_default_values.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PriceDefault extends StatelessWidget {
  const PriceDefault({super.key});
  
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final ConfigController configController = Get.find();
    final TurnAroundInputController turnController = Get.find();
    final HoursPickerController hoursController = Get.find();
    final MinsPickerController minsController = Get.find();
    final SecsPickerController secsController = Get.find();
    final PricePickerController priceController = Get.find();
    priceController.focusNode.requestFocus();
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
                'Defina o preço padrão para os bronzes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'DancingScript'
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: const PricePicker()
            ),
            Container(
              margin: const EdgeInsets.only(right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(() => IconButton(
                    onPressed: () async {
                      if (priceController.onChangedValueMayProceed.value) {
                        await DatabaseHelper().insertConfig(
                          Config.toSave(
                            defaultHours: int.parse(hoursController.hours.text), 
                            defaultMins: int.parse(minsController.mins.text), 
                            defaultSecs: int.parse(secsController.secs.text), 
                            turnArounds: int.parse(turnController.turnAround.text), 
                            price: priceController.price.text
                          )
                        );
                        await configController.fetch();
                        Get.delete<SecsPickerController>();
                        Get.delete<MinsPickerController>();
                        Get.delete<HoursPickerController>();
                        Get.delete<PageViewController>();
                        Get.delete<TurnAroundInputController>();
                        Get.delete<PricePickerController>();
                        if (!context.mounted) {
                          return;
                        }
                        Navigator.pushReplacementNamed(context, RoutePaths.splash);
                      }
                    }, 
                    icon: Icon(
                      Icons.arrow_circle_right,
                      color: priceController.onChangedValueMayProceed.value ? Colors.pink : Colors.grey,
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