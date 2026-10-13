import 'package:flutter/material.dart';
import 'package:interactive_page_flip/constants/app_images.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'second_page.dart';

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

class LightHomePage extends StatelessWidget {
  const LightHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: SizedBox(
          width: 500,
          height: 400,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(width: 4, color: Colors.red),
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
                      SvgPicture.asset(
                        AppImages.profile,
                        width: 40,
                        height: 40,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),

                  //const SizedBox(height: 2),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SecondPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.flip),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
