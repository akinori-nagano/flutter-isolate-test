import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as Riverpod;
import '/isorate/my_isorate.dart';

void main() {
  runApp(
    const Riverpod.ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

final messageProvider = Riverpod.StateProvider.autoDispose((ref) {
  return '';
});

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 1;
  late Riverpod.WidgetRef refMessage;

  /*
   * バックグラウンドで処理する関数
   */
  void _calcBackground(BuildContext context, int num) async {
    final Map argsMap = {
      "v1": 3,
      "v2": num,
    };
    MyWorker w = MyWorker();
    debugPrint('Send request !');
    final response = await w.postMessage(argsMap);
    debugPrint('get one');
    debugPrint(response);

    refMessage.watch(messageProvider.state).state = response;
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Background worker answer:',
            ),
            Riverpod.Consumer(
              builder: (context, ref, child) {
                refMessage = ref;
                final message = ref.watch(messageProvider);
                return Text(message);
              },
            ),
            const SizedBox(
              height: 35,
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _incrementCounter();
          _calcBackground(context, _counter);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
