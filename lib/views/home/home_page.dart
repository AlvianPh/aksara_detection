import 'package:flutter/material.dart';
import '../home/home_wrapper.dart';
import '../scan/scan_menu.dart';
import '../settings/settings_page.dart';
import '../../controllers/profile_controller.dart';
import '../../utils/prefs.dart';

class HomePage extends StatefulWidget {
  final bool hasHistory;

  const HomePage({super.key, this.hasHistory = false});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  String? name;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  loadProfile() async {
    final token = await Prefs.getToken();
    if (token == null) return;

    final res = await ProfileController().getProfile(token);
    if (res["status"] == true) {
      setState(() => name = res["data"]["name"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeWrapper(name: name),
      ScanMenuPage(),
      SettingsPage(),
    ];

    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (i) => setState(() => currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.camera_alt), label: "Scan"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}
