import 'package:flutter/material.dart';
import 'package:tasteful/tasteful.dart';

class CounterStateful extends TastefulWidget<int, VoidState> {
  const CounterStateful({required this.title});

  final String title;

  @override
  int createData() => 0;

  @override
  Widget build(TastefulBuildContext<int, VoidState> context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '${context.data}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.data++;
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
