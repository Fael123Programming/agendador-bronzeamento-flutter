import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:agendador_bronzeamento/views/settings/widgets/setting_item.dart';
import 'package:flutter/material.dart';

class General extends StatelessWidget {
  const General({super.key});

  @override
  Widget build(BuildContext context) {
    final List<SettingItem> settingItems = <SettingItem>[
      SettingItem(
        title: 'Viradas',
        icon: Icons.u_turn_left,
        onTap: () => Navigator.pushNamed(context, RoutePaths.changeTurnArounds),
      ),
      SettingItem(
        title: 'Duração',
        icon: Icons.timer,
        onTap: () => Navigator.pushNamed(context, RoutePaths.changeDuration),
      ),
      SettingItem(
        title: 'Preço',
        icon: Icons.monetization_on,
        onTap: () => Navigator.pushNamed(context, RoutePaths.changePrice),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Padrão',
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
