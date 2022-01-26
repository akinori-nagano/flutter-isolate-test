import 'dart:js';
import 'package:flutter/material.dart';

import '/window_api.dart' as windowApi;
import '/utility.dart' as util;
import 'isorate_web_queue.dart';

bool atOnce = true;

class MyWorker {
  Future<dynamic> postMessage(Map v) async {
    if (atOnce) {
      // 最初の1度だけ実行する
      atOnce == false;
      debugPrint('DART::postMessage: register onmessage function.');
      windowApi.myWorkerOnmessageAppend(allowInterop(_onmessage));
    }

    if (windowApi.myWorkerPostMessage == null) {
      return Future.error('FooError');
    }

    debugPrint('DART::postMessage: send start.');

    // 自作の疑似Queueに追加
    var queData = appendIsorateWebQueue<String>();

    v['number'] = queData.number;
    windowApi.myWorkerPostMessage(util.mapToJSObject(v));

/*
    // TODO futureテスト
    queData.completer.future.then((value) {
      debugPrint('DART::postMessage: future result.');
      debugPrint(value);
    });
*/

    debugPrint('DART::postMessage: send end.');
    return queData.completer.future;
  }

  void _onmessage(e) {
    var res = e.data;
    debugPrint('DART: Message received from worker');
    debugPrint(res.toString());

    var number = res['number'];
    var result = res['result'];
    _completeCompleter(number, result);
  }

  void _completeCompleter(number, result) {
    for (var i = 0; i < isorateWebQueueDataList.length; i++) {
      if (isorateWebQueueDataList[i].number == number) {
        debugPrint('found !');
        isorateWebQueueDataList[i].completer.complete(result);
        isorateWebQueueDataList.removeAt(i);
        break;
      }
    }
  }
}
