import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> sendMessage(String clientName, String phoneNumber) async {
  int hour = DateTime.now().hour;
  String hourTxt;
  if (hour < 12) {
    hourTxt = 'Bom dia';
  } else if (hour < 18) {
    hourTxt = 'Boa tarde';
  } else {
    hourTxt = 'Boa noite';
  }
  const toReplace = '()+/';
  String localPhone = phoneNumber;
  for (final c in toReplace.characters) {
    if (localPhone.contains(c)) {
      localPhone = localPhone.replaceFirst(c, '');
    }
  }
  final message = 'Olá, $clientName! $hourTxt!';
  final url = 'https://wa.me/$localPhone/?text=${Uri.encodeFull(message)}';
  await launchUrl(Uri.parse(url));
}