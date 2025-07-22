// import 'dart:io';
// import 'package:image/image.dart' as image;
// import 'package:tflite_flutter/tflite_flutter.dart';

// class BookConditionClassifier {
//   final String modelPath = 'assets/ml/mobilenetv2.tflite';
//   late Interpreter _interpreter;
//   final int inputSize = 224;

//   /// Call this before prediction
//   Future<void> init() async {
//     _interpreter = await Interpreter.fromAsset(modelPath);
//   }

//   Future<String> predict(File imageFile) async {
//     final rawImage = image.decodeImage(await imageFile.readAsBytes());

//     if (rawImage == null) {
//       throw Exception("Could not decode image.");
//     }

//     final resizedImage = image.copyResize(rawImage, width: inputSize, height: inputSize);

//     final input = _imageToFloat32(resizedImage);

//     final output = List.filled(2, 0.0).reshape([1, 2]);

//     _interpreter.run(input, output);

//     final result = output[0];
//     final predictedIndex = result.indexOf(result.reduce((a, b) => a > b ? a : b));
//     return predictedIndex == 0 ? "Good" : "Damaged";
//   }

//   List<List<List<List<double>>>> _imageToFloat32(image.Image img) {
//     return List.generate(1, (_) =>
//       List.generate(inputSize, (y) =>
//         List.generate(inputSize, (x) {
//           final pixel = img.getPixel(x, y);
//           final r = image.getRed(pixel) / 127.5 - 1.0;
//           final g = image.getGreen(pixel) / 127.5 - 1.0;
//           final b = image.getBlue(pixel) / 127.5 - 1.0;
//           return [r, g, b];
//         })
//       )
//     );
//   }

//   void close() {
//     _interpreter.close();
//   }
// }
