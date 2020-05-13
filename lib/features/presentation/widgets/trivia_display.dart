import 'package:flutter/widgets.dart';
import 'package:trivia_number_new/features/domain/entities/trivia_number.dart';

class LoadedWidget extends StatelessWidget {
  final TriviaNumber triviaNumber;

  LoadedWidget({Key key, this.triviaNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Column(
        children: <Widget>[
          Text(triviaNumber.number.toString(),
              style: TextStyle(fontSize: 25), textAlign: TextAlign.center),
          Expanded(
              child: Center(
                  child: SingleChildScrollView(
            child: Text(
              triviaNumber.text,
              style: TextStyle(fontSize: 25),
              textAlign: TextAlign.center,
            ),
          )))
        ],
      ),
    );
  }
}
