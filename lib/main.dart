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
  late Animation<double> _angleAnimation;

  double _rotationAngle = 0.0;
  double _dragStartAngle = 0.0;
  double _dragTotalDx = 0.0;

  bool _isDragging = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _angleAnimation = AlwaysStoppedAnimation<double>(0.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    if (_controller.isAnimating) {
      _rotationAngle = _angleAnimation.value;
      _controller.stop();
    }

    _dragStartAngle = _rotationAngle;
    _dragTotalDx = 0.0;
    _isDragging = true;

    setState(() {});
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _dragTotalDx += details.delta.dx;

    setState(() {
      _rotationAngle = _dragStartAngle - (_dragTotalDx * pi / 500);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    final difference = _rotationAngle - _dragStartAngle;

    double targetAngle;

    if (difference.abs() >= pi / 2) {
      targetAngle = _dragStartAngle + (difference > 0 ? pi : -pi);
    } else {
      targetAngle = _dragStartAngle;
    }

    _animateToAngle(targetAngle);
  }

  void _toggleFlip() {
    final currentAngle = _controller.isAnimating
        ? _angleAnimation.value
        : _rotationAngle;

    final targetAngle = currentAngle + pi;

    _rotationAngle = currentAngle;
    _animateToAngle(targetAngle);
  }

  void _animateToAngle(double targetAngle) {
    _controller.reset();

    _angleAnimation = Tween<double>(
      begin: _rotationAngle,
      end: targetAngle,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _isDragging = false;
    setState(() {});

    _controller.forward().then((_) {
      _rotationAngle = targetAngle;
    });
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
                animation: _controller,
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
                  final angle = _isDragging
                      ? _rotationAngle
                      : _angleAnimation.value;

                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Reverse face: black page
                        if (cos(angle) < 0)
                          Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..rotateY(pi),
                            child: DarkHomePage(onFlip: _toggleFlip),
                          ),

                        // Front face: your original white page
                        if (cos(angle) >= 0) child!,
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
