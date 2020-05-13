import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../injection_container.dart';
import '../bloc/bloc/trivia_number_bloc.dart';
import '../widgets/widgets.dart';

class TriviaNumberPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print(context.hashCode);
    return Scaffold(
      appBar: AppBar(title: Text("Number trivia")),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }
}

buildBody(BuildContext ctx) {
  print("TriviaNumberPage ${ctx.hashCode}");
  // return Padding(
  //   padding: const EdgeInsets.all(10),
  //   child: Column(
  //     children: <Widget>[
  //       SizedBox(height: 10),
  //       // Top half
  //       Container(
  //         // Third of the size of the screen
  //         height: MediaQuery.of(ctx).size.height / 3,
  //         child: BlocBuilder<TriviaNumberBloc, TriviaNumberState>(
  //             builder: (context, state) {
  //           print("BlocBuilder ${ctx.hashCode}");
  //           if (state is Empty) {
  //             return MessageDisplay(ctx: ctx, message: "Start searching");
  //           } else if (state is Loading) {
  //             return LoadingWidget();
  //           } else if (state is Loaded) {
  //             return LoadedWidget();
  //           } else if (state is Error) {
  //             return MessageDisplay(ctx: ctx, message: state.message);
  //           } else {
  //             return MessageDisplay(ctx: ctx, message: "Nothing");
  //           }
  //         }),
  //       ),
  //       SizedBox(height: 20),
  //       // Bottom half
  //       TriviaControls(ctx: ctx)
  //     ],
  //   ),
  // );
  return BlocProvider(
      create: (_) => sl<TriviaNumberBloc>(),
      child: Builder(builder: (providerContext) {
        print("TriviaNumberPage Builder ${sl<TriviaNumberBloc>().state}");
        print(
            "TriviaNumberPage Builder ${BlocProvider.of<TriviaNumberBloc>(providerContext)}");
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              // Top half
              Container(
                // Third of the size of the screen
                height: MediaQuery.of(ctx).size.height / 3,
                child: BlocBuilder<TriviaNumberBloc, TriviaNumberState>(
                    builder: (context, state) {
                  print("BlocBuilder ${providerContext.hashCode}");
                  if (state is Empty) {
                    return MessageDisplay(
                        ctx: providerContext, message: "Start searching");
                  } else if (state is Loading) {
                    return LoadingWidget();
                  } else if (state is Loaded) {
                    return LoadedWidget();
                  } else if (state is Error) {
                    return MessageDisplay(
                        ctx: providerContext, message: state.message);
                  } else {
                    return MessageDisplay(
                        ctx: providerContext, message: "Nothing");
                  }
                }),
              ),
              SizedBox(height: 20),
              // Bottom half
              TriviaControls(
                ctx: providerContext,
                triviaNumberBloc:
                    BlocProvider.of<TriviaNumberBloc>(providerContext),
              )
            ],
          ),
        );
      }));
}
