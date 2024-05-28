import 'package:flutter/widgets.dart';

/// A widget with state.
///
/// The state is represented by an immutable object of type [S].
/// The initial state value is obtained by calling [createData]
/// when the widget is built for the first time.
///
/// When the widget is inflated into an [Element], the element calls
/// [build] passing it a context object and current state value. Widget
/// properties together with the state value provide information for
/// building child widgets.
///
/// To transition from the current state to the next state, call
/// `context.setState` passing it a new object of type [S]. The
/// framework automatically rebuild the widget if the new state
/// value is not equal to the old value. State values are compared
/// using the `==` operator.
abstract class TastefulWidget<D, S extends TastefulState> extends StatefulWidget {
  const TastefulWidget({super.key});

  /// Creates the object carrying stateful data local to this widget.
  @protected
  D? createData() => null;

  @override
  TastefulState createState() {
    return VoidState();
  }

  /// Like [StatelessWidget.build] but receives a [TastefulBuildContext]
  /// instead of a [BuildContext].
  ///
  /// [TastefulBuildContext.state] provides the current state of the widget
  /// that can be used to alter the widget built by this method.
  @protected
  Widget build(TastefulBuildContext<D, S> context);

  @override
  TastefulElement<D, S> createElement() {
    return TastefulElement<D, S>(this);
  }
}

class TastefulState<D, W extends StatefulWidget> extends State<W> {
  TastefulState();

  @override
  TastefulBuildContext<Object?, TastefulState> get context => super.context as TastefulBuildContext<Object?, TastefulState>;

  D get data => context.data as D;

  set data(D newData) {
    context.data = newData;
  }

  @override
  Widget build(_) {
    return (widget as TastefulWidget).build(context);
  }
}

class VoidState extends TastefulState {}

/// [BuildContext] that also manages a [TastefulWidget] widget's state.
abstract class TastefulBuildContext<D, S extends TastefulState> extends BuildContext {
  /// Transitions a [TastefulWidget] widget to a `newState`.
  ///
  /// If `newState` is not equal to the previous state value using operator `==`,
  /// the framework rebuilds the widget.
  set data(D newData);

  /// The current state of the widget.
  D get data;

  S get state;
}

/// Element created for a [TastefulWidget].
///
/// This element manages the widget's state. When the widget is updated to a
/// new widget this element and the current state remains the same.
class TastefulElement<D, S extends TastefulState> extends StatefulElement implements TastefulBuildContext<D, S> {
  TastefulElement(TastefulWidget<D, S> widget)
      : _data = widget.createData(), super(widget);

  @override
  TastefulWidget<D, S> get widget => super.widget as TastefulWidget<D, S>;

  @override
  D get data => _data!;
  D? _data;

  @override
  S get state => super.state as S;

  @override
  set data(D newData) {
    final D? oldData = _data;
    if (oldData != newData) {
      _data = newData;
      markNeedsBuild();
    }
  }

  @override
  void unmount() {
    super.unmount();
    _data = null;
  }
}
