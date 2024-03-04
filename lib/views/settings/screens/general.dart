import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/time_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/turn_around_input.dart';
import 'package:flutter/material.dart';

class General extends StatelessWidget {
  const General({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerais'),
      ),
      body: Center(child: Text('I LOVE YOU JESUS'),),
      // body: GestureDetector(
      //   onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      //   child: SingleChildScrollView(
      //     child: Column(
      //       // mainAxisAlignment: MainAxisAlignment.start,
      //       // crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         Container(
      //           decoration: BoxDecoration(
      //             color: Colors.pink[50],
      //             border: Border.all(
      //               color: Colors.pink,
      //             ),
      //             borderRadius: const BorderRadius.all(Radius.circular(30)),
      //           ),
      //           padding: const EdgeInsets.all(15),
      //           margin: const EdgeInsets.all(15),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               Container(
      //                 margin: const EdgeInsets.all(15),
      //                 child: const Text(
      //                   'Viradas:',
      //                   style: TextStyle(
      //                     fontWeight: FontWeight.bold,
      //                     fontSize: 28,
      //                   ),
      //                 ),
      //               ),
      //               const TurnAroundInput(),
      //             ],
      //           ),
      //         ),
      //         SizedBox.expand(
      //           child: Row(
      //             children: [
      //               Container(
      //                 decoration: BoxDecoration(
      //                   color: Colors.pink[50],
      //                   border: Border.all(
      //                     color: Colors.pink,
      //                   ),
      //                   borderRadius:
      //                       const BorderRadius.all(Radius.circular(30)),
      //                 ),
      //                 padding: const EdgeInsets.all(15),
      //                 margin: const EdgeInsets.all(15),
      //                 child: const Text(
      //                   'Duração:',
      //                   style: TextStyle(
      //                     fontWeight: FontWeight.bold,
      //                     fontSize: 28,
      //                   ),
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //         const TimePicker(),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
