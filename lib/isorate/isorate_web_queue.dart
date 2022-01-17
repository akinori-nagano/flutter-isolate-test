import 'dart:async';
import "dart:isolate";

List<IsorateWebQueueData> isorateWebQueueDataList = <IsorateWebQueueData>[];

int _uniqueNumber = 0;

IsorateWebQueueData appendIsorateWebQueue<T>() {
  var completer = Completer<T>();
  _uniqueNumber++;
  var v = new IsorateWebQueueData(_uniqueNumber, completer);
  isorateWebQueueDataList.add(v);
  return v;
}

class IsorateWebQueueData {
  int number;
  Completer completer;

  IsorateWebQueueData(this.number, this.completer);
}
