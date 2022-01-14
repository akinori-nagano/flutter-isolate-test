import 'dart:js' as js;
import './my_worker_window_api.dart';
import '/isorate/my_isorate_task.dart';

MyWorkerTask myWorkerTask = new MyWorkerTask();

main() {
  /*
   * mapobj = {
   *   v1: 1, // int
   *   v2: 2, // int
   * }
   */
  void onmessage(event) {
    var mapobj = event.data;
    print('Worker: Message received from main script');
    print(mapobj);

    var res = myWorkerTask.multiply(mapobj['v1'], mapobj['v2']);
    var workerResult = 'Worker::result:send: ' + res;
    print('Worker::postMessage: send start.');
    myPostMessage(workerResult);
    print('Worker::postMessage: send end.');
  }
  js.context['onmessage'] = onmessage;
}
