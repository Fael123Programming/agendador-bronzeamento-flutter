import 'package:flutter/material.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/hours_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/mins_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/secs_picker.dart';

class TimePicker extends StatelessWidget {  
  const TimePicker({super.key});
  
  final collonBox = const SizedBox(
    child: Text(
      ':',
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  @override
  Widget build(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.timer,
          color: Colors.pink,
          size: 25,
        ),
        const HoursPicker(),
        collonBox,
        const MinsPicker(),
        collonBox,
        const SecsPicker(),
      ],
    );
  }
}
