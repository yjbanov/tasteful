# package:tasteful

This Flutter package provides a new kind of widget, `TastefulWidget`. It solves
a subset of problems typically solved using [StatelessWidget][] and
[StatefulWidget][] that come with the framework, namely:

- Handles both stateless and stateful cases. It is stateless by default, but
  state may be added when needed without major rewrites, such as:
  - The `build` method can stay in its original place.
  - The contents of the `build` method do not need to be updated due to scope
    changes. For example, all widget fields are still visible via `this.` and do
    not need to be rewritten into `this.widget.`.
- Adding state does not require a separate [State][] class. Instead any
  existing type can be used that represents the widget's state.
- The widget does not need to change its type when switching between stateless
  and stateful modes.

## Examples

### Stateless widget

This example rewrites the classic counter app using `TastefulWidget`. To show
how easy it is to move between stateless and stateful, first a complete and
working stateless version is implemented that sets up the overall structure of
the UI. It is then updated to include actual click counting functionality.

Here is the stateless variant that contains all the UI, but because it is
stateless it does not actually count anything:

```dart
class Counter extends TastefulWidget {
  const Counter({required this.title});

  final String title;

  @override
  Widget build(TastefulBuildContext context) {
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
              '0',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

### Simple stateful widget

The stateless variant of widget contains all the UI, but the "Increment" button
does nothing useful, and the counter is hard-coded to always say "0". To make
the counter actually count clicks we are going to add stateful data to it. The
data is an `int` that counts how many times the button was pressed. The initial
value needs to be set to zero. The `onPressed` callback of the button needs to
increment the value and notify the framework that the widget needs to be
updated.

Here's new code that does all that:

```dart
class Counter extends TastefulWidget<int> {
  const Counter({required this.title});

  final String title;

  @override
  int createData() => 0;

  @override
  Widget build(TastefulBuildContext context) {
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
```

Below are key differences between the stateless and the stateful variants:

- The widget extends `TastefulWidget<int>` to declare what type is used to hold
  the state information. In this simple case, it's just an `int`.
- The widget overrides the `createData()` method that initializes the data to
  zero.
- The body of the `build` method uses `context.data` to read and display the
  value, and update it in the `onPressed` callback.

### Advanced stateful widget

In more advanced cases a widget may require access to lifecycle methods, such as
`didChangeDependencies`, `didUpdateWidget`, `dispose`. The widget may also need
access to Flutter's `State` mixins, such as `SingleTickerProviderStateMixin`. In
that case, a state class can be used. In the example below, the `Counter` widget
is enhanced to include an animation that forever animates the color of the
counter text between red and blue colors:

```
class Counter extends TastefulWidget<int> {
  const Counter({required this.title});

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
```

Below are key differences between the stateless and the stateful variants:

- The widget defines a state class `CounterState` that has access to all the
  lifecycle methods of the `State` class, and implements the animation logic.
- The widget overrides the `createState()`, that initializes `CounterState`.
- The `build()` method of the widget is updated to apply the animated color to
  the text.

### Dataless stateful widget

There's nothing wrong with having both a data object and a state class that
carry local information that the widget can use to render itself. However, if a
widget declares a state class, that same class could also carry the count
information without needing a data object. Here's how the animated counter above
could be rewritten without a data object:

```
class Counter extends TastefulWidget {
  const Counter({required this.title});

  final String title;

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
              '${state.count}',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: state._colorAnimation.value,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          state.count++;
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CounterState extends TastefulState with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  int get count => _count;
  set count(int newCount) {
    setState(() {
      _count = newCount;
    });
  }
  int _count = 0;

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
```

[StatelessWidget]: https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html
[StatefulWidget]: https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html
[State]: https://api.flutter.dev/flutter/widgets/State-class.html
