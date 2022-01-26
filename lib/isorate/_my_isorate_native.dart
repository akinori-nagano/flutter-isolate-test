import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_isolate/flutter_isolate.dart';

import './my_isorate_task.dart';

class MyWorker {
  Future<dynamic> postMessage(Map v) async {
    debugPrint('This is native.');
    Map arg = v;
    debugPrint(arg.toString());
    debugPrint(_onmessage.toString());

    ReceivePort receivePort = ReceivePort();
    v['sendPort'] = receivePort.sendPort;

    await FlutterIsolate.spawn(_onmessage, arg);
    return await receivePort.first;
  }

  static _onmessage(Map mapobj) async {
    SendPort? sendPort = mapobj['sendPort'];
    if (sendPort == null) {
      debugPrint('invalid argment sendPort.');
      return;
    }
    int? v1 = mapobj['v1'];
    if (v1 == null) {
      debugPrint('invalid argment v1.');
      return;
    }
    int? v2 = mapobj['v2'];
    if (v2 == null) {
      debugPrint('invalid argment v2.');
      return;
    }
    debugPrint('v1 is $v1, v2 is $v2.');

    MyWorkerTask myWorkerTask = new MyWorkerTask();
    var v = myWorkerTask.multiply(v1, v2);
    String result = 'Worker::result:send: ' + v;
    debugPrint('ISOLATE: Message received from worker');
    debugPrint(result);
    sendPort.send(result);
  }
}
