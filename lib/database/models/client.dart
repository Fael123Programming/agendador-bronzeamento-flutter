import 'dart:typed_data';

import 'package:agendador_bronzeamento/config/config.dart';
import 'package:agendador_bronzeamento/database/database_helper.dart';
import 'package:agendador_bronzeamento/database/models/bronze.dart';
import 'package:agendador_bronzeamento/views/beds/widgets/bed_card.dart';
import 'package:get/get.dart';

class Client {
  late int id;
  final String name;
  final String phoneNumber;
  late DateTime since;
  late RxInt bronzes;
  String? observations;
  Uint8List? picture;

  Client({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.since,
    required this.bronzes,
    this.observations,
    this.picture
  });

  Client.toSave({
    required this.name,
    required this.phoneNumber,
    this.observations,
    this.picture
  }) {
    id = -1;
    since = DateTime.now();
    bronzes = 0.obs;
  }

  static Client fromMap(Map<String, dynamic> map) {
    return Client(
      id: map['id'],
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      since: DateTime.parse(map['since']),
      bronzes: int.parse(map['bronzes'].toString()).obs,
      observations: map['observations'],
      picture: map['picture']
    );
  }

  Map<String, Object?> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'since': since.toString(),
      'bronzes': bronzes.value,
      'observations': observations,
      'picture': picture
    };
  }

  @override
  String toString() {
    return toMap().toString();
  }

  @override
  bool operator ==(Object other) {
    return other is Client && id == other.id;
  }

  @override
  int get hashCode => id.hashCode;
}

class ClientController extends GetxController {
  RxList<Client> clients = <Client>[].obs;
  late Map<String, void Function(int)> sortingMethods;

  ClientController() {
    sortingMethods = {
      'name': (factor) => clients.sort((client1, client2) => client1.name.compareTo(client2.name) * factor),
      'since': (factor) => clients.sort((client1, client2) => client1.since.compareTo(client2.since) * factor),
      'bronzes': (factor) => clients.sort((client1, client2) => client1.bronzes.value.compareTo(client2.bronzes.value) * factor),
    };
  }

  Future<void> fetch() async {
    clients.value = await DatabaseHelper().selectAllClients();
    sort();
  }

  Future<void> insert(Client client) async {
    int id = await DatabaseHelper().insertClient(client);
    client.id = id;
    clients.add(client);
    sort();
  }

  Future<void> delete(Client client) async {
    await DatabaseHelper().deleteClient(client);
    clients.remove(client);
    final BronzeController bronzeController = Get.find();
    await bronzeController.fetch();
  }

  Client? findById(int id) {
    try {
      return clients.where((client) => client.id == id).first;
    } catch(err) {
      return null;
    }
  }

  Client? findByName(String name) {
    try {
      return clients.where((client) => client.name.toLowerCase() == name.toLowerCase()).first;
    } catch(err) {
      return null;
    }
  }

  String? getRealName(List<Client> clients, String name) {
    Iterable<Client> found = clients.toList()
      .where(
        (client) => client.name.toLowerCase() ==
              name.toLowerCase(),
      );
    if (found.isEmpty) {
      return null;
    }
    return found.first.name;
  }

  List<Client> getIdle() {
    final BedCardListController bedCardListController = Get.find();
    List<String> busy = bedCardListController.list.map((bedCard) => bedCard.bedCardController.client.name.toLowerCase()).toList();
    List<Client> resultList = clients.where((client) => !busy.contains(client.name.toLowerCase())).toList();
    return resultList;
  }

  Future<void> doUpdate(Client client) async {
    await DatabaseHelper().updateClient(client);
    Client? foundClient = findById(client.id);
    clients.remove(foundClient);
    clients.add(client);
    sort();
  }

  void sort() {
    final ConfigController configController = Get.find();
    int factor = configController.getIncreasing() ? 1 : -1;
    String sortingMethod = configController.getSortBy().toLowerCase();
    sortingMethods[sortingMethod]!(factor);
  }
}