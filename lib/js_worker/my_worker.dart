import 'dart:js' as js;
import 'package:flutter/material.dart';

import './my_worker_window_api.dart';
import '/isorate/my_isorate_task.dart';
import '/utility.dart' as util;

MyWorkerTask myWorkerTask = new MyWorkerTask();

main() {
  /*
   * mapobj = {
   *   number: 1, // unique number
   *   v1: 1, // int
   *   v2: 2, // int
   * }
   */
  void onmessage(event) {
    var mapobj = event.data;
    debugPrint('Worker: Message received from main script');
    debugPrint(mapobj);

    var res = myWorkerTask.multiply(mapobj['v1'], mapobj['v2']);
    var workerResult = {
      'number': mapobj['number'],
      'result': 'Worker::result:send: ' + res,
    };
    debugPrint('Worker::postMessage: send start.');
    myPostMessage(util.mapToJSObject(workerResult));
    debugPrint('Worker::postMessage: send end.');
  }

  js.context['onmessage'] = onmessage;
}
