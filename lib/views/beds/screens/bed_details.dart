import 'package:agendador_bronzeamento/views/beds/widgets/search_client_input.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/hours_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/mins_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/secs_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/time_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/turn_around_input.dart';
import 'package:flutter/material.dart';
import 'package:nice_buttons/nice_buttons.dart';
import 'package:get/get.dart';
import 'package:agendador_bronzeamento/models/config.dart';
import 'package:agendador_bronzeamento/utils/loading.dart';

class BedDetails extends StatelessWidget {
  final Map<dynamic, dynamic>? bedData;

  const BedDetails({super.key, this.bedData});

  @override
  Widget build(context) {
    final ConfigController configController = Get.find();
    
    final SecsPickerController secsController = Get.put(SecsPickerController());
    secsController.onEditingComplete = () {
      secsController.focusNode.unfocus();
    };
    // secsController.onEditingComplete = () {
    //   secsController.focusNode.unfocus();
    //   Duration duration = Duration(
    //     hours: int.parse(hoursController.hours.text),
    //     minutes: int.parse(minsController.mins.text),
    //     seconds: int.parse(secsController.secs.text),
    //   );
    //   if (duration.inSeconds == 0) {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('Tempo não pode ser zero'),
    //         duration: twoSeconds,
    //       ),
    //     );
    //     hoursController.hours.text = configController.config!.value.defaultHours;
    //     minsController.mins.text = configController.config!.value.defaultMins;
    //     secsController.secs.text = configController.config!.value.defaultSecs;
    //   }
    // };

    final MinsPickerController minsController = Get.put(MinsPickerController());
    minsController.onEditingComplete = () => secsController.focusNode.requestFocus();

    final HoursPickerController hoursController = Get.put(HoursPickerController());
    hoursController.onEditingComplete = () => minsController.focusNode.requestFocus();
    
    final TurnAroundInputController turnController = Get.put(TurnAroundInputController());
    turnController.onEditingComplete = () => hoursController.focusNode.requestFocus();
    
    final SearchClientInputController searchController = Get.put(SearchClientInputController());
    searchController.onEditingComplete = () {
      turnController.turnAround.text = configController.config!.value.turnArounds;
      hoursController.hours.text = configController.config!.value.defaultHours;
      minsController.mins.text = configController.config!.value.defaultMins;
      secsController.secs.text = configController.config!.value.defaultSecs;
    };

    final formKey = GlobalKey<FormState>();

    const twoSeconds = Duration(seconds: 2);

    return PopScope(
      onPopInvoked: (didPop) {
        searchController.focusNode.dispose();
        turnController.focusNode.dispose();
        hoursController.focusNode.dispose();
        minsController.focusNode.dispose();
        secsController.focusNode.dispose();
        Get.delete<SearchClientInputController>();
        Get.delete<TurnAroundInputController>();
        Get.delete<HoursPickerController>();
        Get.delete<MinsPickerController>();
        Get.delete<SecsPickerController>();
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Obx(() {
          if (configController.loaded.value) {
            return GestureDetector(
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
                          const SearchClientInput(),
                          const SizedBox(
                            height: 50,
                          ),
                          const TurnAroundInput(),
                          const SizedBox(
                            height: 50,
                          ),
                          const TimePicker(),
                          const SizedBox(
                            height: 50,
                          ),
                          NiceButtons(
                            startColor: Colors.pink,
                            endColor: Colors.pink,
                            borderColor: Colors.pink,
                            stretch: false,
                            progress: false,
                            gradientOrientation: GradientOrientation.Horizontal,
                            onTap: (finish) {
                              finish();
                              if (searchController.chosen.value) {
                                Get.showSnackbar(
                                  const GetSnackBar(
                                    title: 'Maca adicionada com sucesso!',
                                    messageText: Text(''),
                                    duration: Duration(seconds: 1),
                                    backgroundColor: Colors.pink,
                                  )
                                );
                                Navigator.pop(context);
                              } else {
                                Get.showSnackbar(
                                  const GetSnackBar(
                                    title: 'Cliente não Selecionada',
                                    message: 'Por favor, selecione uma cliente',
                                    duration: twoSeconds,
                                    // backgroundColor: Color.fromARGB(255, 255, 17, 0),
                                    backgroundColor: Color.fromARGB(255, 255, 17, 0),
                                  )
                                );
                              }
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
            );
          } else {
            return const Loading();
          }
        }),
      ),
    );
  }
}
