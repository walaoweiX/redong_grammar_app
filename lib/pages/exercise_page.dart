import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redong_grammar_app/models/QuestionAnswer.dart';
import 'package:redong_grammar_app/models/QuestionAnswerModel.dart';
import 'package:redong_grammar_app/pages/exercise_page_body.dart';
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
  String _questionType = "";
  String _instruction = "";
  // List<QuestionAnswer> _questionList;
  List<List<TextEditingController>> _userAnswerList;

  @override
  void dispose() {
    _userAnswerList.forEach((list) {
      list.forEach((controller2) {
        controller2.dispose();
      });
    });
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
              body: ExercisePageBody(
                userAnswerList: _userAnswerList,
                questionType: _questionType,
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

    List<Map> getQuestions = await widget.database.query(
      'QuestionList',
      columns: ['question', 'answer'],
      where: '"topic" = ? AND "exercise" = ?',
      whereArgs: ['${widget.title}', '${widget.exerciseNo}'],
    );
    // _questionList = new List();
    _userAnswerList = new List();
    context.read<QuestionAnswerModel>().initializeList();
    int count = 0;

    //---------------------------------------------------------
    if (_questionType == "underline-answer") {
      for (int i = 0; i < getQuestions.length; i++) {
        List<String> answerList = getQuestions[i]['answer'].split(', ');
        context.read<QuestionAnswerModel>().addCorrectAnswerToList(answerList);

        // creating a temporary list to be inserted into _userAnswerList() function
        List<TextEditingController> b = new List();

        answerList.forEach((answer) {
          b.add(new TextEditingController());
        });

        _userAnswerList.add(b);
        context.read<QuestionAnswerModel>().addQuestionToList(
            new QuestionAnswer(
                count, getQuestions[i]['question'], getQuestions[i]['answer']));
        count++;
      }
    } else {
      for (int i = 0; i < getQuestions.length; i++) {
        List<String> answerList = getQuestions[i]['answer'].split(', ');
        context.read<QuestionAnswerModel>().addCorrectAnswerToList(answerList);

        // creating a temporary list to be inserted into _userAnswerList() function
        List<TextEditingController> b = new List();

        answerList.forEach((answer) {
          b.add(new TextEditingController());
        });

        _userAnswerList.add(b);
        context.read<QuestionAnswerModel>().addQuestionToList(
            new QuestionAnswer(
                count, getQuestions[i]['question'], getQuestions[i]['answer']));
        count++;
      }
    }

    return 1;
  }
}
