import 'dart:io';
import 'package:flutter/material.dart';

class ScanResultPage extends StatelessWidget {
  const ScanResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    final route = ModalRoute.of(context);

    if (route == null || route.settings.arguments == null) {
      return const Scaffold(
        body: Center(child: Text("Data hasil scan tidak tersedia")),
      );
    }

    final args = route.settings.arguments as Map<String, dynamic>;

    final String hasil = args['hasil'] ?? "-";
    final String akurasi = args['akurasi'] ?? "0";
    final String? imagePath = args['imagePath'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hasil Scan"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ================= IMAGE =================
            if (imagePath != null && imagePath.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(
                  File(imagePath),
                  width: double.infinity,
                  height: 260,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(
                height: 260,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.image_not_supported,
                  size: 60,
                  color: Colors.grey,
                ),
              ),

            const SizedBox(height: 30),

            // ================= RESULT =================
            Text(
              hasil.toUpperCase(),
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Aksara terdeteksi",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 20),

            // ================= ACCURACY =================
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  const Text(
                    "Tingkat Keyakinan",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "$akurasi %",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // ================= BUTTON =================
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text("Scan Lagi"),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
