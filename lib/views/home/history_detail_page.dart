import 'package:flutter/material.dart';
import '../../controllers/history_controller.dart';
import '../../utils/prefs.dart';

class HistoryDetailPage extends StatefulWidget {
  final int id;
  const HistoryDetailPage({required this.id});

  @override
  State<HistoryDetailPage> createState() => _HistoryDetailPageState();
}

class _HistoryDetailPageState extends State<HistoryDetailPage> {
  bool loading = true;
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    final token = await Prefs.getToken();
    if (token == null) return;

    final result = await HistoryController().getHistoryById(token, widget.id);

    if (result["status"] == true) {
      setState(() {
        data = result["data"];
        loading = false;
      });
    } else {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["message"] ?? "Gagal memuat data")),
      );
    }
  }

  Future<void> _deleteHistory() async {
    final token = await Prefs.getToken();
    if (token == null) return;

    bool confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Hapus Riwayat"),
        content: Text("Yakin ingin menghapus riwayat ini?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text("Batal")),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text("Hapus")),
        ],
      ),
    );

    if (!confirm) return;

    final result = await HistoryController().deleteHistory(token, widget.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result["message"] ?? "Gagal hapus")),
    );

    if (result["status"] == true) {
      Navigator.pop(context, true); // Kembali ke list history
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail History"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteHistory,
          )
        ],
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : data == null
              ? Center(child: Text("Data tidak ditemukan"))
              : SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          data!['foto'],
                          width: double.infinity,
                          height: 230,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              Container(height: 230, color: Colors.grey[300]),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Hasil: ${data!['hasil']}",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text("Akurasi: ${data!['akurasi']}%",
                          style: TextStyle(fontSize: 18)),
                      SizedBox(height: 10),
                      Text(
                        "Tanggal: ${data!['createdAt']}",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
    );
  }
}
