import 'dart:math';

import 'package:flutter/material.dart';
import 'package:interactive_page_flip/constants/app_images.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'dark_home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Padding(
          padding: EdgeInsetsGeometry.all(24),
          child: Center(child: SizedBox(child: HomePage())),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LightHomePage();
  }
}

class LightHomePage extends StatefulWidget {
  const LightHomePage({super.key});

  @override
  State<LightHomePage> createState() => _LightHomePageState();
}

class _LightHomePageState extends State<LightHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _draggingToBlack = true;
  double _dragStartValue = 0.0;
  double _dragDistance = 0.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _animation = Tween<double>(begin: 0, end: pi).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    _dragStartValue = _controller.value;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _controller.value = (_controller.value - details.delta.dx / 500).clamp(
        0.0,
        1.0,
      );
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.value >= 0.5) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _toggleFlip() {
    if (_controller.status == AnimationStatus.completed) {
      _controller.reverse();
    } else if (_controller.status == AnimationStatus.dismissed) {
      _controller.forward();
    } else if (_controller.status == AnimationStatus.forward) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: GestureDetector(
        onHorizontalDragStart: _handleDragStart,
        onHorizontalDragUpdate: _handleDragUpdate,
        onHorizontalDragEnd: _handleDragEnd,
        child: SizedBox(
          width: 500,
          height: 400,
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _animation,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 4, color: Colors.red),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Hello,\nsunshine!',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Spacer(),
                            SvgPicture.asset(
                              AppImages.profile,
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                        Expanded(
                          child: Center(
                            child: SvgPicture.asset(
                              AppImages.day,
                              fit: BoxFit.contain,
                              width: 210,
                              height: 210,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _toggleFlip();
                          },
                          icon: const Icon(Icons.flip),
                        ),
                      ],
                    ),
                  ),
                ),
                builder: (context, child) {
                  final angle = _animation.value;

                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Reverse face: black page
                        if (angle >= pi / 2)
                          Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..rotateY(pi),
                            child: DarkHomePage(onFlip: _toggleFlip),
                          ),

                        // Front face: your original white page
                        if (angle < pi / 2) child!,
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
