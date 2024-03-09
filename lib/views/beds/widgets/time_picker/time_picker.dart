import 'package:flutter/material.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/hours_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/mins_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/secs_picker.dart';
import 'package:get/get.dart';

bool isValidDuration() {
  final HoursPickerController hours = Get.find();
  final MinsPickerController mins = Get.find();
  final SecsPickerController secs = Get.find();
  try {
    int hoursInt = int.parse(hours.hours.text);
    int minsInt = int.parse(mins.mins.text);
    int secsInt = int.parse(secs.secs.text);
    return hoursInt + minsInt + secsInt > 0;
  } on FormatException {
    return false;
  }
}

class TimePicker extends StatelessWidget {  
  const TimePicker({super.key});
  
  final colonBox = const SizedBox(
    child: Text(
      ':',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  @override
  Widget build(context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Center(
      child: Container(
        width: width * 0.8,
        height: height * 0.07,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.timer,
                color: Colors.pink,
              ),
              const HoursPicker(),
              colonBox,
              const MinsPicker(),
              colonBox,
              const SecsPicker(),
            ],
          ),
        ),
      ),
    );
  }
}
