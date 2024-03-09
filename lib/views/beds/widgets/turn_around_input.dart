import 'package:agendador_bronzeamento/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TurnAroundInputController extends GetxController {
  final TextEditingController turnAround = TextEditingController();
  final FocusNode focusNode = FocusNode();
  Function()? onEditingComplete;

  bool isValid() {
    String turn = turnAround.text;
    return turn.isNum && int.parse(turn) > 0;
  }
}

class TurnAroundInput extends StatelessWidget {
  const TurnAroundInput({super.key});

  @override
  Widget build(context) {
    final TurnAroundInputController turnAroundController = Get.find();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
                    if (value.isNotEmpty) {
                      if (!Validator.isInteger(value)) {
                        turnAroundController.turnAround.text = '';
                      } else if (int.parse(value) < 1 || int.parse(value) > 4) {
                        turnAroundController.turnAround.text = '';
                      }
                    }
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
