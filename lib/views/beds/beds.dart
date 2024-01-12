import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:agendador_bronzeamento/views/beds/service/bed_card_service.dart';
import 'package:flutter/material.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/bed_card.dart';

class Beds extends StatefulWidget {
  const Beds({super.key});

  @override
  State<Beds> createState() => _BedsState();
}

class _BedsState extends State<Beds> {
  List<BedCard>? bedCards;

  @override
  void initState() {
    super.initState();
    getBedCardList();
  }

  getBedCardList() {
    bedCards = BedCardService.fetchBedCards();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: bedCards == null || bedCards!.isEmpty
            ? Container()
            : const Text('Macas'),
      ),
      body: Center(
        child: bedCards == null || bedCards!.isEmpty
            ? const Text(
                'Sem clientes\nem macas',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              )
            : LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: SafeArea(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List.from(bedCards!),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, RoutePaths.bedDetails),
        foregroundColor: Colors.white,
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
      ),
    );
  }
}
