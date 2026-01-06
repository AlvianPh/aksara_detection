import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../controllers/scan_controller.dart';

class ScanMenuPage extends StatefulWidget {
  const ScanMenuPage({super.key});

  @override
  State<ScanMenuPage> createState() => _ScanMenuPageState();
}

class _ScanMenuPageState extends State<ScanMenuPage> {
  bool loading = false;
  final ImagePicker picker = ImagePicker();
  final ScanController scanController = ScanController();

  /// REQUEST PERMISSION + PICK IMAGE
  Future<void> _pickImage(ImageSource source) async {
    final permission =
        source == ImageSource.camera ? Permission.camera : Permission.photos;

    final status = await permission.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permission ditolak")),
      );
      return;
    }

    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      await _processImage(File(picked.path));
    }
  }

  /// PROCESS IMAGE
  Future<void> _processImage(File file) async {
    setState(() => loading = true);

    final result = await scanController.scanImage(file);

    setState(() => loading = false);

    if (result["status"] != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result["message"] ?? "Gagal scan")),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      '/scan_result',
      arguments: {
        "hasil": result["hasil"],
        "akurasi": result["akurasi"],
        "imagePath": file.path,
      },
    );
  }

  @override
  void dispose() {
    scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan Aksara")),
      body: Center(
        child: loading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Scan dari Kamera"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.image),
                    label: const Text("Pilih dari Galeri"),
                  ),
                ],
              ),
      ),
    );
  }
}
