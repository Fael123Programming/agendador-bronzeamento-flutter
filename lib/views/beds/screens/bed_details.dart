import 'package:agendador_bronzeamento/views/beds/widgets/bed_card.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/price_picker.dart';
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

bool isValidDuration() {
  final HoursPickerController hours = Get.find();
  final MinsPickerController mins = Get.find();
  final SecsPickerController secs = Get.find();

  int hoursInt = int.parse(hours.hours.text);
  int minsInt = int.parse(mins.mins.text);
  int secsInt = int.parse(secs.secs.text);

  return hoursInt + minsInt + secsInt > 0;
}

class BedDetails extends StatelessWidget {
  final Map<dynamic, dynamic>? bedData;

  const BedDetails({super.key, this.bedData});

  final separator = const SizedBox(height: 50);

  @override
  Widget build(context) {
    final ConfigController configController = Get.find();
    final BedCardListController bedCardListController = Get.find();

    final PricePickerController priceController = Get.put(PricePickerController());
    priceController.onEditingComplete = () => priceController.focusNode.unfocus();

    final SecsPickerController secsController = Get.put(SecsPickerController());
    secsController.onEditingComplete = () => priceController.focusNode.requestFocus();

    final MinsPickerController minsController = Get.put(MinsPickerController());
    minsController.onEditingComplete = () => secsController.focusNode.requestFocus();

    final HoursPickerController hoursController = Get.put(HoursPickerController());
    hoursController.onEditingComplete = () => minsController.focusNode.requestFocus();
    
    final TurnAroundInputController turnController = Get.put(TurnAroundInputController());
    turnController.onEditingComplete = () => hoursController.focusNode.requestFocus();
    
    final SearchClientInputController searchController = Get.put(SearchClientInputController());
    searchController.onEditingComplete = () {
      turnController.turnAround.text = configController.config.value.turnArounds;
      hoursController.hours.text = configController.config.value.defaultHours;
      minsController.mins.text = configController.config.value.defaultMins;
      secsController.secs.text = configController.config.value.defaultSecs;
      priceController.price.text = configController.config.value.defaultPrice;
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
        priceController.focusNode.dispose();
        Get.delete<SearchClientInputController>();
        Get.delete<TurnAroundInputController>();
        Get.delete<HoursPickerController>();
        Get.delete<MinsPickerController>();
        Get.delete<SecsPickerController>();
        Get.delete<PricePickerController>();
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
                          separator,
                          const TurnAroundInput(),
                          separator,
                          const TimePicker(),
                          separator,
                          const PricePicker(),
                          separator,
                          NiceButtons(
                            startColor: Colors.pink,
                            endColor: Colors.pink,
                            borderColor: Colors.pink,
                            stretch: false,
                            progress: false,
                            gradientOrientation: GradientOrientation.Horizontal,
                            onTap: (finish) async {
                              finish();
                              if (
                                searchController.chosen.value &&
                                turnController.isValid() &&
                                isValidDuration()
                              ) {
                                int secs = int.parse(hoursController.hours.text) * 3600 + int.parse(minsController.mins.text) * 60 + int.parse(secsController.secs.text);
                                BedCardController bedCardController = BedCardController(
                                  clientName: searchController.controller.text,
                                  price: priceController.price.text,
                                  totalSecs: secs,
                                  remainingSecs: secs,
                                  totalTurns: int.parse(turnController.turnAround.text),
                                  turnsDone: 0.obs
                                );
                                BedCard bedCard = BedCard(
                                  bedCardController: bedCardController,
                                  bedNumber: bedCardListController.list.length + 1,
                                );
                                bedCardListController.list.add(bedCard);
                                bedCardController.startTimer();
                                await Future.delayed(const Duration(seconds: 1));
                                if (!context.mounted) {
                                  return;
                                }
                                Navigator.of(context).pop();
                              } else {
                                Get.showSnackbar(
                                  const GetSnackBar(
                                    title: 'Humm... Algum Dado está Incorreto',
                                    message: 'Por favor, selecione uma cliente, defina quantas viradas e a duração',
                                    duration: twoSeconds,
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
                    ),
                    separator
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
