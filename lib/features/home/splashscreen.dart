// ignore_for_file: avoid_print, use_build_context_synchronously, sized_box_for_whitespace, file_names, use_super_parameters
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:trauma/core/constant/colors.dart';
import 'package:trauma/core/helper/navigator.dart';
import 'package:trauma/features/auth/login_screen.dart';
import 'package:trauma/features/widget/button.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  var hide = true.obs;
  bool canAuthenticateWithBiometrics = false;

  bool isDeviceSupported = false;



  @override
  void initState() {
    showBtn();
    super.initState();
  }



  void showBtn() {
    Future.delayed(const Duration(milliseconds: 100), () {
      hide.value = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              // Status bar color
              statusBarColor: lightColor,

              // Status bar brightness (optional)
              statusBarIconBrightness:
                  Brightness.dark, // For Android (dark icons)
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
            ),
            elevation: 0,
          ),
        ),
        backgroundColor: primaryBackgroundColor,
        body: SingleChildScrollView(
  child: ConstrainedBox(
    constraints: BoxConstraints(
      minHeight: MediaQuery.of(context).size.height,
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LayoutBuilder(
  builder: (context, constraints) {
    double screenWidth = constraints.maxWidth;

    double logoSize;

    if (screenWidth > 1200) {
      logoSize = 120; // desktop
    } else if (screenWidth > 800) {
      logoSize = 140; // tablet
    } else {
      logoSize = 180; // mobile
    }

    return Image.asset(
      'images/logo.png',
      height: logoSize,
      width: logoSize,
      fit: BoxFit.contain,
    );
  },
),
              const SizedBox(height: 8),
              Text(
                'TraumaTrace',
                style: TextStyle(
                  fontFamily: 'sfpro',
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 39.0,
                ),
              ),
              
            ],
          ),
const SizedBox(height: 32),
          BottomRectangularBtn(onTapFunc: (){
            changeScreenReplacement(context, LoginScreen());
          }, btnTitle: "Get Started",)
         
        ],
      ),
    ),
  ),
),
      );
    
  }

 

}



