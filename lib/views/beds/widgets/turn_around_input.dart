import 'package:agendador_bronzeamento/utils/validator.dart';
import 'package:flutter/material.dart';

class TurnAroundInput extends StatefulWidget {
  final FocusNode? focusNode;
  final Function()? onEditingComplete;
  final TextEditingController? controller;

  const TurnAroundInput(
      {Key? key, this.focusNode, this.onEditingComplete, this.controller})
      : super(key: key);

  @override
  State<TurnAroundInput> createState() => _TurnAroundInputState();
}

class _TurnAroundInputState extends State<TurnAroundInput> {
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
        width: width * 0.4,
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
                Icons.u_turn_left,
                color: Colors.grey,
              ),
              SizedBox(
                width: width * 0.04,
              ),
              Expanded(
                child: TextFormField(
                  textAlign: TextAlign.start,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      bool invalidValue = false;
                      if (!Validator.isInteger(value)) {
                        setState(() {
                          widget.controller?.text = '';
                        });
                        invalidValue = true;
                      } else if (int.parse(value) < 1) {
                        setState(() {
                          widget.controller?.text = '';
                        });
                        invalidValue = true;
                      }
                      if (invalidValue) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Número de viradas inválido'),
                            duration: Duration(
                              seconds: 2,
                            ),
                          ),
                        );
                      }
                    }
                  },
                  onEditingComplete: widget.onEditingComplete,
                  focusNode: widget.focusNode,
                  controller: textFormFieldController,
                  keyboardType: TextInputType.number,
                  keyboardAppearance: Brightness.light,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Viradas',
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
