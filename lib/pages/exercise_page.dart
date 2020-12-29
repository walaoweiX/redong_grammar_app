import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redong_grammar_app/models/QuestionAnswer.dart';
import 'package:redong_grammar_app/models/QuestionAnswerModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:strings/strings.dart';

class ExercisePage extends StatefulWidget {
  final String title;
  final Database database;
  final int exerciseNo;

  const ExercisePage({Key key, this.title, this.database, this.exerciseNo})
      : super(key: key);

  @override
  _ExercisePageState createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  var _textStyle1 =
      TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500);
  var _questionTextStyle = TextStyle(height: 1.5, fontSize: 18);
  String _questionType = "";
  String _instruction = "";
  List<QuestionAnswer> _questionList;
  List<List<TextEditingController>> _userAnswerList;
  List<TextEditingController> _answer;
  TextEditingController _controller;
  int _count;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _userAnswerList.forEach((list) {
      list.forEach((controller2) {
        controller2.dispose();
      });
    });
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild all");
    return FutureBuilder(
      future: load(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error occured'),
          );
        } else if (snapshot.hasData) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                titleSpacing: 0,
                title: ListTile(
                  title: Text(
                    camelize(this.widget.title),
                    style: _textStyle1,
                  ),
                  subtitle: Text(
                    '$_instruction',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              body: Container(
                child: Column(
                  children: [
                    Expanded(
                      flex: 10,
                      child: Container(
                        child: ListView.builder(
                          itemCount: _questionList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey[400],
                                ),
                              ),
                              padding: EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: _questionType == "simple-answer"
                                        ? _buildSimpleQuestion(
                                            index + 1,
                                            _questionList[index],
                                            _userAnswerList[index])
                                        : Container(
                                            width: 0,
                                            height: 0,
                                          ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Consumer<QuestionAnswerModel>(
                                      builder:
                                          (context, questionAnswer, child) {
                                        return Center(
                                          child: _questionList[index]
                                                      .answerStatus ==
                                                  2
                                              ? Icon(
                                                  Icons.check,
                                                  color: Colors.green,
                                                )
                                              : _questionList[index]
                                                          .answerStatus ==
                                                      3
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
                            child: Text('Submit ${_userAnswerList.length}'),
                            onPressed: () {
                              var questionAnswerModel =
                                  context.read<QuestionAnswerModel>();
                              for (int i = 0; i < _questionList.length; i++) {
                                questionAnswerModel.checkAnswers(
                                    _questionList[i]);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Future<int> load() async {
    _count = 0;
    var getInstruction = await widget.database.query(
      'InstructionList',
      columns: ['instruction', 'question_type'],
      where: 'topic = ? AND exercise = ?',
      whereArgs: ['${widget.title}', '${widget.exerciseNo}'],
    );
    _instruction = getInstruction[0].values.elementAt(0);
    _questionType = getInstruction[0].values.elementAt(1);

    List<Map> getQuestions = await widget.database.query(
      'QuestionList',
      columns: ['question', 'answer'],
      where: '"topic" = ? AND "exercise" = ?',
      whereArgs: ['${widget.title}', '${widget.exerciseNo}'],
    );
    _questionList = new List();
    _userAnswerList = new List();
    context.read<QuestionAnswerModel>().initializeList();
    int count = 0;

    // _userAnswerList.forEach((element) {
      
    // });
    print(getQuestions.length);

    for (int i = 0; i < getQuestions.length; i++) {
      List<String> answerList = getQuestions[i]['answer'].split(', ');
      // debugPrint(answerList.toString());
      context
          .read<QuestionAnswerModel>()
          .addCorrectAnswerToList(count, answerList);
      
      // creating a temporary list to be inserted into addUserAnswerToList() function
      List<String> a = new List();

      // creating a temporary list to be inserted into _userAnswerList() function
      List<TextEditingController> b = new List();

      // debugPrint(answerList.join(" "));

      answerList.forEach((answer) {
        // print(answer);
        _controller = new TextEditingController();
        a.add(_controller.text);
        b.add(_controller);
      });
      _userAnswerList.add(b);
      context.read<QuestionAnswerModel>().addUserAnswerToList(count, a);
      _questionList
          .add(new QuestionAnswer(count, getQuestions[i]['question'], getQuestions[i]['answer']));
      count++;
    }

    // getQuestions.forEach((element) {
      // List<String> answerList = element['answer'].split(',');
      
      // context
      //     .read<QuestionAnswerModel>()
      //     .addCorrectAnswerToList(count, answerList);

      // creating a temporary list to be inserted into addUserAnswerToList() function
      // List<String> a = new List();

      // // creating a temporary list to be inserted into _userAnswerList() function
      // List<TextEditingController> b = new List();

      // // debugPrint(answerList.join(" "));

      // answerList.forEach((answer) {
      //   // print(answer);
      //   _controller = new TextEditingController();
      //   a.add(_controller.text);
      //   b.add(_controller);
      // });
      // _userAnswerList.add(b);
      // context.read<QuestionAnswerModel>().addUserAnswerToList(count, a);
      // _questionList
      //     .add(new QuestionAnswer(count, element['question'], element['answer']));
      // count++;
    // });

    return 1;
  }

  Text _buildSimpleQuestion(int questionNo, QuestionAnswer question,
      List<TextEditingController> controller) {
    double fontSize = 18.0;
    int count = 0;
    List<String> questionToList = question.question.split(' ');
    // _answer = new List();

    // questionToList.forEach((element) {
    //   if (element == "___") _answer.add(new TextEditingController());
    // });

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
              // count++;

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
                    controller: controller[count-1],
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
                  text: '. ${questionToList[index]}',
                  style: _questionTextStyle);
            } else if (index > 1 &&
                index < questionToList.length - 1 &&
                questionToList[index - 1].contains(',')) {
              return TextSpan(
                  text: ', ${questionToList[index]}',
                  style: _questionTextStyle);
            } else if (questionToList[index]
                .contains(new RegExp(r'[a-zA-Z]'))) {
              return TextSpan(
                text: ' ${questionToList[index]}',
                style: _questionTextStyle,
              );
            } else {
              return TextSpan(text: "");
            }
          },
          // growable: false,
        ),
      ),
    );

    // return Text.rich(
    //   TextSpan(
    //     text: '1. ',
    //     style: TextStyle(fontSize: 20),
    //     children: [
    //       WidgetSpan(
    //         alignment: PlaceholderAlignment.baseline,
    //         baseline: TextBaseline.alphabetic,
    //         child: ConstrainedBox(
    //           constraints: BoxConstraints(
    //             maxWidth: 100,
    //           ),
    //           child: TextField(
    //             // maxLength: 15,
    //             maxLengthEnforced: true,
    //             // decoration: InputDecoration(
    //             //   hintText: '  '
    //             // ),
    //             style: TextStyle(fontSize: 20),
    //             textAlign: TextAlign.center,
    //           ),
    //         ),
    //       ),
    //       TextSpan(text: ' egg', style: _questionTextStyle),
    //     ],
    //   ),
    // );
  }
}
