import 'package:flutter/material.dart';

class SettingItem extends StatefulWidget {
  final String title;
  final IconData icon;
  final void Function() onTap;

  const SettingItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  State<SettingItem> createState() => _SettingItemState();
}

class _SettingItemState extends State<SettingItem> {
  Color? tileColor = Colors.pink;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: ListTile(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          side: BorderSide(color: Colors.white),
        ),
        onTap: widget.onTap,
        hoverColor: Colors.pink[100],
        tileColor: tileColor,
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        leading: Icon(
          widget.icon,
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
