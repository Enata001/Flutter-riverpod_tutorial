import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const MyHomePage(),
    );
  }
}

extension OptionalInFix<T extends num> on T? {
  T? operator +(T? other) {
    final shadow = this;
    if (shadow != null) {
      return shadow + (other ?? 0) as T;
    } else {
      return null;
    }
  }
}

class Counter extends StateNotifier<int?> {
  Counter() : super(null);

  void increment() => state = state == null ? 1 : state + 1;
}

const names = [
  'Alice',
  'Bob',
  'Charles',
  'Doe',
  'Eve',
  'John',
  'Fred',
  'Jinny',
  'Harris',
  'James',
  'Joseph',
  'Larry',
];

final tickerProvider = StreamProvider(
  (ref) => Stream.periodic(const Duration(milliseconds: 1000), (i) => i + 1),
);

//This is the deprecated version
final namesProvider = StreamProvider((ref) =>
    ref.watch(tickerProvider.stream).map((event) => names.getRange(0, event)));

//This is the proposed version according to the official change docs
final nameProvider = FutureProvider((ref) async {
  final index = await ref.watch(tickerProvider.future);
  return names.getRange(0, index);
});

// This is another proposed version
final otherNameProvider = StreamProvider((ref) => ref
    .watch(tickerProvider.future)
    .asStream()
    .map((event) => names.getRange(0, event)));

class MyHomePage extends ConsumerWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //deprecated provider
    final firstName = ref.watch(namesProvider);

    //proposed version
    final secondName = ref.watch(nameProvider);

    //other proposed version
    final thirdName = ref.watch(otherNameProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather"),
        centerTitle: true,
      ),

      //deprecated provider
      //  body: firstName.when(
      //      data: (data) {
      //        return ListView.builder(
      //            itemCount: data.length,
      //            itemBuilder: (context, index) {
      //              return ListTile(
      //                title: Text(data.elementAt(index)),
      //              );
      //            });
      //      },
      //      error: (error, stack) => const Text("No data"),
      //      loading: () => const Center(child: Text("Loading"))),

      // proposed version
      // body: secondName.when(
      //     data: (data) => ListView.builder(
      //           itemCount: data.length,
      //           itemBuilder: (context, index) {
      //             return ListTile(
      //               title: Text(data.elementAt(index)),
      //             );
      //           },
      //         ),
      //     error: (error, trace) => const Text("No data"),
      //     loading: () => const Center(
      //           child: CircularProgressIndicator(),
      //         ),
      //        ),

      // other proposed version
      // body: thirdName.when(
      //   data: (data) => ListView.builder(
      //     itemCount: data.length,
      //     itemBuilder: (context, index) {
      //       return ListTile(
      //         title: Text(data.elementAt(index)),
      //       );
      //     },
      //   ),
      //   error: (error, trace) => const Text("No data"),
      //   loading: () => const Center(
      //     child: CircularProgressIndicator(),
      //   ),
      // ),
    );
  }
}
