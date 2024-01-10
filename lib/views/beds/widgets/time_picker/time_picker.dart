import 'package:agendador_bronzeamento/views/beds/widgets/time_picker/time_entity.dart';
import 'package:flutter/material.dart';

class TimePicker extends StatefulWidget {
  final Duration duration;
  final FocusNode hourFocusNode;
  final TextEditingController hoursController;
  final TextEditingController minsController;
  final TextEditingController secsController;
  final Function() onEditingComplete;

  const TimePicker({
    super.key,
    required this.duration,
    required this.hourFocusNode,
    required this.hoursController,
    required this.minsController,
    required this.secsController,
    required this.onEditingComplete,
  });

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  late FocusNode minsFocusNode;
  late FocusNode secsFocusNode;
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
  void initState() {
    super.initState();
    minsFocusNode = FocusNode();
    secsFocusNode = FocusNode();
  }

  @override
  void dispose() {
    minsFocusNode.dispose();
    secsFocusNode.dispose();
    super.dispose();
  }

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
        TimeEntity(
          hintText: 'hrs',
          controller: widget.hoursController,
          focusNode: widget.hourFocusNode,
          onEditingComplete: () => minsFocusNode.requestFocus(),
        ),
        collonBox,
        TimeEntity(
          hintText: 'mins',
          controller: widget.minsController,
          focusNode: minsFocusNode,
          onEditingComplete: () => secsFocusNode.requestFocus(),
        ),
        collonBox,
        TimeEntity(
          hintText: 'secs',
          focusNode: secsFocusNode,
          controller: widget.secsController,
          onEditingComplete: widget.onEditingComplete,
        ),
      ],
    );
  }
}
