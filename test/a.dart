import 'dart:async';
import "dart:isolate";

import "./b.dart";

class Data {
  int counter;
  Completer completer;

  Data(this.counter, this.completer);
}

List<Data> dataList = <Data>[];

_onTimer() {
  const myCounter = 1;

  print('_onTimer: timeout');
  for (var i = 0; i < dataList.length; i++) {
    if (dataList[i].counter == myCounter) {
      print('found !');
      dataList[i].completer.complete('get result !');
    }
  }
}

void main() {
  var cf = run<String>();
  Completer completer = cf['completer'];
  var future = completer.future;

  dataList.add(new Data(cf['counter'], completer));

  Timer(Duration(seconds: 3), _onTimer);

  future.then((value) => print(value));
}
