# package:tasteful

This Flutter package provides a new kind of stateful widget, `TastefulWidget`.
It solves a subset of problems typically solved using [StatefulWidget][1] a
little more elegantly:

- `TastefulWidget` does not require a second [State][2] class. Instead it can
  operate on an already existing class that can represent your widget's state.
- Unlike `State` your state class can (and generally should) be immutable.

## Example

The following example implements the classic counter widget. It uses data
provided with the widget (`greeting`) as well as state (counter represented
by `int`) to build a UI.

```dart
class Counter extends TastefulWidget<int> {
  Counter(this.greeting);

  final String greeting;

  int createInitialState() => 0;

  @override
  Widget build(TastefulBuildContext context) {
    return Column(children: [
      Text('$greeting, ${context.state}!'),
      GestureDetector(
        onTap: () {
          context.state = context.state + 1;
        },
        child: Text('Increment'),
      ),
    ]);
  }
}
```

## When to use `TastefulWidget`

- When you prefer your state objects to be immutable and that's sufficient to
  express your app's UI logic.
- When a class already exists that fully represents your widget's state, and
  creating a second wrapper class would be wasteful.

## `TastefulWidget` is _not_ a `StatefulWidget` replacement

`StatefulWidget` supports more complex scenarios via a richer lifecycle API,
such as `didChangeDependencies`, `didUpdateWidget`, and `dispose`.

[1]: https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html
[2]: https://api.flutter.dev/flutter/widgets/State-class.html
