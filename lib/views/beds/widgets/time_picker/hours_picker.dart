import 'package:agendador_bronzeamento/utils/validator.dart';
import 'package:agendador_bronzeamento/views/beds/screens/bed_details.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/mins_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/secs_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HoursPickerController extends GetxController {
  final TextEditingController hours = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final RxBool onChangedValueMayProceed = false.obs;
  Function()? onEditingComplete;

  void updateOnChangedValueMayProceed() {
    bool mayProceed;
    if (hours.text.isEmpty) {
      mayProceed = false;
    } else {
      final MinsPickerController minsController = Get.find();
      final SecsPickerController secsController = Get.find();
      if (minsController.mins.text.isEmpty || secsController.secs.text.isEmpty) {
        mayProceed = false;
      } else {
        try {
          int hoursInt = int.parse(hours.text), minsInt = int.parse(minsController.mins.text), secsInt = int.parse(secsController.secs.text);
          mayProceed = hoursInt + minsInt + secsInt > 0;
        } catch(err) {
          mayProceed = false;
        }
      }
    }
    onChangedValueMayProceed.value = mayProceed;
  }
}

class HoursPicker extends StatelessWidget {
  const HoursPicker({super.key});

  @override
  Widget build(BuildContext context) {
    BedDetailsController? bedController;
    try {
      bedController = Get.find<BedDetailsController>();
    } catch(err) { /** Do nothing */ }
    final HoursPickerController hoursController = Get.find();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Center(
      child: SizedBox(
        width: width * .2,
        height: height * 0.07,
        child: Center(
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: hoursController.hours,
                  onChanged: (value) {
                    String valStr;
                    if (Validator.isInteger(value) && int.parse(value) < 24) {
                      valStr = int.parse(value).toString();
                    } else {
                      valStr = '';
                    }
                    hoursController.hours.text = valStr;
                    hoursController.updateOnChangedValueMayProceed();
                    if (bedController != null) bedController.checkValues();
                  },
                  onEditingComplete: hoursController.onEditingComplete,
                  focusNode: hoursController.focusNode,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Hrs',
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
