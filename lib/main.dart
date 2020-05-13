import 'package:flutter/material.dart';
import 'package:trivia_number_new/features/presentation/pages/trivia_number_page.dart';
import 'injection_container.dart' as di;
import 'injection_container.dart';

void main() async {
  //Nous ajoutons le localisateur de service au debut de l'application
  // WidgetsFlutterBinding.ensureInitialized();
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("MyApp ${context.hashCode}");
    return FutureBuilder(
        future: sl.allReady(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return MaterialApp(
              title: "Number Trivia",
              theme: ThemeData(
                  primaryColor: Colors.green.shade800,
                  accentColor: Colors.green.shade600),
              home: TriviaNumberPage(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
