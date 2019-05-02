import 'package:flutter/widgets.dart';

abstract class Stateful<S> extends Widget {
  Stateful({Key key}) : super(key: key);

  @protected
  S createState() => null;

  @override
  Element createElement() {
    return _StatefulElement<S>(this);
  }

  @protected
  Widget build(StatefulBuildContext context, S state);
}

typedef SetStateCallback = void Function();

abstract class StatefulBuildContext<S> extends BuildContext {
  void setState(S newState);
}

class _StatefulElement<S> extends ComponentElement implements StatefulBuildContext<S> {
  _StatefulElement(Stateful<S> widget)
      : _state = widget.createState(),
        super(widget);

  @override
  Widget build() => widget.build(this, _state);

  @override
  Stateful<S> get widget => super.widget;
  S _state;

  @override
  void setState(S newState) {
    _state = newState;
    markNeedsBuild();
  }

  @override
  void update(Stateful newWidget) {
    super.update(newWidget);
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
