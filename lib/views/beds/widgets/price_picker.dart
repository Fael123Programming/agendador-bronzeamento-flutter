import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:decimal/decimal.dart';

class PricePickerController extends GetxController {
  final TextEditingController price = TextEditingController();
  final FocusNode focusNode = FocusNode();
  Function()? onEditingComplete;

  bool isValid() {
    try {
      Decimal.parse(price.text);
      return true;
    } on FormatException {
      return false;
    }
  }
}

class PricePicker extends StatelessWidget {
  const PricePicker({super.key});
  
  @override
  Widget build(context) {
    final PricePickerController priceController = Get.find();
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
                Icons.monetization_on,
                color: Colors.green,
              ),
              SizedBox(
                width: width * 0.04,
              ),
              Expanded(
                child: TextFormField(
                    controller: priceController.price,
                    textAlign: TextAlign.start,
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        // value = value.replaceAll(RegExp(r'[^\d,]'), '');
                        // try {
                        //   Decimal dec = Decimal.parse(value);
                        //   priceController.price.text = dec.toString();
                        // } on FormatException {
                        //   priceController.price.text = '';
                        // }
                        if (!priceController.isValid()) {
                          priceController.price.text = '';
                        }
                      }
                    },
                    onEditingComplete: priceController.onEditingComplete,
                    focusNode: priceController.focusNode,
                    keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: true),
                    keyboardAppearance: Brightness.light,
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Preço',
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