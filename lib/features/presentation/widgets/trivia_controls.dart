import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trivia_number_new/features/presentation/bloc/bloc/trivia_number_bloc.dart';

import '../../../injection_container.dart';

class TriviaControls extends StatefulWidget {
  final BuildContext ctx;
  final TriviaNumberBloc triviaNumberBloc;
  const TriviaControls({Key key, this.ctx, this.triviaNumberBloc})
      : super(key: key);

  @override
  _TriviaControlsState createState() =>
      _TriviaControlsState(ctx: ctx, triviaNumberBloc: triviaNumberBloc);
}

class _TriviaControlsState extends State<TriviaControls> {
  final controller = TextEditingController();
  String inputStr;
  final BuildContext ctx;
  final TriviaNumberBloc triviaNumberBloc;
  _TriviaControlsState({Key key, this.ctx, this.triviaNumberBloc}) : super();

  @override
  Widget build(BuildContext context) {
    print("_TriviaControlsState ${ctx.hashCode}");
    print("_TriviaControlsState $triviaNumberBloc");
    return Column(
      children: <Widget>[
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: "Entré un nombre"),
          onChanged: (value) {
            inputStr = value;
          },
          onSubmitted: (_) {
            dispatchConcrete();
          },
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            Expanded(
                child: RaisedButton(
                    child: Text("Get Concrete trivia"),
                    color: Theme.of(context).accentColor,
                    textTheme: ButtonTextTheme.primary,
                    onPressed: dispatchConcrete)),
            SizedBox(width: 10),
            Expanded(
              child: RaisedButton(
                child: Text('Get random trivia'),
                onPressed: dispatchRandom,
              ),
            ),
          ],
        )
      ],
    );
    // return BlocProvider(
    //     create: (_) => sl<TriviaNumberBloc>(),
    //     child: Column(
    //       children: <Widget>[
    //         TextField(
    //           controller: controller,
    //           keyboardType: TextInputType.number,
    //           decoration: InputDecoration(
    //               border: OutlineInputBorder(), hintText: "Entré un nombre"),
    //           onChanged: (value) {
    //             inputStr = value;
    //           },
    //           onSubmitted: (_) {
    //             dispatchConcrete();
    //           },
    //         ),
    //         SizedBox(
    //           height: 10,
    //         ),
    //         Row(
    //           children: <Widget>[
    //             Expanded(
    //                 child: RaisedButton(
    //                     child: Text("Get Concrete trivia"),
    //                     color: Theme.of(context).accentColor,
    //                     textTheme: ButtonTextTheme.primary,
    //                     onPressed: dispatchConcrete)),
    //             SizedBox(width: 10),
    //             Expanded(
    //               child: RaisedButton(
    //                 child: Text('Get random trivia'),
    //                 onPressed: dispatchRandom,
    //               ),
    //             ),
    //           ],
    //         )
    //       ],
    //     ));
  }

  void dispatchConcrete() {
    // Clearing the TextField to prepare it for the next inputted number
    print("dispatchConcrete ${ctx.hashCode}");
    controller.clear();
    triviaNumberBloc.add(GetConcreteTriviaNumberEvent(numberString: inputStr));
    // BlocProvider.of<TriviaNumberBloc>(ctx)
    //     .add(GetConcreteTriviaNumberEvent(numberString: inputStr));
  }

  void dispatchRandom() {
    print("dispatchRandom ${context.hashCode}");
    print("dispatchRandom ${triviaNumberBloc.state}");
    controller.clear();
    triviaNumberBloc.add(GetRandomTriviaNumberEvent());
    // sl<TriviaNumberBloc>().add(GetRandomTriviaNumberEvent());
  }
}
