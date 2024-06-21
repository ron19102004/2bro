import 'package:app_chat/src/data/entities/user_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class UserRepository {
  Future<void> save(UserEntity user);

  Future<UserEntity?> findByUserId(String id);

  Future<UserEntity?> findByEmail(String email);
}

class UserRepositoryImpl implements UserRepository {
  final userCollection = FirebaseFirestore.instance.collection("users");

  @override
  Future<void> save(UserEntity user) async {
    await userCollection.doc(user.uid).set(user.toMap());
  }

  @override
  Future<UserEntity?> findByUserId(String id) async {
    final userMap = await userCollection.doc(id).get();
    if (!userMap.exists) {
      return null;
    }
    return UserEntity.fromJson(userMap.data()!);
  }

  @override
  Future<UserEntity?> findByEmail(String email) async {
    final userMap = await userCollection.where('email', isEqualTo: email).get();
    if (userMap.docs.isEmpty) {
      return null;
    }
    return UserEntity.fromJson(userMap.docs.first.data());
  }
}
