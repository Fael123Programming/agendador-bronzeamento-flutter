import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:agendador_bronzeamento/utils/constants.dart';
import 'dart:async';

@HiveType(typeId: 4)
class Timing {
  Timing({
    required this.clientName,
    required this.totalDuration,
    required this.remainingDuration,
    required this.totalTurns,
    required this.turnsDone
  });

  @HiveField(0)
  String clientName;

  @HiveField(1)
  Duration totalDuration;

  @HiveField(2)
  Duration remainingDuration;

  @HiveField(3)
  int totalTurns;

  @HiveField(4)
  int turnsDone;

  @override
  String toString() {
    return '{"clientName" : "$clientName", "totalDuration": ${totalDuration.toString()}, "remainingDuration": ${remainingDuration.toString()}, "totalTurns": $totalTurns, "turnsDone": $turnsDone}';
  }

    @override
  bool operator ==(Object other) {
    return other is Timing && 
            clientName == other.clientName && 
            totalDuration == other.totalDuration &&
            remainingDuration == other.remainingDuration &&
            totalTurns == other.totalTurns &&
            turnsDone == other.turnsDone;
  }

    @override
  int get hashCode => Object.hash(clientName, totalDuration, remainingDuration, totalTurns, turnsDone);
}

class TimingAdapter extends TypeAdapter<Timing> {
  @override
  final int typeId = 4;

  @override
  Timing read(BinaryReader reader) {
    final clientName = reader.read();
    final totalDuration = Duration(milliseconds: reader.read());
    final remainingDuration = Duration(milliseconds: reader.read());
    final totalTurns = reader.read();
    final turnsDone = reader.read();
    return Timing(
      clientName: clientName, 
      totalDuration: totalDuration, 
      remainingDuration: remainingDuration, 
      totalTurns: totalTurns, 
      turnsDone: turnsDone
    );
  }

  @override
  void write(BinaryWriter writer, Timing obj) {
    writer.write(obj.clientName);
    writer.write(obj.totalDuration.inMilliseconds);
    writer.write(obj.remainingDuration.inMilliseconds);
    writer.write(obj.totalTurns);
    writer.write(obj.turnsDone);
  }
}

class TimingController extends GetxController {
  TimingController({
    required this.clientName,
    required this.totalDuration,
    required this.remainingDuration,
    required this.totalTurns,
    required this.turnsDone
  });

  String clientName;
  int totalTurns;
  RxInt turnsDone;
  Duration totalDuration;
  Rx<Duration> remainingDuration;

  Rx<Color> color = Colors.white.obs;
  Rx<Timer> timer = Timer(Duration.zero, (){}).obs;
  RxBool stopped = false.obs;
  RxBool active = true.obs;

  void fromTiming(Timing timing) {
    clientName = timing.clientName;
    totalDuration = timing.totalDuration;
    remainingDuration.value = timing.remainingDuration;
    totalTurns = timing.totalTurns;
    turnsDone.value = timing.turnsDone;
  }

  Timing toTiming() {
    return Timing(
      clientName: clientName,
      totalDuration: totalDuration,
      remainingDuration: remainingDuration.value,
      totalTurns: totalTurns,
      turnsDone: turnsDone.value
    );
  }

  void startTimer() {
    final TimingsController timingsController = Get.find();
    color.value = Colors.white;
    stopped.value = false;
    remainingDuration.value = Duration(seconds: totalDuration.inSeconds);
    timer.value = Timer.periodic(const Duration(seconds: 1), (t) async {
      if (remainingDuration.value.inSeconds > 1) {
        remainingDuration.value = remainingDuration.value - const Duration(seconds: 1);
      } else {
        turnsDone.value++;
        timer.value.cancel();
        color.value = Colors.pink;
        stopped.value = true;
      }
      await timingsController.addTiming(toTiming());
    });
  }

  @override
  void onClose() {
    timer.value.cancel();
    super.onClose();
  }
}

class TimingsController extends GetxController {
  RxList<Timing> timings = <Timing>[].obs;
  RxBool loaded = false.obs;

  Future<void> fetchTimings() async {
    Box<Timing> timingsBoxObj = await Hive.openBox(timingsBox);
    timings.value = timingsBoxObj.values.toList();
    loaded.value = true;
  }

  Future<void> addTiming(Timing timing) async {
    final Box<Timing> timingsBoxObj = await Hive.openBox<Timing>(timingsBox);
    await timingsBoxObj.put(timing.clientName, timing);
  }

  Future<void> deleteTiming(Timing timing) async {
    final Box<Timing> timingsBoxObj = await Hive.openBox<Timing>(timingsBox);
    await timingsBoxObj.delete(timing.clientName);
  }
}