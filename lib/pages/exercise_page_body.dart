import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redong_grammar_app/models/QuestionAnswer.dart';
import 'package:redong_grammar_app/models/QuestionAnswerModel.dart';
import 'package:redong_grammar_app/pages/simple_answer_question.dart';
import 'package:redong_grammar_app/pages/underline_answer_question.dart';

class ExercisePageBody extends StatelessWidget {
  final List<List<TextEditingController>> userAnswerList;
  final String questionType;
  final TextStyle _questionTextStyle = TextStyle(height: 1.5, fontSize: 18);
  final double _defaultFontSize = 18.0;

  ExercisePageBody(
      {Key key, @required this.userAnswerList, @required this.questionType})
      : super(key: key);

  get mUserAnswerList => userAnswerList;
  get mQuestionType => questionType;

  @override
  Widget build(BuildContext context) {
    var questionList =
        context.select<QuestionAnswerModel, List<QuestionAnswer>>(
            (value) => value.questionList);

    debugPrint("rebuild all");

    return Container(
      child: Column(
        children: [
          Expanded(
            flex: 10,
            child: Container(
              child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) =>
                    Divider(),
                itemCount: questionList.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                        // border: Border.all(
                        //   color: Colors.grey[400],
                        // ),
                        ),
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: mQuestionType == "simple-answer"
                              ? SimpleAnswerQuestion(
                                  questionNo: index + 1,
                                  question: questionList[index],
                                  controller: mUserAnswerList[index],
                                  fontSize: _defaultFontSize,
                                  questionTextStyle: _questionTextStyle,
                                )
                              : mQuestionType == "underline-answer"
                                  ? UnderlineAnswerQuestion(
                                      questionNo: index + 1,
                                      question: questionList[index],
                                      controller: mUserAnswerList[index],
                                    )
                                  : Container(
                                      width: 0,
                                      height: 0,
                                    ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Consumer<QuestionAnswerModel>(
                            builder: (context, questionAnswer, child) {
                              return Center(
                                child: questionList[index].answerStatus == 2
                                    ? Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      )
                                    : questionList[index].answerStatus == 3
                                        ? Icon(
                                            Icons.clear,
                                            color: Colors.red,
                                          )
                                        : null,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Center(
                child: RaisedButton(
                  child: Text('Submit ${mUserAnswerList.length}'),
                  onPressed: () {
                    // debugPrint(_userAnswerList[0][0].text);
                    var questionAnswerModel =
                        context.read<QuestionAnswerModel>();
                    for (int i = 0; i < questionList.length; i++) {
                      questionAnswerModel.checkAnswers(
                          questionList[i], mUserAnswerList[i]);
                    }
                    // unfocusing keyboard
                    FocusScopeNode currentFocus = FocusScope.of(context);

                    if (!currentFocus.hasPrimaryFocus &&
                        currentFocus.focusedChild != null) {
                      FocusManager.instance.primaryFocus.unfocus();
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
