import 'package:flutter/material.dart';
import '../../controllers/history_controller.dart';
import '../../utils/prefs.dart';

class HomeWithHistory extends StatefulWidget {
  final String? name;
  const HomeWithHistory({super.key, this.name});

  @override
  State<HomeWithHistory> createState() => _HomeWithHistoryState();
}

class _HomeWithHistoryState extends State<HomeWithHistory> {
  final HistoryController _historyController = HistoryController();
  List<dynamic> history = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  Future<void> loadHistory() async {
    setState(() => isLoading = true);

    final token = await Prefs.getToken();
    if (token == null) {
      setState(() => isLoading = false);
      return;
    }

    final res = await _historyController.getAllHistory(token);

    if (!mounted) return;

    setState(() {
      if (res["status"] == true && res["data"] is List) {
        history = res["data"];
      } else {
        history = [];
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Scan"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                /// ===== GREETING =====
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    widget.name != null ? "Halo, ${widget.name}" : "Halo",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// ===== LIST HISTORY =====
                Expanded(
                  child: history.isEmpty
                      ? const Center(
                          child: Text(
                            "Belum ada riwayat",
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: history.length,
                          itemBuilder: (context, index) {
                            final item = history[index];

                            return Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                leading: _buildImage(item["foto"]),
                                title: Text(
                                  "Hasil: ${item['hasil']}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  "Akurasi: ${item['akurasi']}%",
                                ),
                                onTap: () async {
                                  final deleted = await Navigator.pushNamed(
                                    context,
                                    '/history_detail',
                                    arguments: item["id"],
                                  );

                                  if (deleted == true) {
                                    loadHistory(); // refresh setelah hapus
                                  }
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  /// ===== IMAGE HANDLER =====
  Widget _buildImage(String? url) {
    if (url == null || url.isEmpty) {
      return const Icon(Icons.image_not_supported);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        url,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
      ),
    );
  }
}
