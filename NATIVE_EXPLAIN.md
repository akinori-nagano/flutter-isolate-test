# Nativeの別スレッド処理に関する実装の説明

フォアグラウンドからバックグラウンドへ通知、および結果を得る。  

## Dart側の世界

### 通知と結果

```
import '/isorate/my_isorate.dart';

final Map<String, int> argsMap = {
  "v1": 3,
  "v2": num,
};
MyWorker w = MyWorker();
final response = await w.postMessage(argsMap);
print(response);
```

### MyWorker class (./lib/isorate/_my_isorate_native.dart)

Dart::Isorateではなく、以下のflutter_isolateパッケージを利用します。  
Dart::Isorateは、Android、iOSのAPIを呼ぶ事が出来ないようです。  
https://pub.dev/packages/flutter_isolate  

FlutterIsolate.spawnでスレッド処理を実行します。
スレッド間のメッセージのやり取りはReceivePort、SendPortで行います。

```
import 'package:flutter_isolate/flutter_isolate.dart';

class MyWorker {
  Future<dynamic> postMessage(Map v) async {
    ReceivePort receivePort = ReceivePort();
    Map arg = v;
    v['sendPort'] = receivePort.sendPort;
    await FlutterIsolate.spawn(_onmessage, arg);
    return await receivePort.first;
  }

  static _onmessage(Map mapobj) async {
    SendPort? sendPort = mapobj['sendPort'];
    MyWorkerTask myWorkerTask = new MyWorkerTask();
    var v = myWorkerTask.multiply(v1, v2);
    sendPort.send('Worker::result:send: ' + v);
  }
}
```
