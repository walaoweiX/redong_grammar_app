import 'package:flutter/foundation.dart';
import 'package:redong_grammar_app/models/QuestionAnswer.dart';

class QuestionAnswerModel extends ChangeNotifier {
  QuestionAnswer _questionAnswer;
  final List<List<String>> _correctAnswerList = new List<List<String>>();
  final List<List<String>> _userAnswerList  = new List<List<String>>();

  set questionAnswer(QuestionAnswer questionAnswer) {
    _questionAnswer = questionAnswer;
    notifyListeners();
  }

  void addCorrectAnswerToList(int questionNo, List<String> answer) {
    answer.insert(0, "$questionNo");
    _correctAnswerList.add(answer);
    notifyListeners();
  }

  void addUserAnswerToList(int questionNo, List<String> userAnswer) {
    userAnswer.insert(0, "$questionNo");
    _userAnswerList.add(userAnswer);
    notifyListeners();
  }

  void setAnswerStatus(String a) {

  }
  // void setAnswerStatus(String userAnswer) {
  //   if (userAnswer == _questionAnswer.answer)
  //     _questionAnswer.answerStatus = 2;
  //   else if (userAnswer != _questionAnswer.answer)
  //     _questionAnswer.answerStatus = 3;
  //   else
  //     _questionAnswer.answerStatus = 1;
  //   notifyListeners();
  // }
}
