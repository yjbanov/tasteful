import 'package:flutter/widgets.dart';

/// A widget with state.
///
/// The state is represented by an immutable object of type [S].
/// The initial state value is obtained by calling [createInitialState]
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
abstract class TastefulWidget<S> extends Widget {
  TastefulWidget({super.key});

  /// Creates the initial state value.
  @protected
  S? createInitialState() => null;

  /// Like [StatelessWidget.build] but receives a [TastefulBuildContext]
  /// instead of a [BuildContext].
  ///
  /// [TastefulBuildContext.state] provides the current state of the widget
  /// that can be used to alter the widget built by this method.
  @protected
  Widget build(TastefulBuildContext context);

  @override
  Element createElement() {
    return TastefulElement<S>(this);
  }
}

/// Function that sets a new state.
typedef SetStateCallback = void Function();

/// [BuildContext] that also manages a [TastefulWidget] widget's state.
abstract class TastefulBuildContext<S> extends BuildContext {
  /// Transitions a [TastefulWidget] widget to a `newState`.
  ///
  /// If `newState` is not equal to the previous state value using operator `==`,
  /// the framework rebuilds the widget.
  set state(S newState);

  /// The current state of the widget.
  S get state;
}

/// Element created for a [TastefulWidget].
///
/// This element manages the widget's state. When the widget is updated to a
/// new widget this element and the current state remains the same.
class TastefulElement<S> extends ComponentElement implements TastefulBuildContext<S> {
  TastefulElement(TastefulWidget<S> widget)
      : _state = widget.createInitialState(),
        super(widget);

  @override
  Widget build() => widget.build(this);

  @override
  TastefulWidget<S> get widget => super.widget as TastefulWidget<S>;

  @override
  S get state => _state!;
  S? _state;

  @override
  set state(S newState) {
    final S? oldState = _state;
    if (oldState != newState) {
      _state = newState;
      markNeedsBuild();
    }
  }

  @override
  void update(TastefulWidget newWidget) {
    super.update(newWidget);
    markNeedsBuild();
    rebuild();
  }

  @override
  void activate() {
    super.activate();
    markNeedsBuild();
  }

  @override
  void unmount() {
    super.unmount();
    _state = null;
  }
}
