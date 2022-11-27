import 'package:flutter/material.dart';

void main() => runApp(const LogoApp());

class LogoApp extends StatefulWidget {
  const LogoApp({super.key});

  @override
  State<LogoApp> createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  double _begin = 0;
  double _end = 300;

  void myFunc() {
    setState(() {
      if (_end == 300) {
        _begin = 300;
        _end = 50;
      } else {
        _begin = 50;
        _end = 300;
      }
    });
    controller.reset();
    animation = Tween<double>(begin: _begin, end: _end).animate(controller)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });
    controller.forward();
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = Tween<double>(begin: _begin, end: _end).animate(controller)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: animation.value,
        width: animation.value,
        child: GestureDetector(
          onTap: myFunc,
          child: const FlutterLogo(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
