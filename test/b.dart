import 'dart:async';

int _counter = 0;

Map run<T>() {
  _counter++;

  var completer = Completer<T>();
  return {
    "counter": _counter,
    "completer": completer,
  };
}
