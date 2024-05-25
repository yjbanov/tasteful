import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasteful/tasteful.dart';

void main() {
  testWidgets('Tasteful', (WidgetTester tester) async {
    // Initial build, with initial state.
    await tester.pumpWidget(Counter('Hello'));
    expect(find.text('Hello, 0!'), findsOneWidget);

    // Change state independently from the widget.
    await tester.tap(find.text('Increment'));
    await tester.pumpAndSettle();
    expect(find.text('Hello, 1!'), findsOneWidget);

    // Update widget independently from state.
    await tester.pumpWidget(Counter('Bonjour'));
    expect(find.text('Bonjour, 1!'), findsOneWidget);
  });
}

class Counter extends TastefulWidget<int> {
  Counter(this.greeting);

  final String greeting;

  @override
  int createData() => 0;

  @override
  Widget build(TastefulBuildContext context) {
    return Boilerplate(Column(children: [
      Text('$greeting, ${context.data}!'),
      GestureDetector(
        onTap: () {
          context.data = context.data + 1;
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
