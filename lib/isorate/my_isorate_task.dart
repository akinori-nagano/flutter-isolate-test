import 'package:flutter/material.dart';

class MyWorkerTask {
  String multiply(int v1, int v2) {
    // 無駄に時間のかかる処理を実行
    // ブラウザなどのフロントが固まらない事を確認する
    debugPrint('multiply::delay: start');
    var n = 0.01;
    for (var j = 0; j < 100; j++) {
      for (var i = 0; i < 100000; i++) {
        var v1 = i * 10000;
        var v2 = v1 / 12.3;
        var v3 = v2 % 999;
        n = v3;
      }
    }
    debugPrint(n.toString());
    debugPrint('multiply::delay: end');

    var r = v1 * v2;
    return r.toString();
  }
}
