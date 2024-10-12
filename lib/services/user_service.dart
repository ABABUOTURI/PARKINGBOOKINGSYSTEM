import 'package:hive/hive.dart';
import '../models/user.dart';


class UserService {
  Box<User>? userBox;

  UserService() {
    _initHive();
  }

  void _initHive() async {
    userBox = await Hive.openBox<User>('userBox');
  }

  void addUser(User user) {
    userBox?.add(user); // Adds user to the box
  }

  User? getUser(int index) {
    return userBox!.getAt(index); // Retrieves user at a specific index
  }

  void updateUser(int index, User updatedUser) {
    userBox?.putAt(index, updatedUser); // Updates user at the specified index
  }

  void deleteUser(int index) {
    userBox?.deleteAt(index); // Deletes user at the specified index
  }

  void closeBox() {
    userBox?.close(); // Close the user box
  }
}
