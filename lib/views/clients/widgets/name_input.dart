import 'package:flutter/material.dart';

class NameInput extends StatefulWidget {
  final FocusNode? focusNode;
  final Function()? onEditingComplete;
  final TextEditingController? controller;

  const NameInput(
      {Key? key, this.focusNode, this.onEditingComplete, this.controller})
      : super(key: key);

  @override
  State<NameInput> createState() => _NameInputState();
}

class _NameInputState extends State<NameInput> {
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
              const Icon(
                Icons.person_2,
                color: Colors.grey,
              ),
              SizedBox(
                width: width * 0.04,
              ),
              Expanded(
                child: TextFormField(
                  onEditingComplete: widget.onEditingComplete,
                  focusNode: widget.focusNode,
                  controller: textFormFieldController,
                  // autofocus: true,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Nome',
                    hintStyle: TextStyle(
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
