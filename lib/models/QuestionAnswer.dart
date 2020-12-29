class QuestionAnswer {
  int _questionNo;
  String _question;
  String _answer;
  int _answerStatus; // 1 - not answered, 2 - right answer, 3 - wrong answer

  get questionNo => _questionNo;
  get question => _question;
  get answer => _answer;
  get answerStatus => _answerStatus;

  set answerStatus(int status) {
    _answerStatus =  status;
  }

  QuestionAnswer(this._questionNo, this._question, this._answer) {
    _answerStatus = 1;
  }
}