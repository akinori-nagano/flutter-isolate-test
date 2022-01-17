import 'dart:js';
import '/window_api.dart' as windowApi;

bool atOnce = true;

class MyWorker {
  postMessage(v) {
    if (atOnce) {
      atOnce == false;
      print('DART::postMessage: register onmessage function.');
      windowApi.myWorkerOnmessageAppend(allowInterop(_onmessage));
    }
    if (windowApi.myWorkerPostMessage != null) {
      print('DART::postMessage: send start.');
      windowApi.myWorkerPostMessage(v);
      print('DART::postMessage: send end.');
    }
  }

  _onmessage(e) {
    var result = e.data;
    print('DART: Message received from worker');
    print(result);
  }
}
