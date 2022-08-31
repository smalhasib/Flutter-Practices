import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final String answer;
  final VoidCallback selectHandler;

  const Answer(this.answer, this.selectHandler);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(primary: Colors.deepOrangeAccent),
        onPressed: selectHandler,
        child: Text(answer),
      ),
    );
  }
}
