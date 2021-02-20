class QuestionAnswer {
  int _questionNo;
  String _question;
  String _answer;
  final RegExp _pattern = RegExp(r'\(.+?\)');
  int _answerStatus; // 1 - not answered, 2 - right answer, 3 - wrong answer

  get questionNo => _questionNo;
  get question => _question;
  get answer => _answer;
  // ignore: unnecessary_getters_setters
  get answerStatus => _answerStatus;

  // ignore: unnecessary_getters_setters
  set answerStatus(int status) {
    _answerStatus = status;
  }

  QuestionAnswer(this._questionNo, this._question, this._answer) {
    _answerStatus = 1;
  }

  List<String> getAnswerChoices() {
    List<String> a = [];
    String b = "";

    _pattern.allMatches(_question).forEach((element) {
      b = _question.substring(element.start + 1, element.end - 1);
    });
    a = b.split(", ");
    return a;
  }
}