import 'package:flutter/material.dart';
import 'package:tasteful/tasteful.dart';

class CounterAdvanced extends TastefulWidget<int> {
  const CounterAdvanced({required this.title});

  final String title;

  @override
  int createData() => 0;

  @override
  CounterState createState() => CounterState();

  @override
  Widget build(TastefulBuildContext context) {
    final CounterState state = context.state as CounterState;
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
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: state._colorAnimation.value,
              ),
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

class CounterState extends TastefulState<int> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _colorAnimation = ColorTween(
      begin: Colors.red,
      end: Colors.blue,
    ).animate(_controller);
    _colorAnimation.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
