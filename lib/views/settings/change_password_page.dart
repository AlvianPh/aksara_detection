import 'package:flutter/material.dart';
import '/controllers/profile_controller.dart';
import '/utils/prefs.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final oldC = TextEditingController();
  final newC = TextEditingController();
  final confirmC = TextEditingController();
  final _controller = ProfileController();

  bool loading = false;

  bool showOld = false;
  bool showNew = false;
  bool showConfirm = false;

  Future save() async {
    if (oldC.text.isEmpty || newC.text.isEmpty || confirmC.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Semua field wajib diisi")));
      return;
    }

    if (newC.text != confirmC.text) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Konfirmasi password tidak sama")));
      return;
    }

    setState(() => loading = true);
    String? token = await Prefs.getToken();
    if (token == null) return;

    var result = await _controller.changePassword(
      token,
      oldC.text,
      newC.text,
      confirmC.text,
    );

    setState(() => loading = false);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(result["message"])));

    if (result["status"] == true) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ganti Password")),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: oldC,
                obscureText: !showOld,
                decoration: InputDecoration(
                  labelText: "Password Lama",
                  suffixIcon: IconButton(
                    icon:
                        Icon(showOld ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => showOld = !showOld),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newC,
                obscureText: !showNew,
                decoration: InputDecoration(
                  labelText: "Password Baru",
                  suffixIcon: IconButton(
                    icon:
                        Icon(showNew ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => showNew = !showNew),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmC,
                obscureText: !showConfirm,
                decoration: InputDecoration(
                  labelText: "Konfirmasi Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                        showConfirm ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => showConfirm = !showConfirm),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: loading ? null : save,
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Simpan"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
