import 'package:flutter/material.dart';
import 'package:redong_grammar_app/models/QuestionAnswer.dart';
import 'package:provider/provider.dart';
import 'package:redong_grammar_app/models/QuestionAnswerModel.dart';

class SimpleAnswerQuestion extends StatelessWidget {
  final int questionNo;
  final QuestionAnswer question;
  final List<TextEditingController> controller;
  final double fontSize;
  final TextStyle questionTextStyle;
  // double fontSize = 18.0;

  SimpleAnswerQuestion(
      {Key key,
      @required this.questionNo,
      @required this.question,
      @required this.controller,
      this.fontSize,
      this.questionTextStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var question = context.select<QuestionAnswerModel, String>(
        (value) => value.questionList[questionNo-1].question);
    var questionToList = question.split(" ");
    int count = 0;
    debugPrint("rebuild simple answer question");

    return Text.rich(
      TextSpan(
        text: '$questionNo. ',
        style: TextStyle(fontSize: fontSize),
        children: List.generate(
          questionToList.length,
          (index) {
            if (questionToList[index] == '___' ||
                questionToList[index] == '___.' ||
                questionToList[index] == '___,') {
              if (count < controller.length) {
                count++;
              }

              return WidgetSpan(
                alignment: PlaceholderAlignment.baseline,
                baseline: TextBaseline.alphabetic,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 150,
                  ),
                  child: TextField(
                    // maxLength: 15,
                    // maxLengthEnforced: true,
                    controller: controller[count - 1],
                    decoration:
                        InputDecoration.collapsed(hintText: '___________'),
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            // element[index]
            else if (index > 1 &&
                index < questionToList.length - 1 &&
                questionToList[index - 1].contains('.') &&
                !questionToList[index - 1].contains(new RegExp(r'Mr.|Mrs.'))) {
              return TextSpan(
                  text: '. ${questionToList[index]}', style: questionTextStyle);
            } else if (index > 1 &&
                index < questionToList.length - 1 &&
                questionToList[index - 1].contains(',')) {
              return TextSpan(
                  text: ', ${questionToList[index]}', style: questionTextStyle);
            } else if (questionToList[index]
                .contains(new RegExp(r'[a-zA-Z]'))) {
              return TextSpan(
                text: ' ${questionToList[index]}',
                style: questionTextStyle,
              );
            } else {
              return TextSpan(text: "");
            }
          },
          // growable: false,
        ),
      ),
    );
  }
}
