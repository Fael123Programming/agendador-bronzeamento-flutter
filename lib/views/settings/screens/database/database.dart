import 'package:agendador_bronzeamento/database/database_helper.dart';
import 'package:agendador_bronzeamento/database/models/bronze.dart';
import 'package:agendador_bronzeamento/database/models/client.dart';
import 'package:agendador_bronzeamento/database/models/config.dart';
import 'package:agendador_bronzeamento/views/settings/widgets/setting_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqflite/sqflite.dart';
import 'package:file_picker/file_picker.dart';

class Database extends StatelessWidget {
  const Database({super.key});

  @override
  Widget build(BuildContext context) {
    final BronzeController bronzeController = Get.find();
    final ClientController clientController = Get.find();
    
    final List<Map<String, dynamic>> settingItems = <Map<String, dynamic>> [
      {
        'settingItem': SettingItem(
          title: 'Importar',
          icon: FontAwesomeIcons.upload,
          onTap: () async {
            Get.dialog(
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Material(
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              const Text(
                                'Importar Base de Dados',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                'A base de dados atual será substituída pela base selecionada em formato de arquivo, fazendo com que todos os dados atuais sejam perdidos. Após a importação, o aplicativo será inteiramente atualizado com os dados obtidos da nova base incluindo informações de clientes, bronzes e configurações. Continuar?',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(0, 45),
                                        backgroundColor: const Color.fromARGB(255, 255, 17, 0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () => Get.back(),
                                      child: const Text(
                                        'Não',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(0, 45),
                                        backgroundColor: const Color.fromARGB(255, 0, 255, 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () async {
                                        Get.back();
                                        FilePickerResult? result = await FilePicker.platform.pickFiles();
                                        if (result != null) {
                                          bool error = false;
                                          PlatformFile platFile = result.files[0];
                                          if (platFile.path == null || platFile.extension != 'db') {
                                            error = true;
                                          } else if (
                                            await DatabaseHelper().isValidDatabase(platFile.path!) &&
                                            await DatabaseHelper().migrateDatabase(platFile.path!)
                                          ) {
                                            await clientController.fetch();
                                            await bronzeController.fetch();
                                            final ConfigController configController = Get.find();
                                            await configController.fetch();
                                            Get.dialog(
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 40),
                                                    child: Container(
                                                      decoration: const BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(20),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(20.0),
                                                        child: Material(
                                                          child: Column(
                                                            children: [
                                                              const SizedBox(height: 10),
                                                              const Text(
                                                                'Importação de Base de Dados',
                                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                              const SizedBox(height: 15),
                                                              const Text(
                                                                'Base de dados importada com sucesso!',
                                                                textAlign: TextAlign.center,
                                                              ),
                                                              const SizedBox(height: 20),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                        minimumSize: const Size(0, 45),
                                                                        backgroundColor: const Color.fromARGB(255, 0, 255, 8),
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(8),
                                                                        ),
                                                                      ),
                                                                      onPressed: () async {
                                                                        Get.back();
                                                                        // if (!context.mounted) {
                                                                        //   return;
                                                                        // }
                                                                        // Navigator.of(context).pop();
                                                                      },
                                                                      child: const Text(
                                                                        'Ok',
                                                                        style: TextStyle(color: Colors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            error = true;
                                          }
                                          if (error) {
                                            Get.dialog(
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 40),
                                                    child: Container(
                                                      decoration: const BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius: BorderRadius.all(
                                                          Radius.circular(20),
                                                        ),
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(20.0),
                                                        child: Material(
                                                          child: Column(
                                                            children: [
                                                              const SizedBox(height: 10),
                                                              const Text(
                                                                'Erro na Importação',
                                                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                              const SizedBox(height: 15),
                                                              const Text(
                                                                'Ops... parece que houve um erro na importação da nova base de dados. Verifique que o arquivo escolhido tenha a extensão \'db\' e que você o tenha obtido a partir de Ajustes > Base de Dados > Exportar de um aplicativo Meu Bronze',
                                                                textAlign: TextAlign.center,
                                                              ),
                                                              const SizedBox(height: 20),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: ElevatedButton(
                                                                      style: ElevatedButton.styleFrom(
                                                                        minimumSize: const Size(0, 45),
                                                                        backgroundColor: const Color.fromARGB(255, 255, 17, 0),
                                                                        shape: RoundedRectangleBorder(
                                                                          borderRadius: BorderRadius.circular(8)
                                                                        ),
                                                                      ),
                                                                      onPressed: () async {
                                                                        Get.back();
                                                                        // if (!context.mounted) {
                                                                        //   return;
                                                                        // }
                                                                        // Navigator.of(context).pop();
                                                                      },
                                                                      child: const Text(
                                                                        'Ok',
                                                                        style: TextStyle(color: Colors.white),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        }
                                        // await Future.delayed(const Duration(seconds: 1));
                                        if (!context.mounted) {
                                          return;
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Sim',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          showRightArrow: false,
        ),
        'active': true
      },
      {
        'settingItem': SettingItem(
          title: 'Exportar',
          icon: FontAwesomeIcons.download,
          showRightArrow: false,
          onTap: () {
            Get.dialog(
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Material(
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              const Text(
                                'Exportar Base de Dados',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 15),
                              const Text(
                                'Toda a base de dados será salva localmente em seu dispositivo no formato de um arquivo. Desta forma, será possível carregar tudo que você já fez no seu app em um outro dispositivo indo em Ajustes > Base de Dados > Importar e selecionando o arquivo aqui exportado. Continuar?',
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(0, 45),
                                        backgroundColor: const Color.fromARGB(255, 255, 17, 0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () => Get.back(),
                                      child: const Text(
                                        'Não',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(0, 45),
                                        backgroundColor: const Color.fromARGB(255, 0, 255, 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () async {
                                        // await Future.delayed(const Duration(seconds: 1));
                                        final path = await getDatabasesPath();
                                        final finalPath = join(path, 'base_de_dados.db');
                                        await Share.shareXFiles(
                                          [XFile(finalPath)],
                                          text: 'Exportar base_de_dados.db'
                                        );
                                        Get.back();
                                        if (!context.mounted) {
                                          return;
                                        }
                                        // Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Sim',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        'active': false
      },
      {
        'settingItem': Obx(() {
          final List<int> years = bronzeController.bronzes.map((bronze) => bronze.timestamp.year).toSet().toList();
          years.sort((y1, y2) => y1.compareTo(y2));
          int oldestYear = years.isEmpty ? DateTime.now().year : years[0];
          return SettingItem(
            title: 'Limpar Bronzes',
            icon: FontAwesomeIcons.trash,
            showRightArrow: false,
            onTap: () async {
              Get.dialog(
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Material(
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                const Text(
                                  'Limpar Bronzes',
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  'Os bronzes feitos no ano mais antigo, isto é, o primeiro ano encontrado (nesse caso, $oldestYear) serão apagados. Tem certeza?',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(0, 45),
                                          backgroundColor: const Color.fromARGB(255, 255, 17, 0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        onPressed: () => Get.back(),
                                        child: const Text(
                                          'Não',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: const Size(0, 45),
                                          backgroundColor: const Color.fromARGB(255, 0, 255, 8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        onPressed: () async {
                                          await bronzeController.deleteBronzesOfYear(oldestYear);
                                          Get.back();
                                          // await Future.delayed(const Duration(seconds: 1));
                                          if (!context.mounted) {
                                            return;
                                          }
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          'Sim',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }),
        'active': false
      }
    ];
    
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Base de Dados',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'DancingScript'
          ),
        ),
      ),
      body: Obx(() {
        settingItems[2]['active'] = bronzeController.bronzes.isNotEmpty;  // Clean.
        settingItems[1]['active'] = bronzeController.bronzes.isNotEmpty || clientController.clients.isNotEmpty;  // Export.
        final activeItems = settingItems.where((item) => item['active']).toList();
        return Center(
          child: SafeArea(
            child: ListView.separated(
              itemCount: activeItems.length,
              separatorBuilder: (BuildContext context, int index) => const Divider(),
              itemBuilder: (BuildContext context, int index) => activeItems[index]['settingItem']
            ),
          ),
        );
      })
    );
  }
}
