import 'dart:js';
import '/window_api.dart' as windowApi;
import '/utility.dart' as util;
import 'isorate_web_queue.dart';

bool atOnce = true;

class MyWorker {
  Future<dynamic> postMessage(v) {
    if (atOnce) {
      // 最初の1度だけ実行する
      atOnce == false;
      print('DART::postMessage: register onmessage function.');
      windowApi.myWorkerOnmessageAppend(allowInterop(_onmessage));
    }

    if (windowApi.myWorkerPostMessage == null) {
      return Future.error('FooError');
    }

    print('DART::postMessage: send start.');

    // 自作の疑似Queueに追加
    var queData = appendIsorateWebQueue<String>();

    v['number'] = queData.number;
    windowApi.myWorkerPostMessage(util.mapToJSObject(v));

/*
    // TODO futureテスト
    queData.completer.future.then((value) {
      print('DART::postMessage: future result.');
      print(value);
    });
*/

    print('DART::postMessage: send end.');
    return queData.completer.future;
  }

  _onmessage(e) {
    var res = e.data;
    print('DART: Message received from worker');
    print(res);

    var number = res['number'];
    print(number);
    var result = res['result'];
    print(result);
    _completeCompleter(number, result);
  }

  _completeCompleter(number, result) {
    for (var i = 0; i < isorateWebQueueDataList.length; i++) {
      if (isorateWebQueueDataList[i].number == number) {
        print('found !');
        isorateWebQueueDataList[i].completer.complete(result);
        isorateWebQueueDataList.removeAt(i);
        break;
      }
    }
  }
}
