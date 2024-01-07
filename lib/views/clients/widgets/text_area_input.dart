import 'package:flutter/material.dart';

class TextAreaInput extends StatefulWidget {
  final FocusNode? focusNode;
  final Function()? onEditingComplete;
  final TextEditingController? controller;
  final String hintText;
  final IconData icon;

  const TextAreaInput(
      {Key? key,
      this.focusNode,
      this.onEditingComplete,
      this.controller,
      required this.hintText,
      required this.icon})
      : super(key: key);

  @override
  State<TextAreaInput> createState() => _TextAreaInputState();
}

class _TextAreaInputState extends State<TextAreaInput> {
  final controller = TextEditingController();
  late TextEditingController textFormFieldController;

  @override
  void initState() {
    super.initState();
    textFormFieldController =
        widget.controller != null ? widget.controller! : controller;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Center(
      child: Container(
        width: width * 0.8,
        height: height * 0.07,
        padding: EdgeInsets.all(width * 0.03),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Colors.white,
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: Center(
          child: Row(
            children: <Widget>[
              Icon(
                widget.icon,
                color: Colors.grey,
              ),
              SizedBox(
                width: width * 0.04,
              ),
              Expanded(
                child: TextFormField(
                  // maxLines: 5,
                  // maxLength: 100,
                  onEditingComplete: widget.onEditingComplete,
                  focusNode: widget.focusNode,
                  controller: textFormFieldController,
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
