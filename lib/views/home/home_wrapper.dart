import 'package:flutter/material.dart';
import '../../controllers/history_controller.dart';
import '../../utils/prefs.dart';
import 'home_empty.dart';
import 'home_with_history.dart';

class HomeWrapper extends StatefulWidget {
  final String? name;
  const HomeWrapper({super.key, this.name});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  bool loading = true;
  bool hasHistory = false;

  @override
  void initState() {
    super.initState();
    checkHistory();
  }

  Future<void> checkHistory() async {
    final token = await Prefs.getToken();
    if (token == null) {
      setState(() => loading = false);
      return;
    }

    final res = await HistoryController().getAllHistory(token);

    if (mounted) {
      setState(() {
        hasHistory = res["status"] == true && (res["data"] as List).isNotEmpty;
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return hasHistory
        ? HomeWithHistory(name: widget.name)
        : HomeEmpty(name: widget.name);
  }
}
