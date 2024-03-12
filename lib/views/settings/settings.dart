import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:agendador_bronzeamento/views/settings/widgets/setting_item.dart';
import 'package:flutter/material.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final List<SettingItem> settingItems = <SettingItem>[
      SettingItem(
        title: 'Padrão',
        icon: Icons.settings,
        onTap: () => Navigator.pushNamed(context, RoutePaths.general),
      ),
      SettingItem(
        title: 'Sobre',
        icon: Icons.info,
        onTap: () => Navigator.pushNamed(context, RoutePaths.about),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Ajustes',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'DancingScript'
          ),
        ),
      ),
      body: Center(
        child: SafeArea(
          child: ListView.separated(
            itemCount: settingItems.length,
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
