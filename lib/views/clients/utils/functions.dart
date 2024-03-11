import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget showDependent(Widget widget, RxBool logic) {
  if (logic.value) {
    return widget;
  }
  return Container();
}