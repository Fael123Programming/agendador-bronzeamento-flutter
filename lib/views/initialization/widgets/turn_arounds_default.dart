import 'package:agendador_bronzeamento/views/beds/widgets/turn_around_input.dart';
import 'package:agendador_bronzeamento/views/initialization/screens/set_default_values.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TurnAroundsDefault extends StatelessWidget {
  const TurnAroundsDefault({super.key});
  
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final PageViewController pageController = Get.find();
    final TurnAroundInputController turnController = Get.find();
    turnController.focusNode.requestFocus();
    turnController.onEditingComplete = () {
      if (turnController.onChangedValueMayProceed.value) {
        pageController.nextPage();
        // pageController.animateToPage(
        //   ++pageController.selected.value, 
        //   duration: const Duration(seconds: 1), 
        //   curve: Curves.easeInOut
        // );
      }
    };
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
                'São quantas viradas em cada bronze?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'DancingScript'
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: const TurnAroundInput()
            ),
            Container(
              margin: const EdgeInsets.only(right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(() => IconButton(
                    onPressed: () {
                      if (turnController.onChangedValueMayProceed.value) {
                        pageController.nextPage();
                      }
                    },
                    icon: Icon(
                      Icons.arrow_circle_right_rounded,
                      color: turnController.onChangedValueMayProceed.value ? Colors.pink : Colors.grey,
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