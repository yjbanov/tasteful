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
abstract class TastefulWidget<D> extends StatefulWidget {
  const TastefulWidget({super.key});

  /// Creates the object carrying stateful data local to this widget.
  @protected
  D? createData() => null;

  @override
  State<TastefulWidget> createState() {
    return TastefulState<D>(createData());
  }

  /// Like [StatelessWidget.build] but receives a [TastefulBuildContext]
  /// instead of a [BuildContext].
  ///
  /// [TastefulBuildContext.state] provides the current state of the widget
  /// that can be used to alter the widget built by this method.
  @protected
  Widget build(TastefulBuildContext<D> context);

  @override
  TastefulElement<D> createElement() {
    return TastefulElement<D>(this);
  }
}

class TastefulState<D> extends State<TastefulWidget<D>> {
  TastefulState(this._data);

  D get data => _data!;
  D? _data;

  @override
  Widget build(final BuildContext context) {
    context as TastefulBuildContext<D>;
    return widget.build(context);
  }
}

/// Function that sets a new state.
typedef SetStateCallback = void Function();

/// [BuildContext] that also manages a [TastefulWidget] widget's state.
abstract class TastefulBuildContext<D> extends BuildContext {
  /// Transitions a [TastefulWidget] widget to a `newState`.
  ///
  /// If `newState` is not equal to the previous state value using operator `==`,
  /// the framework rebuilds the widget.
  set data(D newData);

  /// The current state of the widget.
  D get data;

  TastefulState<D> get state;
}

/// Element created for a [TastefulWidget].
///
/// This element manages the widget's state. When the widget is updated to a
/// new widget this element and the current state remains the same.
class TastefulElement<D> extends StatefulElement implements TastefulBuildContext<D> {
  TastefulElement(TastefulWidget<D> widget)
      : super(widget);

  @override
  TastefulWidget<D> get widget => super.widget as TastefulWidget<D>;

  @override
  TastefulState<D> get state => super.state as TastefulState<D>;

  @override
  D get data => state._data!;

  @override
  set data(D newData) {
    final D? oldData = state._data;
    if (oldData != newData) {
      state._data = newData;
      markNeedsBuild();
    }
  }

  @override
  void unmount() {
    super.unmount();
    state._data = null;
  }
}
