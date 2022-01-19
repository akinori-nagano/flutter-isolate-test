# Webの別スレッド処理に関する実装の説明

フォアグラウンドからバックグラウンドへ通知、および結果を得ている

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

### MyWorker class (./lib/isorate/_my_isorate_web.dart)

DartとJavascriptの間でオブジェクトを渡す場合、構造の変更などが必要
Completerを使ってFutureオブジェクトを生成している(./lib/isorate/isorate_web_queue.dart)

```
import '/window_api.dart' as windowApi;

windowApi.myWorkerOnmessageAppend(allowInterop(_onmessage));
    // Dart関数を渡す場合、allowInterop関数の戻りを渡す必要がある

windowApi.myWorkerPostMessage(util.mapToJSObject(v));
    // DartのMapを渡す場合、自作関数util.mapToJSObjectでオブジェクト構造を変更する必要がある
    // util.mapToJSObject => ./lib/utility.dart
```

### Dart to Javascript (./lib/window_api.dart)

Javascriptのオブジェクトを呼ぶ
@JSアノテーションと次の行のexternalにより、Javascript側のオブジェクトを操作可能となる

```
import 'package:js/js.dart';

@JS('window.yobject.myWorker.postMessage')
external Function? myWorkerPostMessage(Object e);

@JS('window.yobject.myWorkerOnmessageAppend')
external Function? myWorkerOnmessageAppend(Function fn);

  // window.yobjectの実態は、./web/index.htmlで実装している
```

## Javascript側の世界

### Javascript Worker(./web/index.html)

window.yobject.myWorkerはWorkerオブジェクト
window.yobject.myWorkerOnmessageAppendは、Worker::onmessageのコールバックが呼ばれた時に呼び出す関数を登録するための関数

```
<script>
  window.yobject = {
    myWorker: null,
    myWorkerOnmessageAppend: null,
  };
  if (window.Worker) {
    window.yobject.myWorker = function() {
      var myWorker = new Worker("my_worker.js");
      return myWorker;
    }();
    window.yobject.myWorkerOnmessageAppend = function(fn) {
      console.log('JS::myWorkerOnmessageAppend: called.');
      window.yobject.myWorker.onmessage = function(e) {
        fn(e);
        console.log('JS::Message received from worker');
      };
    };
  }
</script>
```

### Javascript Worker Task(my_worker.js)

src/js_worker/my_worker.dartをdart2jsを使ってトランスパイルしてmy_worker.jsを作成している
my_worker.jsにはonmessage関数が定義される必要がある
この関数は、Worker::postMessage呼び出し時に別スレッドで呼び出されて実行される
なので、この関数内に時間のかかる重い処理を書くことになる
本サンプルでは、MyWorkerTask::multiply(./lib/isorate/my_isorate_task.dart)が重い処理に当たる

フォアグラウンドへの通知にはpostMessageを使う
ここでも@JSアノテーションとexternalを用いてオブジェクトを操作している(lib/js_worker/my_worker_window_api.dart)
