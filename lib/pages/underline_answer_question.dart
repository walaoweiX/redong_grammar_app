import 'package:flutter/material.dart';
import 'package:redong_grammar_app/models/QuestionAnswer.dart';

class UnderlineAnswerQuestion extends StatefulWidget {
  final int questionNo;
  final QuestionAnswer question;
  final List<TextEditingController> controller;

  UnderlineAnswerQuestion(
      {Key key,
      @required this.questionNo,
      @required this.question,
      @required this.controller})
      : super(key: key);

  @override
  _UnderlineAnswerQuestionState createState() =>
      _UnderlineAnswerQuestionState();
}

class _UnderlineAnswerQuestionState extends State<UnderlineAnswerQuestion> {
  List<String> _answerGroup;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _answerGroup = widget.question.getAnswerChoices();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "${widget.questionNo}. ${widget.question.question}",
        ),
        Column(
          children: List.generate(
            _answerGroup.length,
            (index) => RadioListTile<String>(
              title: Text(_answerGroup[index]),
              value: _answerGroup[index],
              groupValue: widget.controller[0].text,
              onChanged: (value) {
                setState(() {
                  widget.controller[0].text = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}