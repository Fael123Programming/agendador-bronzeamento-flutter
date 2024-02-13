import 'package:agendador_bronzeamento/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TurnAroundInputController extends GetxController {
  RxString text = ''.obs;
}

class TurnAroundInput extends StatelessWidget {
  final FocusNode? focusNode;
  final Function()? onEditingComplete;

  const TurnAroundInput({super.key, this.focusNode, this.onEditingComplete});

  @override
  Widget build(context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    final TurnAroundInputController textController = Get.find();
    return Center(
      child: Container(
        width: width * 0.4,
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
                  initialValue: textController.text.value,
                  textAlign: TextAlign.start,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      bool invalidValue = false;
                      if (!Validator.isInteger(value)) {
                        textController.text = ''.obs;
                        invalidValue = true;
                      } else if (int.parse(value) < 1) {
                        textController.text = ''.obs;
                        invalidValue = true;
                      }
                      if (invalidValue) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Número de viradas inválido'),
                            duration: Duration(
                              seconds: 2,
                            ),
                          ),
                        );
                      }
                    }
                  },
                  onEditingComplete: onEditingComplete,
                  focusNode: focusNode,
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
