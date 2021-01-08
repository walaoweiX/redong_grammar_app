import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:redong_grammar_app/pages/home_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: assetLoading(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('Error occured.'),
            ),
          );
        } else if (snapshot.hasData) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              // This is the theme of your application.
              //
              // Try running your application with "flutter run". You'll see the
              // application has a blue toolbar. Then, without quitting the app, try
              // changing the primarySwatch below to Colors.green and then invoke
              // "hot reload" (press "r" in the console where you ran "flutter run",
              // or simply save your changes to "hot reload" in a Flutter IDE).
              // Notice that the counter didn't reset back to zero; the application
              // is not restarted.
              primarySwatch: Colors.blue,
              // This makes the visual density adapt to the platform that you run
              // the app on. For desktop platforms, the controls will be smaller and
              // closer together (more dense) than on mobile platforms.
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: HomePage(
              title: 'Redong Grammar App',
              database: snapshot.data,
            ),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<Database> assetLoading() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    var path = join(documentsDirectory.path, "redong.db");

    // Check if the database exists
    var exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "Redong.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }

    // open the database
    var db = await openDatabase(path, readOnly: true);
    return db;
  }
}

// an example to create a "fill in the blanks type of question".
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
