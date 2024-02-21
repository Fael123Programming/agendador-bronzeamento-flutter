import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:agendador_bronzeamento/utils/constants.dart';

@HiveType(typeId: 2)
class User {
  User({
    required this.name,
    required this.phoneNumber,
    this.observations,
    this.profileImage
  });

  @HiveField(0)
  String name;

  @HiveField(1)
  String phoneNumber;

  @HiveField(2)
  String? observations;

  @HiveField(3)
  Uint8List? profileImage; 

  @override
  String toString() {
    return '{"name" : "$name", "phoneNumber": "$phoneNumber"}';
  }

  @override
  bool operator ==(Object other) {
    return other is User && 
            name == other.name && 
            phoneNumber == other.phoneNumber && 
            observations == other.observations;
  }

  @override
  int get hashCode => Object.hash(name, phoneNumber, observations);
}

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 2;

  @override
  User read(BinaryReader reader) {
    final name = reader.read();
    final phoneNumber = reader.read();
    final observations = reader.read();
    try {
      final profileImageLength = reader.readUint32();
      final profileImage = reader.readList(profileImageLength);
      return User(
        name: name,
        phoneNumber: phoneNumber,
        observations: observations,
        profileImage: Uint8List.fromList(profileImage.cast<int>())
      );
    } on RangeError {
      return User(
        name: name,
        phoneNumber: phoneNumber,
        observations: observations,
        profileImage: null
      );
    }
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.write(obj.name);
    writer.write(obj.phoneNumber);
    writer.write(obj.observations);
    if (obj.profileImage != null) {
      writer.writeUint32(obj.profileImage!.lengthInBytes);
      writer.writeList(obj.profileImage!.toList());
    }
  }
}

class UserController extends GetxController {
  RxList<User>? users;
  RxBool loaded = false.obs;

  Future<void> clear() async {
    final Box<User> usersBoxObj = await Hive.openBox<User>(usersBox);
    await usersBoxObj.clear();
    users = <User>[].obs;
  }

  Future<void> fetchUsers() async {
    final Box<User> usersBoxObj = await Hive.openBox<User>(usersBox);
    loaded = true.obs;
    users = usersBoxObj.values.toList().obs;
    sort();
  }

  Future<void> addUser(User user) async {
    final Box<User> usersBoxObj = await Hive.openBox<User>(usersBox);
    await usersBoxObj.put(user.name, user);
    users?.add(user);
    sort();
  }

  Future<void> removeUser(User user) async {
    final Box<User> usersBoxObj = await Hive.openBox<User>(usersBox);
    await usersBoxObj.delete(user.name);
    users?.remove(user);
    sort();
  }

  Future<void> updateUser(User oldUser, User newUser) async {
    await removeUser(oldUser);
    await addUser(newUser);
    sort();
  }

  void sort() {
    users?.sort((user1, user2) => user1.name.compareTo(user2.name));
  }
}