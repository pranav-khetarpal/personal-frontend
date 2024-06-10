import 'package:flutter/material.dart';
import 'package:personal_frontend/models/user_model.dart';

class UserTile extends StatelessWidget {
  final UserModel user;
  final VoidCallback onTap;

  const UserTile({super.key, required this.user, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: const CircleAvatar(
        radius: 20,
        child: Icon(Icons.person),
      ),
      title: Text(
        user.name,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      subtitle: Text(
        '@${user.username}',
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}