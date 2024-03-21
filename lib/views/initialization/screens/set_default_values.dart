import 'package:agendador_bronzeamento/animation/rotating_sun.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/price_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/hours_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/turn_around_input.dart';
import 'package:agendador_bronzeamento/views/initialization/widgets/duration_default.dart';
import 'package:agendador_bronzeamento/views/initialization/widgets/price_default.dart';
import 'package:agendador_bronzeamento/views/initialization/widgets/turn_arounds_default.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PageViewController extends GetxController {
  final PageController _controller = PageController();
  final RxInt _selected = 0.obs;
  final List<Widget> _pages = <Widget>[
    const TurnAroundsDefault(),
    const DurationDefault(),
    const PriceDefault()
  ];

  int get selected => _selected.value;

  List<Widget> get pages => _pages;

  PageController get controller => _controller;

  void nextPage() {
    _selected.value = (_selected.value + 1) % _pages.length;
    _controller.animateToPage(
      _selected.value, 
      duration: const Duration(seconds: 1), 
      curve: Curves.easeInOut
    );
  }

  void toPageByIndex(int pageIndex) {
    _selected.value = pageIndex;
    _controller.jumpToPage(pageIndex);
  }
}

class SetDefaultValues extends StatelessWidget {
  const SetDefaultValues({super.key});

  @override
  Widget build(BuildContext context) {
    final PageViewController pageController = Get.put(PageViewController());
    final HoursPickerController hoursController = Get.put(HoursPickerController());
    final TurnAroundInputController turnController = Get.put(TurnAroundInputController());
    final PricePickerController priceController = Get.put(PricePickerController());
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    turnController.turnAround.text = '4';
    turnController.updateOnChangedValueMayProceed(turnController.turnAround.text);
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.dispose(),
          child: PageView(
            controller: pageController.controller,
            children: pageController.pages,
            // onPageChanged: (index) => pageController.toPageByIndex(index)
          ),
        ),
        bottomNavigationBar: SizedBox(
          width: width,
          height: height * .7,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BottomNavigationBar(
                  elevation: 0,
                  onTap: (index) {
                    final selected = pageController.selected;
                    bool mayChange = false;
                    if (selected != index) {
                      if (index == 0) {
                        mayChange = turnController.onChangedValueMayProceed.value;
                      } else if (index == 1) {
                        mayChange = hoursController.onChangedValueMayProceed.value;
                      } else {
                        mayChange = priceController.onChangedValueMayProceed.value;
                      }
                    }
                    if (mayChange) pageController.toPageByIndex(index);
                  },
                  items: pageController.pages.map((element) => 
                    BottomNavigationBarItem(
                      label: '',
                      icon: Obx(() => Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: const BorderRadius.all(Radius.circular(30)),
                          color: pageController.pages.indexOf(element) == pageController.selected ? Colors.pink : Colors.white,
                        ),
                        width: pageController.pages.indexOf(element) == pageController.selected ? 12 : 8,
                        height: pageController.pages.indexOf(element) == pageController.selected ? 12 : 8,
                    ) )
                    )
                  ).toList()
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 15),
                child: const Column(
                  children: [
                    RotatingSun(size: 24),
                    Text(
                      'Fabi Bronze',
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'DancingScript',
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
