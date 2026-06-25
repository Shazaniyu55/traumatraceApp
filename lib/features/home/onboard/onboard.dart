// ignore_for_file: file_names, use_super_parameters
import 'package:flutter/material.dart';
import 'package:trauma/core/constant/colors.dart';
import 'package:trauma/core/helper/navigator.dart';
import 'package:trauma/features/auth/login_screen.dart';
import 'package:trauma/features/widget/button.dart';

/// Shown after the splash video. Three full-screen photo steps describing the
/// app, ending in a "Get Started" button that goes to the LoginScreen.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingStep {
  final String image;
  final String title;
  final String description;
  const _OnboardingStep({
    required this.image,
    required this.title,
    required this.description,
  });
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _current = 0;

  final List<_OnboardingStep> _steps = const [
    _OnboardingStep(
      image: 'images/trace1.png',
      title: 'Explore Your Patterns',
      description:
          'Answer a few gentle questions to uncover the stressors and patterns that may have shaped your wellbeing.',
    ),
    _OnboardingStep(
      image: 'images/trace2.png',
      title: 'See Your Trace',
      description:
          'Get a personalised reflection that maps current patterns back to their roots — and the strengths they gave you.',
    ),
    _OnboardingStep(
      image: 'images/trace2.png',
      title: 'Grow & Find Support',
      description:
          'Journal privately, revisit your reflections, and connect with trauma-informed resources whenever you need them.',
    ),
  ];

  void _next() {
    if (_current < _steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() {
    changeScreenReplacement(context, const LoginScreen());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _current == _steps.length - 1;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1) Full-screen swipeable images, with each page's text overlaid.
          PageView.builder(
            controller: _pageController,
            itemCount: _steps.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (_, i) {
              final step = _steps[i];
              return Stack(
                fit: StackFit.expand,
                children: [
                  // The image fills the ENTIRE screen, cropping overflow.
                  Image.asset(
                    step.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (_, __, ___) => Container(
                      color: listCardColor,
                      child: Icon(
                        Icons.image_outlined,
                        size: 120,
                        color: placeholderColor,
                      ),
                    ),
                  ),

                  // Dark gradient at the bottom so the text stays readable.
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.center,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black87],
                      ),
                    ),
                  ),

                  // This page's title + description, sitting above the controls.
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      // Bottom padding leaves room for the dots + button.
                      padding: const EdgeInsets.fromLTRB(32, 0, 32, 170),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            step.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'sfpro',
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            step.description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontFamily: 'sfpro',
                              color: Colors.white70,
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // 2) Fixed overlay: Skip on top, dots + button pinned to the bottom.
          SafeArea(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8, top: 4),
                    child: TextButton(
                      onPressed: _goToLogin,
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

                const Spacer(),

                // Page indicator dots.
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_steps.length, (i) {
                    final active = i == _current;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: active ? 24 : 8,
                      decoration: BoxDecoration(
                        color: active ? primaryColor : Colors.white54,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: BottomRectangularBtn(
                    btnTitle: isLast ? 'Get Started' : 'Next',
                    onTapFunc: _next,
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