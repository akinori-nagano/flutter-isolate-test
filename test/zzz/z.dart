import 'dart:js' as js;
import './window_api.dart';

main() {
  void onmessage(e) {
    print('Worker: Message received from main script');
    print(e);
    var workerResult = 'background task';
    myPostMessage(workerResult);
  }
  js.context['onmessage'] = onmessage;
}
