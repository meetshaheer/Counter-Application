import 'package:easy_separator/easy_separator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quizzle/configs/themes/app_colors.dart';
import 'package:quizzle/screens/home/home_screen.dart';
import 'package:quizzle/widgets/common/circle_button.dart';

class AppIntroductionScreen extends StatelessWidget {
  const AppIntroductionScreen({Key? key}) : super(key: key);
  static const String routeName = '/introduction';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(gradient: mainGradient(context)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.2),
          child: EasySeparatedColumn(
            separatorBuilder: (context, index) => const SizedBox(
              height: 40,
            ),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.assignment,
                size: 65,
                color: kOnSurfaceTextColor,
              ),
              const Text(
                'Assessment in this spirit does not concern assignment of grades or evaluation of whether instruction was effective.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: kOnSurfaceTextColor,
                ),
              ),
              CircularButton(
                  onTap: () => Get.offAndToNamed(HomeScreen.routeName),
                  child: const Icon(
                    Icons.arrow_forward,
                    size: 35,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
