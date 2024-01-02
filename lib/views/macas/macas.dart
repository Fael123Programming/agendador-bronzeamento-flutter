import 'package:flutter/material.dart';
import 'components/item_widget.dart';

class Macas extends StatefulWidget {
  const Macas({super.key});

  @override
  State<Macas> createState() => _MacasState();
}

class _MacasState extends State<Macas> {
  int items = 14;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LayoutBuilder(
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
                    children: List.generate(
                      items,
                      (index) => ItemWidget(
                        text: 'Maca ${index + 1}',
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        foregroundColor: Colors.white,
        backgroundColor: Colors.pink,
        child: const Icon(Icons.add),
      ),
    );
  }
}
