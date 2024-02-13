import 'package:flutter/material.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/hours_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/mins_picker.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/secs_picker.dart';

class TimePicker extends StatelessWidget {
  final FocusNode hourFocusNode;
  final FocusNode minsFocusNode = FocusNode();
  final FocusNode secsFocusNode = FocusNode();
  final Function() onEditingComplete;

  TimePicker({
    super.key,
    required this.hourFocusNode,
    required this.onEditingComplete,
  });

  
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
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.timer,
          color: Colors.pink,
          size: 25,
        ),
        HoursPicker(
          focusNode: hourFocusNode,
          onEditingComplete: () => minsFocusNode.requestFocus(),
        ),
        collonBox,
        MinsPicker(
          focusNode: minsFocusNode,
          onEditingComplete: () => secsFocusNode.requestFocus(),
        ),
        collonBox,
        SecsPicker(
          focusNode: secsFocusNode,
          onEditingComplete: onEditingComplete,
        ),
      ],
    );
  }
}
