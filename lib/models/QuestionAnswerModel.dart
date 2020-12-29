import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:redong_grammar_app/models/QuestionAnswer.dart';

class QuestionAnswerModel extends ChangeNotifier {
  List<List<String>> _correctAnswerList;

  void initializeList() {
    _correctAnswerList = new List<List<String>>();
    notifyListeners();
  }

  void addCorrectAnswerToList(List<String> answer) {
    _correctAnswerList.add(answer);
    // debugPrint(_correctAnswerList.toString());
    notifyListeners();
  }

  void checkAnswers(
      QuestionAnswer questionAnswer, List<TextEditingController> userAnswer) {
    int questionNo = questionAnswer.questionNo;
    List<String> correctAnswer = _correctAnswerList[questionNo];
    bool isWrong = false;

    // debugPrint(_userAnswerList.toString());
    // debugPrint(_correctAnswerList.toString());

    for (int i = 0; i < correctAnswer.length; i++) {
      if (userAnswer[i].text != correctAnswer[i]) {
        isWrong = true;
        break;
      }
    }

    if (isWrong) {
      questionAnswer.answerStatus = 3;
      isWrong = false;
    } else {
      questionAnswer.answerStatus = 2;
    }
    notifyListeners();
  }
}
