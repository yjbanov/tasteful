import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stateful/stateful.dart';

void main() {
  testWidgets('Stateful', (WidgetTester tester) async {
    await tester.pumpWidget(_Counter());
    expect(find.text('Hello, 0!'), findsOneWidget);
    await tester.tap(find.text('Increment'));
    await tester.pumpAndSettle();
    expect(find.text('Hello, 1!'), findsOneWidget);
  });
}

class _Counter extends Stateful<int> {
  int createState() => 0;

  @override
  Widget build(StatefulBuildContext context, int state) {
    return Boilerplate(Column(children: [
      Text('Hello, $state!'),
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
