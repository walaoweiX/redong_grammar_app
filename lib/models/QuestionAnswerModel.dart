import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:redong_grammar_app/models/QuestionAnswer.dart';

class QuestionAnswerModel extends ChangeNotifier {
  List<QuestionAnswer> _questionList;
  List<List<String>> _correctAnswerList;

  get questionList => _questionList;

  void initializeList() {
    _correctAnswerList = new List<List<String>>();
    _questionList = new List();
    notifyListeners();
  }

  void addQuestionToList(QuestionAnswer question) {
    _questionList.add(question);
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
