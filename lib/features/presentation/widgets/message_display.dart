import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_number_new/features/presentation/bloc/bloc/trivia_number_bloc.dart';

class MessageDisplay extends StatelessWidget {
  final String message;
  final BuildContext ctx;

  MessageDisplay({Key key, @required this.ctx, @required this.message})
      : assert(message != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    // print("MessageDisplay ${ctx.hashCode}");
    // print("MessageDisplay ${BlocProvider.of<TriviaNumberBloc>(context)}");
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Center(
          child: SingleChildScrollView(
        child: Text(
          message,
          style: TextStyle(fontSize: 25),
          textAlign: TextAlign.center,
        ),
      )),
    );
  }
}
