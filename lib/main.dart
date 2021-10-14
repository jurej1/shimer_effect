import 'package:flutter/material.dart';
import 'package:shimer_effect/shimmer.dart';

void main() {
  runApp(const MyApp());
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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Shimmer(
          duration: Duration(seconds: 4),
          child: Text('Hello Jure! Swipe to unlock'),
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Colors.orange,
            ],
          ),
        ),
      ),
    );
  }
}
