// =============================
// views/home/home_empty.dart
// =============================
import 'package:flutter/material.dart';

class HomeEmpty extends StatelessWidget {
  final String? name;
  const HomeEmpty({super.key, this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Text(
              name != null ? "Halo, $name" : "Halo",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 120, color: Colors.grey.shade600),
                    const SizedBox(height: 20),
                    const Text(
                      "Belum ada hasil scan",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Silakan lakukan scan terlebih dahulu",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
