class QuestionAnswer {
  String _question;
  String _answer;
  int _answerStatus = 1; // 1 - not answered, 2 - right answer, 3 - wrong answer

  get question => _question;
  get answer => _answer;
  get answerStatus => _answerStatus;

  set answerStatus(int status) => _answerStatus = status;

  QuestionAnswer(this._question, this._answer);

}