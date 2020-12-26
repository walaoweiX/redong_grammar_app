import 'package:flutter/material.dart';
import 'package:redong_grammar_app/pages/navigation_tab_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:strings/strings.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.database}) : super(key: key);

  final String title;
  final Database database;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _x = 1;

  @override
  Widget build(BuildContext context) {
    if (_x == 1) {
      return FutureBuilder(
        future:
            this.widget.database.rawQuery('SELECT topic from GrammarTopicList'),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error occured'),
              ),
            );
          } else if (snapshot.hasData) {
            List<String> topics = new List();
            snapshot.data.forEach((result) {
              var topic = result['topic'];
              topics.add(topic);
            });
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  title: Text(this.widget.title),
                  centerTitle: true,
                ),
                body: ListView.builder(
                  itemCount: topics.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Align(child: Text(camelize(topics[index]))),
                      trailing: Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NavigationTabPage(
                                      title: topics[index],
                                      database: this.widget.database,
                                    )));
                      },
                    );
                  },
                ),
              ),
            );
          }
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        },
      );
    } else {
      return SafeArea(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 30,
                  top: 10,
                ),
                child: Text(
                  this.widget.title,
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 40,
                height: MediaQuery.of(context).size.height - 70,
                child: ListView.builder(
                  itemCount: 15,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text('Hello'),
                      trailing: Icon(Icons.chevron_right_rounded),
                      onTap: () {},
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
