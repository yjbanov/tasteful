import 'package:flutter/material.dart';
import 'package:tasteful/tasteful.dart';

import 'counter_advanced.dart';
import 'counter_dataless.dart';
import 'counter_stateful.dart';
import 'counter_stateless.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Demos(title: 'Flutter Demo Home Page'),
    );
  }
}

class Demos extends TastefulWidget<String> {
  const Demos({required this.title});

  final String title;

  @override
  String createData() => 'home';

  @override
  Widget build(context) {
    return switch (context.data) {
      'home' => _buildHome(context),
      'stateless' => CounterStateless(title: 'Stateless Counter'),
      'stateful' => CounterStateful(title: 'Stateful Counter'),
      'advanced' => CounterAdvanced(title: 'Advanced Counter'),
      'dataless' => CounterDataless(title: 'Dataless Stateful Counter'),
      _ => throw StateError('This should never happen'),
    };
  }

  Widget _buildHome(TastefulBuildContext<String> context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                context.data = 'stateless';
              },
              child: Text('Stateless Counter'),
            ),
            TextButton(
              onPressed: () {
                context.data = 'stateful';
              },
              child: Text('Stateful Counter'),
            ),
            TextButton(
              onPressed: () {
                context.data = 'advanced';
              },
              child: Text('Advanced Counter'),
            ),
            TextButton(
              onPressed: () {
                context.data = 'dataless';
              },
              child: Text('Dataless Stateful Counter'),
            ),
          ],
        ),
      ),
    );
  }
}
