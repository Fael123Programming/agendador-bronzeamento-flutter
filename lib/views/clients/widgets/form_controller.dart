import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FormController extends GetxController {
  final formKey = GlobalKey<FormState>();
  RxBool error = false.obs;
  RxString component = ''.obs;
}
