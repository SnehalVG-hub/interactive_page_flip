import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:interactive_page_flip/constants/app_images.dart';

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            width: 500,
            height: 400,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 4, color: Colors.red),
                color: Colors.black,
                backgroundBlendMode: BlendMode.srcIn,
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),

                child: Column(
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Good night,\nsleep tight!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
                          AppImages.night,
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
                      icon: const Icon(Icons.flip, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
