import 'package:evently_c20_online/modules/auth/screens/login_screen.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routeName = 'onboardingScreen';

  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController pageController = PageController();

  int currentPage = 0;

  final List<Map<String, String>> pages = [
    {
      'title': 'Find Events That Inspire You',
      'description':
          'Dive into a world of events crafted to fit your unique interests. '
          'Whether you are into live music, art workshops, professional '
          'networking, or simply discovering new experiences, we have '
          'something for everyone.',
      'image': 'assets/images/illusration (1).png',
    },
    {
      'title': 'Effortless Event Planning',
      'description':
          'Take the hassle out of organizing events with our all-in-one '
          'planning tools. From setting up invites and managing RSVPs to '
          'scheduling reminders and coordinating details, we have got you '
          'covered.',
      'image': 'assets/images/illustration (2).png',
    },
    {
      'title': 'Connect with Friends & Share Moments',
      'description':
          'Make every event memorable by sharing the experience with others. '
          'Our platform lets you invite friends, keep everyone in the loop, '
          'and celebrate moments together.',
      'image': 'assets/images/illustraion (2).png',
    },
  ];

  void nextPage() {
    if (currentPage < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
  }

  void skipPages() {
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 40,
                    child: currentPage == 0
                        ? const SizedBox()
                        : IconButton(
                            onPressed: () {
                              pageController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                            icon: const Icon(Icons.arrow_back_ios),
                            padding: EdgeInsets.zero,
                          ),
                  ),

                  Expanded(
                    child: Center(
                      child: Image.asset(
                        'assets/logo/app_logo.png',
                        height: 35,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),

                  SizedBox(
                    width: 50,
                    child: currentPage == pages.length - 1
                        ? const SizedBox()
                        : TextButton(
                            onPressed: skipPages,
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                color: theme.primaryColor,
                                fontSize: 12,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),


            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = pages[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Expanded(
                          flex: 6,
                          child: Center(
                            child: Image.asset(
                              page['image']!,
                              width: size.width * 0.85,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 100,
                                  color: theme.primaryColorLight,
                                );
                              },
                            ),
                          ),
                        ),


                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(pages.length, (dotIndex) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: currentPage == dotIndex ? 18 : 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: currentPage == dotIndex
                                    ? theme.primaryColor
                                    : theme.primaryColor.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 24),


                        Text(
                          page['title']!,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Expanded(
                          flex: 3,
                          child: SingleChildScrollView(
                            child: Text(
                              page['description']!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 16,
                                fontWeight:FontWeight.w400  ,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),


                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: nextPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5669FF),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              currentPage == pages.length - 1
                                  ? 'Get started'
                                  : 'Next',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold ,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
