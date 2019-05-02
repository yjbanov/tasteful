import 'package:flutter/widgets.dart';

/// A lighter-weight stateful widget.
/// 
/// The state is represented by an immutable object of type [S].
/// The initial state value is obtained by calling [createInitialState]
/// when the widget is built for the first time.
/// 
/// When inflating the widget, the element calls [build] passing
/// a context object and current state value. Widget properties
/// together with the state value provide information for building
/// child widgets.
/// 
/// To transition from the current state to the next state, call
/// `context.setState` passing it a new object of type [S]. The
/// framework automatically rebuild the widget if the new state
/// value is not equal to the old value. State values are compared
/// using the `==` operator.
// TODO(yjbanov): I wish S could be marked with @immutable.
abstract class Stateful<S> extends Widget {
  Stateful({Key key}) : super(key: key);

  /// Creates the initial state value.
  @protected
  S createInitialState() => null;

  /// Same as [StatelessWidget.build], but with a couple of differences:
  /// 
  /// * [StatefulBuildContext] is passed instead of [BuildContext].
  /// * This method also receives a `state` parameter used as another source
  ///   of configuration.
  @protected
  Widget build(StatefulBuildContext context, S state);

  @override
  Element createElement() {
    return _StatefulElement<S>(this);
  }
}

typedef SetStateCallback = void Function();

/// [BuildContext] that also manages a [Stateful] widget's state.
abstract class StatefulBuildContext<S> extends BuildContext {
  /// Transitions a [Stateful] widget to a `newState`.
  /// 
  /// If `newState` is not equal (using `==`) to the previous state value, the
  /// framework rebuilds the widget.
  void setState(S newState);
}

class _StatefulElement<S> extends ComponentElement implements StatefulBuildContext<S> {
  _StatefulElement(Stateful<S> widget)
      : _state = widget.createInitialState(),
        super(widget);

  @override
  Widget build() => widget.build(this, _state);

  @override
  Stateful<S> get widget => super.widget;
  S _state;

  @override
  void setState(S newState) {
    final S oldState = _state;
    _state = newState;
    if (oldState != newState) {
      markNeedsBuild();
    }
  }

  @override
  void update(Stateful newWidget) {
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
