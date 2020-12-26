import 'package:flutter/material.dart';
import 'package:redong_grammar_app/pages/exercise_page.dart';
import 'package:sqflite/sqflite.dart';

class ExerciseListPage extends StatefulWidget {
  final Database database;
  final String title;

  const ExerciseListPage({Key key, this.title, this.database})
      : super(key: key);

  @override
  _ExerciseListPageState createState() => _ExerciseListPageState();
}

class _ExerciseListPageState extends State<ExerciseListPage> {
  String get title => widget.title;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: this.widget.database.rawQuery(
          'SELECT COUNT(*) from InstructionList where topic=\'$title\''),
      // future: this.widget.database.query('InstructionList',
      //     columns: ['instruction'],
      //     where: 'topic = ?',
      //     whereArgs: [this.widget.title]),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error occured'),
          );
        } else if (snapshot.hasData) {
          int count = Sqflite.firstIntValue(snapshot.data);
          return ListView.builder(
            itemCount: count,
            itemBuilder: (context, index) {
              int exerciseNo = index+1;
              return ListTile(
                title: Align(
                  child: Text('Exercise $exerciseNo'),
                ),
                trailing: Icon(Icons.chevron_right_rounded),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ExercisePage(
                                title: this.widget.title,
                                database: this.widget.database,
                                exerciseNo: exerciseNo,
                              )));
                },
              );
            },
          );
        }
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
