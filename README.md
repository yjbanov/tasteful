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

## Example

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

This widget contains all the UI, but the "Increment" button does nothing useful,
and the counter is hard-coded to always say "0". To make the counter actually
count clicks we are going to add state to it. The data that stores the state is
an `int` that counts how many times the button was pressed. The initial value
needs to be set to zero. The `onPressed` callback of the button needs to
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
              '${context.state}',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.state++;
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

Notice how, unlike the `StatelessWidget`/`StatefulWidget` dichotomy, no extra
class needed to be created to add state to the widget. The `build` method did
not need to move anywhere. The reference to `title` is still accessible via
`this`. Also notice that there's no need to wrapp state updating logic into a
`setState` with a closure. This is because `context.state` setter automatically
marks the widget for update.

Compared to the stateless version there are three differences:

- The widget extends `TastefulWidget<int>` to declare what type is used to hold
  the state information. In this simple case, it's just an `int`.
- The widget overrides the `createData()` method that initializes the
  state to zero.
- The body of the `build` method uses `context.state` to read and display the
  value, and update it in the `onPressed` callback.

## Current limitations

This package is currently very simple and does not support more complex
scenarios. `StatefulWidget` provides a richer lifecycle API, such as
`didChangeDependencies`, `didUpdateWidget`, and `dispose`. `TastefulBuildContext`
is missing a closure-based `setState` method for more complex scenarios, such as
when instead of replacing the state object, it is mutated internally, and the
widget needs to be scheduled for update.

[StatelessWidget]: https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html
[StatefulWidget]: https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html
[State]: https://api.flutter.dev/flutter/widgets/State-class.html
