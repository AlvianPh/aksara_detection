import 'package:flutter/material.dart';
import '/views/home/home_page.dart';
import '../../controllers/auth_controller.dart';
import '../../utils/prefs.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final AuthController authC = AuthController();

  bool isLoading = false;
  bool obscurePass = true;

  Future<void> doLogin() async {
    if (usernameC.text.trim().isEmpty || passwordC.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username dan password wajib diisi")),
      );
      return;
    }

    setState(() => isLoading = true);

    final result = await authC.login(
      usernameC.text.trim(),
      passwordC.text.trim(),
    );

    if (!mounted) return;
    setState(() => isLoading = false);

    // ==========================
    // LOGIN BERHASIL
    // ==========================
    if (result["status"] == true) {
      final token = result["data"]["token"];

      await Prefs.setToken(token);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    }
    // ==========================
    // LOGIN GAGAL
    // ==========================
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result["message"] ?? "Username atau password salah",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 150,
                ),
              ),

              const SizedBox(height: 30),
              const Text(
                'Selamat Datang',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              // Username
              TextField(
                controller: usernameC,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Username',
                ),
              ),

              const SizedBox(height: 15),

              // Password
              TextField(
                controller: passwordC,
                obscureText: obscurePass,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePass ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () => setState(() => obscurePass = !obscurePass),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/register'),
                child: const Text(
                  'Registrasi akun baru',
                  style: TextStyle(color: Colors.blue),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: isLoading ? null : doLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
