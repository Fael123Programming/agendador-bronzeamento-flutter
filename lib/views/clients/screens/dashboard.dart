import 'package:agendador_bronzeamento/config/route_paths.dart';
import 'package:agendador_bronzeamento/views/settings/widgets/setting_item.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final List<SettingItem> settingItems = <SettingItem>[
      SettingItem(
        title: 'Bronzes Geral',
        icon: Icons.sunny,
        onTap: () => Navigator.pushNamed(context, RoutePaths.bronzes),
      ),
      SettingItem(
        title: 'Inferências',
        icon: Icons.query_stats,
        onTap: () => Navigator.pushNamed(context, RoutePaths.inferences),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
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
