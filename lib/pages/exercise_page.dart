import 'package:flutter/material.dart';
import 'package:redong_grammar_app/models/QuestionAnswer.dart';
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
  List<TextEditingController> _userAnswerList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _userAnswerList.forEach((element) {
      element.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                                    child: _buildSimpleQuestion(
                                        index + 1, _questionList[index]),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child:
                                          _questionList[index].answerStatus == 2
                                              ? Icon(Icons.check)
                                              : _questionList[index]
                                                          .answerStatus ==
                                                      3
                                                  ? Icon(Icons.clear)
                                                  : null,
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
                            onPressed: () {},
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
    var getInstruction = await widget.database.query(
      'InstructionList',
      columns: ['instruction', 'question_type'],
      where: 'topic = ? AND exercise = ?',
      whereArgs: ['${widget.title}', '${widget.exerciseNo}'],
    );
    _instruction = getInstruction[0].values.elementAt(0);
    _questionType = getInstruction[0].values.elementAt(1);

    var getQuestions = await widget.database.query(
      'QuestionList',
      columns: ['question', 'answer'],
      where: 'topic = ? AND exercise = ?',
      whereArgs: ['${widget.title}', '${widget.exerciseNo}'],
    );
    _questionList = new List();
    _userAnswerList = new List();
    getQuestions.forEach((element) {
      _userAnswerList.add(new TextEditingController());
      _questionList.add(QuestionAnswer(element['question'], element['answer']));
    });

    return 1;
  }

  Text _buildSimpleQuestion(int questionNo, QuestionAnswer question) {
    double fontSize = 18.0;
    List<String> questionToList = question.question.split(' ');

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
            } else
              return TextSpan(text: "");
          },
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
