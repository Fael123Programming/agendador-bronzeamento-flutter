import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:agendador_bronzeamento/views/settings/widgets/setting_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    final List<SettingItem> settingItems = <SettingItem>[
      SettingItem(
        title: 'Valores Padrão',
        icon: Icons.settings,
        onTap: () => Navigator.pushNamed(context, RoutePaths.defaultValues),
      ),
      SettingItem(
        title: 'Base de Dados',
        icon: FontAwesomeIcons.database,
        onTap: () => Navigator.pushNamed(context, RoutePaths.database),
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
