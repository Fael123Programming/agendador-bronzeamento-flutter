import 'package:agendador_bronzeamento/views/beds/widgets/bed_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBed extends StatelessWidget {
  const SearchBed({super.key});

  @override
  Widget build(context) {
    final BedCardListController bedCardListController = Get.find();
    RxList<BedCard> filtered = <BedCard>[].obs;
    return Scaffold(
        appBar: AppBar(
          title: Container(
            height: 40,
            width: 290,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(left: 5),
            decoration: const BoxDecoration(
                color: Color.fromARGB(150, 231, 231, 231),
                borderRadius: BorderRadius.all(Radius.circular(30))
            ),
            child: TextField(
              onChanged: (String s) {
                filtered.clear();
                if (s.isNotEmpty) {
                  filtered.addAll(
                    bedCardListController.list.where(
                          (bedCard) => bedCard.bedCardController.client.name.toLowerCase().contains(
                        s.toLowerCase(),
                      ),
                    ),
                  );
                }
              },
              autofocus: true,
              cursorColor: Colors.black,
              style: const TextStyle(
                color: Colors.black,
              ),
              textInputAction: TextInputAction.search,
              textAlign: TextAlign.left,
              textAlignVertical: TextAlignVertical.center,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(10),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: 'Pesquisar Maca',
                hintStyle: TextStyle(
                    color: Color.fromARGB(180, 0, 0, 0),
                    fontWeight: FontWeight.normal
                ),
              ),
            ),
          ),
        ),
        body: Obx(() {
            if (filtered.isEmpty) {
              return Container();
            }
            // Keep the ListView always up-to-date.
            List<BedCard> localBedList = <BedCard>[];
            for (final bedCard in filtered.toList()) {
              if (bedCardListController.list.contains(bedCard)) {
                localBedList.add(bedCard);
              }
            }
            filtered.value = localBedList;
            return ListView(
                padding: const EdgeInsets.only(bottom: 50),
                children: filtered.toList()
            );
          }
        )
    );
  }
}