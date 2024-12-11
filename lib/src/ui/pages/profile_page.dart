import 'package:flutter/material.dart';
import 'package:pr_10/src/models/user_model.dart';
import 'package:pr_10/src/resources/api.dart';
import 'package:pr_10/src/ui/components/profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    try {
      final user = await ApiService().getUser();
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching user: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Профиль',
            style: TextStyle(
              color: Color.fromRGBO(76, 23, 0, 1.0),
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
          ? const Center(child: Text('Не удалось загрузить данные пользователя'))
          : Column(
        children: [
          Profile(user: _user!),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => EditProfilePage(user: _user!),
              //   ),
              // ).then((updatedUser) {
              //   if (updatedUser != null) {
              //     _updateData(updatedUser);
              //   }
              // });
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: const Size(350, 40),
                textStyle: const TextStyle(
                  fontSize: 14,
                )),
            child: const Text('Редактировать профиль'),
          ),
        ],
      ),
    );
  }
}
