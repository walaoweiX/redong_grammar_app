import 'package:flutter/material.dart';
import 'package:redong_grammar_app/pages/exercise_list_page.dart';
import 'package:redong_grammar_app/pages/notes_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:strings/strings.dart';

class NavigationTabPage extends StatefulWidget {
  final String title;
  final Database database;

  NavigationTabPage({Key key, this.title, this.database}) : super(key: key);

  @override
  _NavigationTabPageState createState() => _NavigationTabPageState();
}

class _NavigationTabPageState extends State<NavigationTabPage> {
  int _selectedIndex = 0;
  var smallText = Text(
    'Exercise 1',
    style: TextStyle(fontSize: 8),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // title: ListTile(
          //   title: Text(camelize(this.widget.title)),
          //   subtitle: Text('Exercise 1'),
          // ),
          title: Text(camelize(this.widget.title)),
        ),
        body: _selectedIndex == 0
            ? NotesPage()
            : ExerciseListPage(
                title: this.widget.title,
                database: this.widget.database,
              ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.topic), label: 'Notes'),
            BottomNavigationBarItem(
                icon: Icon(Icons.traffic), label: 'Exercises'),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
