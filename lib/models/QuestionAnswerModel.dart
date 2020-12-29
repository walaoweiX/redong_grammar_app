import 'package:flutter/foundation.dart';
import 'package:redong_grammar_app/models/QuestionAnswer.dart';

class QuestionAnswerModel extends ChangeNotifier {
  // QuestionAnswer _questionAnswer;
  List<List<String>> _correctAnswerList;
  List<List<String>> _userAnswerList;

  // set questionAnswer(QuestionAnswer questionAnswer) {
  //   _questionAnswer = questionAnswer;
  //   notifyListeners();
  // }

  void initializeList() {
    _correctAnswerList = new List<List<String>>();
    _userAnswerList = new List<List<String>>();
    notifyListeners();
  }

  void addCorrectAnswerToList(int questionNo, List<String> answer) {
    // answer.insert(0, "$questionNo");
    _correctAnswerList.add(answer);
    // debugPrint(_correctAnswerList.toString());
    notifyListeners();
  }

  void addUserAnswerToList(int questionNo, List<String> userAnswer) {
    // userAnswer.insert(0, "$questionNo");
    _userAnswerList.add(userAnswer);
    notifyListeners();
  }

  void checkAnswers(QuestionAnswer questionAnswer) {
    // debugPrint(_correctAnswerList.toString());
    int questionNo = questionAnswer.questionNo;
    List<String> correctAnswer = _correctAnswerList[questionNo];
    List<String> userAnswer = _userAnswerList[questionNo];
    bool isWrong = false;
    
    // print(_userAnswerList.toString());
    // print(_correctAnswerList.toString());

    for (int i = 0; i < correctAnswer.length; i++) {
      if (userAnswer[i] != correctAnswer[i]) {
        print("${userAnswer[i]}, ${correctAnswer[i]}");
        isWrong = true;
        break;
      }
    }

    if (isWrong) {
      questionAnswer.answerStatus = 3;
      isWrong = false;
    }
    else {
      questionAnswer.answerStatus = 2;
    }
    notifyListeners();
  }
}
