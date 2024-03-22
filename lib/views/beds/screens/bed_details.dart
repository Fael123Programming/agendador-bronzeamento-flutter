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

class BedDetailsController extends GetxController {
  final RxBool validValues = false.obs;

  void checkValues() {
    final SearchClientInputController searchController = Get.find();
    final TurnAroundInputController turnController = Get.find();
    final PricePickerController priceController = Get.find();
    validValues.value = searchController.chosen.value && turnController.isValid() && isValidDuration() && priceController.isValid();
  }
}

class BedDetails extends StatelessWidget {
  const BedDetails({super.key});

  final _separator = const SizedBox(height: 50);

  @override
  Widget build(context) {
    final BedDetailsController bedDetailsController = Get.put(BedDetailsController());
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
      bedDetailsController.checkValues();
    };
    final formKey = GlobalKey<FormState>();
    final height = MediaQuery.of(context).size.height;
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
        Get.delete<BedDetailsController>();
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
                      Obx(() => Container(
                        margin: EdgeInsets.only(top: height * 0.08),
                        child: NiceButtons(
                        startColor: bedDetailsController.validValues.value ? Colors.pink : Colors.grey,
                        endColor: bedDetailsController.validValues.value ? Colors.pink : Colors.grey,
                        borderColor: bedDetailsController.validValues.value ? Colors.pink : Colors.grey,
                        stretch: false,
                        disabled: !bedDetailsController.validValues.value,
                        progress: false,
                        gradientOrientation: GradientOrientation.Horizontal,
                        onTap: (finish) async {
                          if (!bedDetailsController.validValues.value) {
                            return;
                          }

                          int secs = int.parse(hoursController.hours.text) * 3600 + int.parse(minsController.mins.text) * 60 + int.parse(secsController.secs.text);
                          Client client = clientController.findByName(searchController.controller.text)!;
                          BedCardController bedCardController = BedCardController(
                            client: client,
                            price: priceController.price.text,
                            totalSecs: secs,
                            remainingSecs: secs,
                            turnArounds: int.parse(turnController.turnAround.text),
                            turnsDone: 0.obs,
                            bedNumber: bedCardListController.list.isEmpty ? 1 : bedCardListController.list[bedCardListController.list.length - 1].bedCardController.bedNumber + 1,
                          );
                          BedCard bedCard = BedCard(bedCardController: bedCardController);
                          if (client.observations != null && client.observations!.isNotEmpty) {
                            Get.dialog(
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 40),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Material(
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 10),
                                              const Text(
                                                'Detalhes de Cliente',
                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 15),
                                              Text(
                                                'Cuidados a tomar baseado nas observações: ${client.observations}',
                                                textAlign: TextAlign.center,
                                              ),
                                              const SizedBox(height: 20),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                        minimumSize: const Size(0, 45),
                                                        backgroundColor: const Color.fromARGB(255, 0, 255, 8),
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        Get.back();
                                                        bedCardListController.list.add(bedCard);
                                                        bedCardController.startTimer();
                                                        // await Future.delayed(const Duration(seconds: 1));
                                                        if (!context.mounted) {
                                                          return;
                                                        }
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        'Ok',
                                                        style: TextStyle(color: Colors.white)
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            bedCardListController.list.add(bedCard);
                            bedCardController.startTimer();
                            // await Future.delayed(const Duration(seconds: 1));
                            if (!context.mounted) {
                              return;
                            }
                            Navigator.pop(context);
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
                      )),
                    ],
                  ),
                ),
                _separator
              ],
            ),
          ),
        )
      ),
    );
  }
}
