import 'package:agendador_bronzeamento/utils/validator.dart';
import 'package:agendador_bronzeamento/views/beds/screens/bed_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TurnAroundInputController extends GetxController {
  final TextEditingController turnAround = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final RxBool onChangedValueMayProceed = false.obs;
  Function()? onEditingComplete;

  bool isValid() => turnAround.text.isNum && int.parse(turnAround.text) > 0;

  void updateOnChangedValueMayProceed(String value) {
    onChangedValueMayProceed.value = value.isNotEmpty && Validator.isInteger(value) && int.parse(value) > 0 && int.parse(value) < 5;
  }
}

class TurnAroundInput extends StatelessWidget {
  const TurnAroundInput({super.key});

  @override
  Widget build(context) {
    BedDetailsController? bedController;
    try {
      bedController = Get.find<BedDetailsController>();
    } catch(err) {/** Do nothing */ }
    final TurnAroundInputController turnAroundController = Get.find();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Center(
      child: Container(
        width: width * 0.8,
        height: height * 0.07,
        padding: EdgeInsets.all(width * 0.03),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Center(
          child: Row(
            children: <Widget>[
              const Icon(
                Icons.u_turn_left,
                color: Colors.grey,
              ),
              SizedBox(
                width: width * 0.04,
              ),
              Expanded(
                child: TextFormField(
                  controller: turnAroundController.turnAround,
                  textAlign: TextAlign.start,
                  onChanged: (value) {
                    turnAroundController.updateOnChangedValueMayProceed(value);
                    if (value.isNotEmpty) {
                      if (!Validator.isInteger(value) || int.parse(value) < 1 || int.parse(value) > 4 && int.parse(value) < 10) {
                        turnAroundController.turnAround.text = '';
                      } else {
                        turnAroundController.turnAround.text = value[0];
                        turnAroundController.updateOnChangedValueMayProceed(turnAroundController.turnAround.text);
                      }
                    }
                    if (bedController != null) bedController.checkValues();
                  },
                  onEditingComplete: turnAroundController.onEditingComplete,
                  focusNode: turnAroundController.focusNode,
                  keyboardType: TextInputType.number,
                  keyboardAppearance: Brightness.light,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Viradas',
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
