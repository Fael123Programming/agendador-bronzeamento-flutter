import 'package:agendador_bronzeamento/database/models/client.dart';
import 'package:agendador_bronzeamento/database/models/config.dart';
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

class BedDetails extends StatelessWidget {
  const BedDetails({super.key});

  final separator = const SizedBox(height: 50);

  @override
  Widget build(context) {
    final ConfigController configController = Get.find();
    final BedCardListController bedCardListController = Get.find();
    final ClientController clientController = Get.find();

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
    searchController.onEditingComplete = () async {
      turnController.turnAround.text = (await configController.config).turnArounds.toString();
      hoursController.hours.text = (await configController.config).defaultHours.toString();
      minsController.mins.text = (await configController.config).defaultMins.toString();
      secsController.secs.text = (await configController.config).defaultSecs.toString();
      priceController.price.text = (await configController.config).price;
    };

    final formKey = GlobalKey<FormState>();

    const twoSeconds = Duration(seconds: 2);
    double height = MediaQuery.of(context).size.height;
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
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Adicionar Nova Maca', 
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        body: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 40),
                            child: const SearchClientInput()
                          ),
                          const TurnAroundInput(),
                          Container(
                            margin: EdgeInsets.only(top: height * 0.08),
                            child: const TimePicker()
                          ),
                          Container(
                            margin: EdgeInsets.only(top: height * 0.08),
                            child: const PricePicker()
                          ),
                          Container(
                            margin: EdgeInsets.only(top: height * 0.08),
                            child: NiceButtons(
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
                                  client: clientController.findByName(searchController.controller.text)!,
                                  price: priceController.price.text,
                                  totalSecs: secs,
                                  remainingSecs: secs,
                                  turnArounds: int.parse(turnController.turnAround.text),
                                  turnsDone: 0.obs,
                                  bedNumber: bedCardListController.list.isEmpty ? 1 : bedCardListController.list[bedCardListController.list.length - 1].bedCardController.bedNumber + 1,
                                );
                                BedCard bedCard = BedCard(bedCardController: bedCardController);
                                bedCardListController.list.add(bedCard);
                                bedCardController.startTimer();
                                // await Future.delayed(const Duration(seconds: 1));
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
                            child: const Text(
                              'Adicionar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          )
                          ),
                        ],
                      ),
                    ),
                    separator
                  ],
                ),
              ),
            )
        ),
    );
  }
}
