// import 'package:agendador_bronzeamento/database/models/bronze.dart';
// import 'package:agendador_bronzeamento/utils/month_year_pair.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget showDependent(Widget widget, RxBool logic) {
  if (logic.value) {
    return widget;
  }
  return Container();
}

