import 'package:js/js_util.dart' as js;

Object mapToJSObject(Map<dynamic,dynamic> a) {
  var object = js.newObject();
  a.forEach((k, v) {
    var key = k;
    var value = v;
    js.setProperty(object, key, value);
  });
  return object;
}
