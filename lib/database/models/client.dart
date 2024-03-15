import 'dart:typed_data';

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

enum Order {
  increasing(factor: 1),
  decreasing(factor: -1);

  final int factor;
  const Order({required this.factor});
}

enum SortingMethod {
  name,
  since,
  bronzes;
}

class ClientController extends GetxController {
  RxList<Client> clients = <Client>[].obs;
  Rx<SortingMethod> sortingMethod = SortingMethod.name.obs;
  Rx<Order> order = Order.increasing.obs;

  void sortByName({Order order = Order.increasing}) {
    clients.sort((client1, client2) => client1.name.compareTo(client2.name) * order.factor);
  }

  void sortBySince({Order order = Order.increasing}) {
    clients.sort((client1, client2) => client1.since.compareTo(client2.since) * order.factor);
  }

  void sortByBronzes({Order order = Order.increasing}) {
    clients.sort((client1, client2) => client1.bronzes.value.compareTo(client2.bronzes.value) * order.factor);
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
    bronzeController.bronzes.removeWhere((bronze) => bronze.clientId == client.id);
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
    switch (sortingMethod.value) {
      case SortingMethod.name:
        sortByName(order: order.value);
        break;
      case SortingMethod.since:
        sortByName(order: order.value);
        break;
      case SortingMethod.bronzes:
        sortByName(order: order.value);
        break;
    }
  }
}