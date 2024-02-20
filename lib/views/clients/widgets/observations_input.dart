import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ObservationsInputController extends GetxController {
  final FocusNode focusNode = FocusNode();
  Function()? onEditingComplete;
  final TextEditingController observations = TextEditingController();
  String? hintText;
  IconData? icon;

  ObservationsInputController({this.onEditingComplete, this.hintText, this.icon});
}

class ObservationsInput extends StatelessWidget {
  const ObservationsInput({super.key});

  @override
  Widget build(BuildContext context) {
    final ObservationsInputController observationsController = Get.find();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.8,
      height: height * 0.2,
      padding: EdgeInsets.all(width * 0.03),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      child: Row(
        children: <Widget>[
          Column(
            children: [
              Icon(
                observationsController.icon,
                color: Colors.grey,
              ),
            ],
          ),
          SizedBox(
            width: width * 0.04,
          ),
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.text,
              maxLines: 5,
              maxLength: 130,
              onEditingComplete: observationsController.onEditingComplete,
              focusNode: observationsController.focusNode,
              controller: observationsController.observations,
              // autofocus: true,
              decoration: InputDecoration.collapsed(
                hintText: observationsController.hintText,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
