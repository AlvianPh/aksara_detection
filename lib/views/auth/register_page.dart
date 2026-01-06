import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/auth_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthController();

  final _nameC = TextEditingController();
  final _usernameC = TextEditingController();
  final _passwordC = TextEditingController();
  final _confirmC = TextEditingController();

  bool showPass = false;
  bool showConfirm = false;
  bool loading = false;

  /// 🔴 error khusus username
  String? usernameError;

  File? foto;

  Future pickImage() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() => foto = File(img.path));
    }
  }

  Future register() async {
    setState(() {
      usernameError = null; // reset error
    });

    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    final res = await _auth.register(
      name: _nameC.text.trim(),
      username: _usernameC.text.trim(),
      password: _passwordC.text.trim(),
      confirmPassword: _confirmC.text.trim(),
      foto: foto,
    );

    setState(() => loading = false);

    if (res["success"] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registrasi berhasil! Silakan login")),
      );

      Future.delayed(const Duration(milliseconds: 800), () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    } else {
      final message = res["message"]?.toString().toLowerCase() ?? "";

      /// 🔴 Deteksi username sudah ada
      if (message.contains("username")) {
        setState(() {
          usernameError = "Username sudah digunakan";
        });
        _formKey.currentState!.validate(); // refresh validator
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res["message"] ?? "Register gagal")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                GestureDetector(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 45,
                    backgroundImage: foto != null ? FileImage(foto!) : null,
                    child: foto == null
                        ? const Icon(Icons.camera_alt, size: 30)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),

                TextFormField(
                  controller: _nameC,
                  decoration: const InputDecoration(labelText: "Nama Lengkap"),
                  validator: (v) =>
                      v == null || v.isEmpty ? "Nama tidak boleh kosong" : null,
                ),

                const SizedBox(height: 10),

                /// USERNAME (error aware)
                TextFormField(
                  controller: _usernameC,
                  decoration: const InputDecoration(labelText: "Username"),
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return "Username tidak boleh kosong";
                    }
                    if (usernameError != null) {
                      return usernameError;
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: _passwordC,
                  obscureText: !showPass,
                  decoration: InputDecoration(
                    labelText: "Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        showPass ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => setState(() => showPass = !showPass),
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.length < 6 ? "Minimal 6 karakter" : null,
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: _confirmC,
                  obscureText: !showConfirm,
                  decoration: InputDecoration(
                    labelText: "Konfirmasi Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        showConfirm ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () =>
                          setState(() => showConfirm = !showConfirm),
                    ),
                  ),
                  validator: (v) =>
                      v != _passwordC.text ? "Password tidak sama" : null,
                ),

                const SizedBox(height: 25),

                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading ? null : register,
                    child: loading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text("Register"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
