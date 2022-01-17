import 'dart:js' as js;
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
    print('Worker: Message received from main script');
    print(mapobj);

    var res = myWorkerTask.multiply(mapobj['v1'], mapobj['v2']);
    var workerResult = {
      'number': mapobj['number'],
      'result': 'Worker::result:send: ' + res,
    };
    print('Worker::postMessage: send start.');
    myPostMessage(util.mapToJSObject(workerResult));
    print('Worker::postMessage: send end.');
  }

  js.context['onmessage'] = onmessage;
}
