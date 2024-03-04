import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function() onTap;

  const SettingItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final Color? tileColor = Colors.pink;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: ListTile(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          side: BorderSide(color: Colors.white),
        ),
        onTap: onTap,
        hoverColor: Colors.pink[100],
        tileColor: tileColor,
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        leading: Icon(
          icon,
          color: Colors.white,
        ),
        trailing: const Icon(
          Icons.arrow_right_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
