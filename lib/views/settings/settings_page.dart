import 'package:flutter/material.dart';
import '/views/settings/edit_profile_page.dart';
import '/views/settings/change_password_page.dart';
import '/utils/prefs.dart';
import '/controllers/profile_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // ================= LOGOUT =================
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Apakah kamu yakin ingin logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await Prefs.clear();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/login",
                  (_) => false,
                );
              }
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  // ================= DELETE ACCOUNT =================
  void _confirmDeleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Akun"),
        content: const Text(
          "Akun akan dihapus secara permanen.\n"
          "Semua data tidak bisa dikembalikan.\n\n"
          "Lanjutkan?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);

              final token = await Prefs.getToken();
              if (token == null) return;

              final res = await ProfileController().deleteUser(token);

              if (res["status"] == true) {
                await Prefs.clear();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    "/login",
                    (_) => false,
                  );
                }
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        res["message"] ?? "Gagal menghapus akun",
                      ),
                    ),
                  );
                }
              }
            },
            child: const Text("Hapus Akun"),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _card({required List<Widget> children}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(children: children),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ================= AKUN =================
          _sectionTitle("Akun"),
          _card(
            children: [
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text("Edit Profil"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditProfilePage(),
                    ),
                  );
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.lock_outline),
                title: const Text("Ganti Password"),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChangePasswordPage(),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // ================= KEAMANAN =================
          _sectionTitle("Keamanan"),
          _card(
            children: [
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Logout"),
                onTap: () => _confirmLogout(context),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text(
                  "Hapus Akun",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () => _confirmDeleteAccount(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
