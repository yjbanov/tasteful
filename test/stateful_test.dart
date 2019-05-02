import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stateful/stateful.dart';

void main() {
  testWidgets('Stateful', (WidgetTester tester) async {
    // Initial build, with initial state.
    await tester.pumpWidget(_Counter('Hello'));
    expect(find.text('Hello, 0!'), findsOneWidget);

    // Change state independently from the widget.
    await tester.tap(find.text('Increment'));
    await tester.pumpAndSettle();
    expect(find.text('Hello, 1!'), findsOneWidget);

    // Update widget independently from state.
    await tester.pumpWidget(_Counter('Bonjour'));
    expect(find.text('Bonjour, 1!'), findsOneWidget);
  });
}

class _Counter extends Stateful<int> {
  _Counter(this.greeting);

  final String greeting;

  int createInitialState() => 0;

  @override
  Widget build(StatefulBuildContext context, int state) {
    return Boilerplate(Column(children: [
      Text('$greeting, $state!'),
      GestureDetector(
        onTap: () {
          context.setState(state + 1);
        },
        child: Text('Increment'),
      ),
    ]));
  }
}

class Boilerplate extends StatelessWidget {
  Boilerplate(this.child);

  final Widget child;

  Widget build(_) => Directionality(
    textDirection: TextDirection.ltr,
    child: child,
  );
}
