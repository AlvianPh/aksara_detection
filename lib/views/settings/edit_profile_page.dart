import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/controllers/profile_controller.dart';
import '/utils/prefs.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _controller = ProfileController();
  final nameC = TextEditingController();
  final usernameC = TextEditingController();
  File? foto;
  String? fotoUrl; // gambar yang dari database / API

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  loadProfile() async {
    String? token = await Prefs.getToken();
    if (token == null) return;

    var res = await _controller.getProfile(token);

    nameC.text = res["data"]["name"];
    usernameC.text = res["data"]["username"];

    fotoUrl = res["data"]["foto"] != null && res["data"]["foto"] != ""
        ? res["data"]["foto"].replaceAll("localhost", "10.0.2.2")
        : null;

    setState(() => loading = false);
  }

  pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => foto = File(picked.path));
    }
  }

  save() async {
    String? token = await Prefs.getToken();
    if (token == null) return;

    var result = await _controller.updateProfile(
      token,
      nameC.text,
      usernameC.text,
      foto,
    );

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(result["message"])));

    if (result["status"] == true) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profil")),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: pickImage,
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: foto != null
                          ? FileImage(foto!) as ImageProvider
                          : (fotoUrl != null && fotoUrl!.isNotEmpty
                              ? NetworkImage(fotoUrl!) as ImageProvider
                              : null),
                      child: (foto == null &&
                              (fotoUrl == null || fotoUrl!.isEmpty))
                          ? Icon(Icons.camera_alt, size: 40)
                          : null,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: nameC,
                    decoration: InputDecoration(labelText: "Nama"),
                  ),
                  TextField(
                    controller: usernameC,
                    decoration: InputDecoration(labelText: "Username"),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: save,
                    child: Text("Simpan Perubahan"),
                  ),
                ],
              ),
            ),
    );
  }
}
