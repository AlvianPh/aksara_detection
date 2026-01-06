import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import '/controllers/history_controller.dart';
import '/utils/prefs.dart';

class ScanController {
  Interpreter? _interpreter;
  Tensor? _inputTensor;
  Tensor? _outputTensor;

  final HistoryController _historyController = HistoryController();

  final Map<int, String> labels = {
    0: "ba",
    1: "ca",
    2: "da",
    3: "dha",
    4: "ga",
    5: "ha",
    6: "ja",
    7: "ka",
    8: "la",
    9: "ma",
    10: "na",
    11: "nga",
    12: "nya",
    13: "pa",
    14: "ra",
    15: "sa",
    16: "ta",
    17: "tha",
    18: "wa",
    19: "ya",
  };

  /// --------------------------------------------------
  /// LOAD MODEL (sekali)
  /// --------------------------------------------------
  Future<void> _loadModel() async {
    if (_interpreter != null) return;

    _interpreter = await Interpreter.fromAsset(
      'assets/model/aksara_hybrid_int8.tflite',
    );

    _inputTensor = _interpreter!.getInputTensor(0);
    _outputTensor = _interpreter!.getOutputTensor(0);

    print("INPUT TENSOR  : $_inputTensor");
    print("OUTPUT TENSOR : $_outputTensor");
  }

  /// --------------------------------------------------
  /// SCAN IMAGE (FINAL)
  /// --------------------------------------------------
  Future<Map<String, dynamic>> scanImage(File imageFile) async {
    try {
      if (!imageFile.existsSync()) {
        return {"status": false, "message": "File gambar tidak ditemukan"};
      }

      await _loadModel();

      /// Decode image
      final bytes = imageFile.readAsBytesSync();
      img.Image? image = img.decodeImage(bytes);
      if (image == null) {
        return {"status": false, "message": "Gagal decode image"};
      }

      /// Resize ke 224x224
      final resized = img.copyResize(image, width: 224, height: 224);

      /// INT8 quantization
      final scale = _inputTensor!.params.scale;
      final zeroPoint = _inputTensor!.params.zeroPoint;

      final input = List.generate(
        1,
        (_) => List.generate(
          224,
          (y) => List.generate(
            224,
            (x) {
              final pixel = resized.getPixel(x, y);

              int q(int v) =>
                  max(-128, min(127, ((v / scale) + zeroPoint).round()));

              return [
                q(pixel.r.toInt()),
                q(pixel.g.toInt()),
                q(pixel.b.toInt()),
              ];
            },
          ),
        ),
      );

      final output = List.generate(1, (_) => List.filled(20, 0));

      _interpreter!.run(input, output);

      /// Dequant output
      final outScale = _outputTensor!.params.scale;
      final outZero = _outputTensor!.params.zeroPoint;

      final probs =
          output[0].map<double>((e) => (e - outZero) * outScale).toList();

      final maxIdx = probs.indexOf(probs.reduce((a, b) => a > b ? a : b));

      final accuracy = probs[maxIdx] * 100;
      final hasil = labels[maxIdx] ?? "-";

      /// Save history
      final token = await Prefs.getToken();
      if (token != null) {
        await _historyController.saveHistory(
          token,
          hasil,
          accuracy.toStringAsFixed(2),
          imageFile,
        );
      }

      return {
        "status": true,
        "hasil": hasil,
        "akurasi": accuracy.toStringAsFixed(2),
      };
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
  }
}
