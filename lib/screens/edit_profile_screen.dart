import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text("プロフィール編集"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "ユーザー名",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(

              onPressed: () {

                Navigator.pop(context, nameController.text);

              },

              child: const Text("保存"),
            )
          ],
        ),
      ),
    );
  }
}