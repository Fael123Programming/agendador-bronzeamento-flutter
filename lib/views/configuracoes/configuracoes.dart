import 'package:agendador_bronzeamento/views/configuracoes/components/setting_item.dart';
import 'package:flutter/material.dart';

class Configuracoes extends StatefulWidget {
  const Configuracoes({super.key});

  @override
  State<Configuracoes> createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
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
