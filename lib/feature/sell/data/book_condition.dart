import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'dart:math' as math;

class BookConditionDetector {
  static const String _modelPath = 'assets/mobilenetv2.tflite';
  static const int _inputSize = 224;
  static const int _numChannels = 3;

  Interpreter? _interpreter;
  bool _isModelLoaded = false;
  final List<String> _labels = ['Good', 'Damaged'];

  /// Initialize and load the TensorFlow Lite model with better error handling
  Future<bool> loadModel() async {
    try {
      // First check if the asset exists
      try {
        await rootBundle.load(_modelPath);
        print('✅ Model file found in assets');
      } catch (e) {
        print('❌ Model file not found in assets: $e');
        print('Make sure mobilenetv2.tflite is in assets/ folder and listed in pubspec.yaml');
        return false;
      }

      final options = InterpreterOptions();

      // Try GPU acceleration with better error handling
      if (Platform.isAndroid) {
        try {
          options.addDelegate(GpuDelegateV2());
          print('✅ GPU acceleration enabled (Android)');
        } catch (e) {
          print('⚠️ GPU acceleration not available (Android): $e');
        }
      } else if (Platform.isIOS) {
        try {
          options.addDelegate(GpuDelegate());
          print('✅ GPU acceleration enabled (iOS)');
        } catch (e) {
          print('⚠️ GPU acceleration not available (iOS): $e');
        }
      }

      _interpreter = await Interpreter.fromAsset(_modelPath, options: options);
      _isModelLoaded = true;

      // Debug model information
      final inputTensor = _interpreter!.getInputTensor(0);
      final outputTensor = _interpreter!.getOutputTensor(0);

      print('=== MODEL LOADED SUCCESSFULLY ===');
      print('Input shape: ${inputTensor.shape}');
      print('Input type: ${inputTensor.type}');
      print('Output shape: ${outputTensor.shape}');
      print('Output type: ${outputTensor.type}');
      print('Expected input size: $_inputSize x $_inputSize x $_numChannels');
      print('Labels: $_labels');
      print('===============================');

      return true;
    } catch (e, stackTrace) {
      print('❌ Error loading model: $e');
      print('Stack trace: $stackTrace');
      _isModelLoaded = false;
      return false;
    }
  }

  /// Fixed image preprocessing with better pixel access
  Float32List _preprocessImage(img.Image image) {
    // Resize image to model input size
    img.Image resizedImage = img.copyResize(
      image,
      width: _inputSize,
      height: _inputSize,
      interpolation: img.Interpolation.linear,
    );

    print('✅ Image resized to ${resizedImage.width}x${resizedImage.height}');

    Float32List inputBuffer = Float32List(_inputSize * _inputSize * _numChannels);
    int pixelIndex = 0;

    for (int y = 0; y < _inputSize; y++) {
      for (int x = 0; x < _inputSize; x++) {
        img.Pixel pixel = resizedImage.getPixel(x, y);

        // Fixed pixel access - convert to double safely
        double r = (pixel.r as num).toDouble();
        double g = (pixel.g as num).toDouble();
        double b = (pixel.b as num).toDouble();

        // Normalize to [-1, 1] for MobileNetV2
        inputBuffer[pixelIndex++] = (r / 127.5) - 1.0;
        inputBuffer[pixelIndex++] = (g / 127.5) - 1.0;
        inputBuffer[pixelIndex++] = (b / 127.5) - 1.0;
      }
    }

    print('✅ Image preprocessed: ${inputBuffer.length} values');
    return inputBuffer;
  }

  /// Fixed tensor reshaping
  List<List<List<List<double>>>> _reshapeInput(Float32List input) {
    List<List<List<List<double>>>> reshaped = [];
    List<List<List<double>>> batch = [];

    for (int y = 0; y < _inputSize; y++) {
      List<List<double>> row = [];
      for (int x = 0; x < _inputSize; x++) {
        List<double> pixel = [];
        int baseIndex = (y * _inputSize + x) * _numChannels;

        for (int c = 0; c < _numChannels; c++) {
          pixel.add(input[baseIndex + c]);
        }
        row.add(pixel);
      }
      batch.add(row);
    }

    reshaped.add(batch);
    return reshaped;
  }

  /// Main detection method with comprehensive error handling
  Future<BookConditionResult?> detectConditionFromFile(File imageFile) async {
    if (!_isModelLoaded || _interpreter == null) {
      print('❌ Model not loaded or interpreter is null');
      print('Model loaded status: $_isModelLoaded');
      print('Interpreter null: ${_interpreter == null}');
      return null;
    }

    try {
      print('🔍 Starting detection for: ${imageFile.path}');
      print('File exists: ${await imageFile.exists()}');

      // Load and decode image
      final imageBytes = await imageFile.readAsBytes();
      print('✅ Image bytes loaded: ${imageBytes.length} bytes');

      img.Image? image = img.decodeImage(imageBytes);

      if (image == null) {
        print('❌ Failed to decode image - possibly corrupted or unsupported format');
        return null;
      }

      print('✅ Image decoded successfully: ${image.width}x${image.height}');

      // Preprocess image
      Float32List inputBuffer = _preprocessImage(image);

      // Prepare input tensor - try different approaches
      var input = _reshapeInput(inputBuffer);

      // Prepare output tensor based on model output shape
      var output = List.generate(1, (index) => List.filled(_labels.length, 0.0));

      print('🔍 Running inference...');
      print('Input shape: [1, $_inputSize, $_inputSize, $_numChannels]');
      print('Expected output length: ${_labels.length}');

      // Run inference
      _interpreter!.run(input, output);

      print('✅ Inference completed successfully');

      // Process results
      List<double> probabilities = output[0];
      print('📊 Raw output probabilities: $probabilities');

      // Apply softmax normalization
      probabilities = _applySoftmax(probabilities);
      print('📊 Normalized probabilities: $probabilities');

      // Find the class with highest probability
      int maxIndex = 0;
      double maxProbability = probabilities[0];

      for (int i = 1; i < probabilities.length; i++) {
        if (probabilities[i] > maxProbability) {
          maxProbability = probabilities[i];
          maxIndex = i;
        }
      }

      final result = BookConditionResult(
        condition: _labels[maxIndex],
        confidence: maxProbability,
        probabilities: Map.fromIterables(_labels, probabilities),
      );

      print('🎯 Final detection result: $result');
      return result;

    } catch (e, stackTrace) {
      print('❌ Error during inference: $e');
      print('Error type: ${e.runtimeType}');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Legacy method for backward compatibility
  Future<BookConditionResult?> detectCondition(String imagePath) async {
    return await detectConditionFromFile(File(imagePath));
  }

  /// Apply softmax activation to convert logits to probabilities
  List<double> _applySoftmax(List<double> logits) {
    if (logits.isEmpty) return [];

    // Find max value for numerical stability
    double maxLogit = logits.reduce((a, b) => a > b ? a : b);

    // Calculate exponentials
    List<double> exponentials = logits.map((logit) =>
        math.exp(logit - maxLogit)).toList();

    // Calculate sum of exponentials
    double sumExp = exponentials.reduce((a, b) => a + b);

    // Avoid division by zero
    if (sumExp == 0) {
      return List.filled(logits.length, 1.0 / logits.length);
    }

    // Calculate softmax probabilities
    return exponentials.map((exp) => exp / sumExp).toList();
  }

  /// Debug method to test the detector step by step
  Future<void> debugDetection(File imageFile) async {
    print('\n=== DEBUGGING BOOK CONDITION DETECTION ===');
    print('📱 Model loaded: $_isModelLoaded');
    print('📁 Image path: ${imageFile.path}');
    print('📄 Image exists: ${await imageFile.exists()}');
    print('🔧 Interpreter available: ${_interpreter != null}');

    if (!_isModelLoaded) {
      print('⚠️ Model not loaded, attempting to reload...');
      final loaded = await loadModel();
      print('🔄 Reload result: $loaded');
    }

    if (await imageFile.exists()) {
      final result = await detectConditionFromFile(imageFile);
      print('📊 Detection result: $result');
    } else {
      print('❌ Image file does not exist');
    }

    print('=== DEBUG COMPLETE ===\n');
  }

  /// Dispose of the interpreter
  void dispose() {
    try {
      _interpreter?.close();
      print('✅ Model interpreter disposed');
    } catch (e) {
      print('⚠️ Error disposing interpreter: $e');
    }
    _isModelLoaded = false;
  }

  bool get isModelLoaded => _isModelLoaded;
}

/// Result class for book condition detection
class BookConditionResult {
  final String condition;
  final double confidence;
  final Map<String, double> probabilities;

  BookConditionResult({
    required this.condition,
    required this.confidence,
    required this.probabilities,
  });

  @override
  String toString() {
    return 'BookConditionResult(condition: $condition, confidence: ${(confidence * 100).toStringAsFixed(1)}%, probabilities: $probabilities)';
  }
}