// ignore_for_file: avoid_print, use_build_context_synchronously, sized_box_for_whitespace, file_names, use_super_parameters
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trauma/features/home/onboard/onboard.dart';
import 'package:video_player/video_player.dart';
import 'package:trauma/core/constant/colors.dart';
import 'package:trauma/core/helper/navigator.dart';
import 'package:trauma/features/widget/button.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  late final VideoPlayerController _controller;
  bool _initialized = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('images/vidu1.mp4')
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _initialized = true);
        _controller.setLooping(false);
        _controller.play();
      }).catchError((_) {
        Future.delayed(const Duration(seconds: 2), _goToOnboarding);
      });
    _controller.addListener(_checkFinished);
  }

  void _checkFinished() {
    final v = _controller.value;
    if (v.isInitialized &&
        v.duration > Duration.zero &&
        v.position >= v.duration &&
        !v.isPlaying) {
      _goToOnboarding();
    }
  }

  void _goToOnboarding() {
    if (_navigated || !mounted) return;
    _navigated = true;
    changeScreenReplacement(context, const OnboardingScreen());
  }

  @override
  void dispose() {
    _controller.removeListener(_checkFinished);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1) The video — fills the ENTIRE screen, cropping overflow.
          if (_initialized)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            )
          else
            Center(child: CircularProgressIndicator(color: primaryColor)),

          // 2) Everything below sits ON TOP of the video.
          SafeArea(
            child: Column(
              children: [
                // Skip button (top-right).
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8, top: 4),
                    child: TextButton(
                      onPressed: _goToOnboarding,
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'sfpro',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(), // pushes the button to the bottom

                // Get Started button.
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: BottomRectangularBtn(
                    btnTitle: 'Get Started',
                    onTapFunc: _goToOnboarding,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}