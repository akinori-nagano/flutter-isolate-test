import 'package:js/js.dart';

@JS('window.yobject.myWorker.postMessage')
external Function? myWorkerPostMessage(Object e);

@JS('window.yobject.myWorkerOnmessageAppend')
external Function? myWorkerOnmessageAppend(Function fn);
