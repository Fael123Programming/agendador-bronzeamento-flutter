import 'package:agendador_bronzeamento/views/settings/components/setting_item.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final List<Widget> settingItems = [
    SettingItem(title: 'Gerais', icon: Icons.settings, onTap: () {}),
    SettingItem(title: 'Sobre', icon: Icons.info, onTap: () {}),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Center(
        child: SafeArea(
          child: ListView.separated(
            itemCount: 2,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemBuilder: (BuildContext context, int index) {
              return settingItems[index];
            },
          ),
        ),
      ),
    );
  }
}
