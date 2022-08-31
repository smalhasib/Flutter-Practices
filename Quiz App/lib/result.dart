import 'package:flutter/material.dart';

class Result extends StatelessWidget {
  final int resultScore;
  final VoidCallback resetHandler;

  Result(this.resultScore, this.resetHandler);

  String get resultPhrase {
    String resultText = "End of Questions!!";
    if (resultScore <= 8) {
      resultText = "Awesome";
    } else if (resultScore <= 12) {
      resultText = "Pretty";
    } else if (resultScore <= 16) {
      resultText = "Strange";
    } else {
      resultText = "Savage";
    }

    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            resultPhrase,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: resetHandler,
            style: TextButton.styleFrom(primary: Colors.deepOrangeAccent),
            child: const Text('Restart Quiz!'),
          ),
        ],
      ),
    );
  }
}
