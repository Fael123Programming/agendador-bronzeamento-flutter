import 'package:agendador_bronzeamento/views/clients/widgets/form_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NameInputController extends GetxController {
  final FocusNode focusNode = FocusNode();
  final TextEditingController name = TextEditingController();
  Function()? onEditingComplete;

  NameInputController({this.onEditingComplete});
}

class NameInput extends StatelessWidget {
  const NameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FormController formController = Get.find();
    final NameInputController nameController = Get.find();
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
                  onTap: () => formController.formKey.currentState?.reset(),
                  onEditingComplete: nameController.onEditingComplete,
                  focusNode: nameController.focusNode,
                  controller: nameController.name,
                  // autofocus: true,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Nome',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 12
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O campo de nome deve ser preenchido';
                    }
                    return null;
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
