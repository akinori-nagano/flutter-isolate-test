import 'dart:js';
import '/window_api.dart' as windowApi;

bool atOnce = true;

class MyWorker {
  postMessage(v) {
    if (atOnce) {
      atOnce == false;
      print('DART::check onmessage');
      print(onmessage);
      windowApi.myWorkerOnmessageAppend(allowInterop(onmessage));
    }
    if (windowApi.myWorkerPostMessage != null) {
      print('DART::postMessage: send start.');
      windowApi.myWorkerPostMessage(v);
      print('DART::postMessage: send end.');
    }
  }

  onmessage(e) {
    var result = e.data;
    print('DART: Message received from worker');
    print(result);
  }
}
