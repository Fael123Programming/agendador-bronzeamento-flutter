import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:agendador_bronzeamento/utils/constants.dart';

@HiveType(typeId: 2)
class User {
  User({
    required this.name,
    required this.phoneNumber,
    required this.observations,
  });

  @HiveField(0)
  String name;

  @HiveField(1)
  String phoneNumber;

  @HiveField(2)
  String observations;
}

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 2;

  @override
  User read(BinaryReader reader) {
    final name = reader.read();
    final phoneNumber = reader.read();
    final observations = reader.read();
    return User(
      name: name,
      phoneNumber: phoneNumber,
      observations: observations,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer.write(obj.name);
    writer.write(obj.phoneNumber);
    writer.write(obj.observations);
  }
}

class UserController extends GetxController {
  RxList<User>? users;
  RxBool loaded = false.obs;

  Future<void> fetchUsers() async {
    final Box<User> usersLocal = await Hive.openBox<User>(usersBox);
    loaded = true.obs;
    users = usersLocal.values.toList().obs;
  }

  void addUser(User user) async {
    final Box<User> users = await Hive.openBox<User>(usersBox);
    await users.add(user);
  }
}