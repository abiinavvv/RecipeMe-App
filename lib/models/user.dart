import 'package:hive/hive.dart';
part 'user.g.dart';
@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  late final String email;

  @HiveField(2)
  late final String username;

  @HiveField(3)
  final String password;

  @HiveField(4)
  String? profilePicturePath;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.password,
    this.profilePicturePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'profilePicturePath': profilePicturePath,
    };
  }
}