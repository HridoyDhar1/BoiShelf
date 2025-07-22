import 'package:flutter/material.dart';

class SubmitButtonRow extends StatelessWidget {
  final VoidCallback onAnalyze;
  final VoidCallback onSubmit;

  const SubmitButtonRow({
    super.key,
    required this.onAnalyze,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Analyze Button
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black87,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              elevation: 1,
            ),
            onPressed: onAnalyze,
            child: const Text('Analyze'),
          ),
        ),
        const SizedBox(width: 10),
        // Submit Button
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black87,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              elevation: 1,
            ),
            onPressed: onSubmit,
            child: const Text('Submit'),
          ),
        ),
      ],
    );
  }
}
