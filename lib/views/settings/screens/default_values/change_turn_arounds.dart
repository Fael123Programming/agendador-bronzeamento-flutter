import 'package:agendador_bronzeamento/database/models/config.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/turn_around_input.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nice_buttons/nice_buttons.dart';

class ChangeTurnArounds extends StatelessWidget {
  const ChangeTurnArounds({super.key});

  @override
  Widget build(BuildContext context) {
    final ConfigController configController = Get.find();
    final TurnAroundInputController turnController = Get.put(TurnAroundInputController());
    (() async => turnController.turnAround.text = (await configController.config).turnArounds.toString())();
    turnController.focusNode.requestFocus();
    turnController.onChangedValueMayProceed.value = true;
    return PopScope(
        onPopInvoked: (didPop) {
          turnController.focusNode.dispose();
          Get.delete<TurnAroundInputController>();
        },
        child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Viradas',
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
                    child: const TurnAroundInput()
                  ),
                  Obx(() => Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 40),
                      child: NiceButtons(
                        startColor: turnController.onChangedValueMayProceed.value ? Colors.pink : Colors.grey,
                        endColor: turnController.onChangedValueMayProceed.value ? Colors.pink : Colors.grey,
                        borderColor: turnController.onChangedValueMayProceed.value ? Colors.pink : Colors.grey,
                        stretch: false,
                        progress: false,
                        disabled: !turnController.onChangedValueMayProceed.value,
                        gradientOrientation: GradientOrientation.Horizontal,
                        onTap: (finish) async {
                          finish();
                          if (!turnController.isValid()) {
                            return;
                          }
                          // await Future.delayed(const Duration(seconds: 1));
                          await configController.updateTurnArounds(int.parse(turnController.turnAround.text));
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
