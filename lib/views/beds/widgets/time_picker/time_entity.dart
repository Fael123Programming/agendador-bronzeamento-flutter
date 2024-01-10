import 'package:agendador_bronzeamento/utils/validator.dart';
import 'package:flutter/material.dart';

class TimeEntity extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final Function()? onEditingComplete;
  final FocusNode? focusNode;

  const TimeEntity({
    super.key,
    this.focusNode,
    this.onEditingComplete,
    required this.hintText,
    required this.controller,
  });

  @override
  State<TimeEntity> createState() => _TimeEntityState();
}

class _TimeEntityState extends State<TimeEntity> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Center(
      child: Container(
        margin: const EdgeInsets.all(15),
        width: width * 0.2,
        height: height * 0.07,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Center(
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  onChanged: (value) {
                    String valStr;
                    if (Validator.isInteger(value)) {
                      valStr = value.toString();
                    } else {
                      valStr = '0';
                    }
                    setState(() {
                      widget.controller.text = valStr;
                    });
                  },
                  onEditingComplete: widget.onEditingComplete,
                  focusNode: widget.focusNode,
                  controller: widget.controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  // autofocus: true,
                  decoration: InputDecoration.collapsed(
                    hintText: widget.hintText,
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
