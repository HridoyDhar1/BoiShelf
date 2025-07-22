// import 'dart:io';
// import 'dart:math';
// import 'package:flutter/services.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

// class ConditionClassifier {
//   late Interpreter _interpreter;
//   late ImageProcessor _imageProcessor;
//   late TensorImage _inputImage;
//   final int inputSize = 224;

//   final labels = ['Good', 'Damaged']; // Manually define labels

//   Future<void> loadModel() async {
//     _interpreter = await Interpreter.fromAsset('mobilenetv2.tflite');
//   }

//   TensorImage _preprocess(File imageFile) {
//     // Load image
//     _inputImage = TensorImage.fromFile(imageFile);

//     // Resize + normalize
//     _imageProcessor = ImageProcessorBuilder()
//         .add(ResizeOp(inputSize, inputSize, ResizeMethod.BILINEAR))
//         .add(NormalizeOp(127.5, 127.5)) // same as MobileNet normalization
//         .build();

//     _inputImage = _imageProcessor.process(_inputImage);
//     return _inputImage;
//   }

//   Future<Map<String, dynamic>> predict(File imageFile) async {
//     _inputImage = _preprocess(imageFile);

//     // Allocate output buffer
//     var outputBuffer = TensorBuffer.createFixedSize(<int>[1, 2], TfLiteType.float32);

//     // Run inference
//     _interpreter.run(_inputImage.buffer, outputBuffer.buffer);

//     // Get results
//     List<double> scores = outputBuffer.getDoubleList();
//     int maxIndex = scores.indexOf(scores.reduce(max));
//     String predictedLabel = labels[maxIndex];
//     double confidence = scores[maxIndex];

//     return {
//       'label': predictedLabel,
//       'confidence': confidence,
//     };
//   }

//   void close() {
//     _interpreter.close();
//   }
// }
