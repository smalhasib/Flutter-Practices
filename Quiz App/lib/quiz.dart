import 'package:flutter/material.dart';

import './answer.dart';
import './question.dart';

class Quiz extends StatelessWidget {
  final Function selectHandler;
  final List<Map<String, Object>> questions;
  final int questionIndex;

  const Quiz({
    required this.selectHandler,
    required this.questions,
    required this.questionIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Question(questions[questionIndex]['questionText'] as String),
        ...(questions[questionIndex]['answers'] as List<Map<String, Object>>)
            .map((answer) => Answer(
                  answer['text'] as String,
                  () => selectHandler(answer['score']),
                ))
            .toList(),
      ],
    );
  }
}
