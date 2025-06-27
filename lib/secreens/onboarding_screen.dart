// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../models/onboarding_page.dart';
import '../../widgets/onboarding_page_widget.dart';
import '../../widgets/animated_star_field.dart';
import 'registration_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: "تتبع بصمتك الكربونية",
      description: "راقب أنشطتك اليومية وشاهد تأثيرها على البيئة.",
      icon: Icons.assessment,
      color: const Color.fromARGB(202, 16, 242, 46),
    ),
    OnboardingPage(
      title: "قلل من تأثيرك",
      description:
          "احصل على نصائح شخصية لتقليل انبعاثات الكربون والعيش بشكل مستدام.",
      icon: Icons.eco,
      color: Color(0xFF909632),
    ),
    OnboardingPage(
      title: "انضم للحركة",
      description: "تواصل مع الآخرين وساهم في جهود الحفاظ على البيئة العالمية.",
      icon: Icons.people,
      color: Color(0xFF909632),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            const AnimatedStarField(),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.teal.withOpacity(0.1),
                    Colors.greenAccent.withOpacity(0.2),
                  ],
                ),
              ),
            ),
            PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (context, index) {
                return OnboardingPageWidget(page: _pages[index]);
              },
            ),
            Positioned(
              top: 50,
              left: 20, // تغيير الموضع ليكون متناسبًا مع RTL
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegistrationScreen(),
                    ),
                  );
                },
                child: const Text(
                  "تخطي",
                  style: TextStyle(
                    color: Color(0xFFF5F5F5),
                    fontSize: 16,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 120,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_pages.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    height: _currentPage == index ? 12 : 8,
                    width: _currentPage == index ? 12 : 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color:
                          _currentPage == index
                              ? Colors.tealAccent
                              : Colors.white.withOpacity(0.5),
                      boxShadow:
                          _currentPage == index
                              ? [
                                BoxShadow(
                                  color: Colors.tealAccent.withOpacity(0.5),
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                ),
                              ]
                              : null,
                    ),
                  );
                }),
              ),
            ),
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistrationScreen(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF5F5F5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                    shadowColor: Color(0xFFF5F5F5),
                  ),
                  child: Text(
                    _currentPage == _pages.length - 1 ? "ابدأ الآن" : "التالي",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
