import 'package:agendador_bronzeamento/views/beds/widgets/search_client_input.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/time_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/turn_around_input.dart';
import 'package:flutter/material.dart';
import 'package:nice_buttons/nice_buttons.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:agendador_bronzeamento/models/config.dart';

class BedDetails extends StatelessWidget {
  final Map<dynamic, dynamic>? bedData;

  const BedDetails({super.key, this.bedData});

  @override
  Widget build(context) {
    final ConfigController configController = Get.put(ConfigController());

    final formKey = GlobalKey<FormState>();
    final searchClientInputController = TextEditingController();
    final FocusNode searchClientInputFocusNode = FocusNode(),
        turnAroundFocusNode = FocusNode(),
        timePickerFocusNode = FocusNode();
    final hoursController = TextEditingController();
    final minsController = TextEditingController();
    final secsController = TextEditingController();
    Duration duration = const Duration();
    
    if (configController.isDataLoaded()) {
      final TurnAroundInputController turnController = Get.put(TurnAroundInputController());
      
      return PopScope(
        child: Scaffold(
          appBar: AppBar(),
          body: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.pink[50],
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                    ),
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(
                      bottom: 50,
                    ),
                    child: Image.asset(
                      'assets/beach-chair.png',
                      width: 150,
                      height: 150,
                      color: Colors.pink,
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        SearchClientInput(
                          controller: searchClientInputController,
                          focusNode: searchClientInputFocusNode,
                          onEditingComplete: () {
                            turnController.text = configController.configData!.value.turnArounds.obs;
                            // setState(() {
                            //   turnAroundInputController.text =
                            //       defaultTurnAroundNumber;
                            //   hoursController.text = defaultHours;
                            //   minsController.text = defaultMins;
                            //   secsController.text = defaultSecs;
                            // });
                          },
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        TurnAroundInput(
                          focusNode: turnAroundFocusNode,
                          onEditingComplete: () =>
                              timePickerFocusNode.requestFocus(),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        TimePicker(
                          hourFocusNode: timePickerFocusNode,
                          onEditingComplete: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            Duration duration = Duration(
                              hours: int.parse(hoursController.text),
                              minutes: int.parse(minsController.text),
                              seconds: int.parse(secsController.text),
                            );
                            if (duration.inSeconds == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Tempo não pode ser zero'),
                                  duration: Duration(
                                    seconds: 2,
                                  ),
                                ),
                              );
                              // setState(() {
                              //   hoursController.text = defaultHours;
                              //   minsController.text = defaultMins;
                              //   secsController.text = defaultSecs;
                              // });
                            }
                          },
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        NiceButtons(
                          startColor: Colors.pink,
                          endColor: Colors.pink,
                          borderColor: Colors.pink,
                          stretch: false,
                          progress: true,
                          gradientOrientation: GradientOrientation.Horizontal,
                          onTap: (finish) {
                            // print('On tap called');
                            Timer(const Duration(seconds: 2), () {
                              finish();
                              // print('Finish');
                              Navigator.pop(context);
                            });
                          },
                          child: Text(
                            bedData == null ? 'Adicionar' : 'Salvar',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator(),);
    }
  }
}
