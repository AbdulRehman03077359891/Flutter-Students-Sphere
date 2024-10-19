import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studentsphere/Screens/Firebase/sign_in.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int currentPage = 0;
  final PageController _pageController = PageController();

  // Data for splash screens
  final List<Map<String, dynamic>> splashData = [
    {
      "title": "SCHOLARSHIPS",
      "text": "Unlock opportunities with exclusive scholarships designed to support your learning journey.",
      "image": "assets/images/vector_scholarship.jpeg",
      "color": const Color.fromARGB(255, 182, 237, 255),
      "textColor": const Color.fromARGB(255, 18, 40, 136),
      "subTextColor": Colors.black,
    },
    {
      "title": "CAREER GUIDANCE",
      "text": "Get expert advice and direction to shape your career path and achieve your goals.",
      "image": "assets/images/vector_careerguidence.png",
      "color": const Color.fromARGB(255, 18, 40, 136),
      "textColor": const Color.fromARGB(255, 182, 237, 255),
      "subTextColor": Colors.white,
    },
    {
      "title": "EVENTS",
      "text": "Stay updated on exciting events and workshops that enhance your skills and network.",
      "image": "assets/images/vector_event.jpeg",
      "color": Colors.white,
      "textColor": const Color.fromARGB(255, 18, 40, 136),
      "subTextColor": Colors.black,
    },
  ];

  // Get the background color based on the current page
  Color _getBackgroundColor(double pageOffset) {
    int baseIndex = pageOffset.floor();
    double pageFraction = pageOffset - baseIndex;
    Color startColor = splashData[baseIndex]['color'];
    Color endColor = splashData[(baseIndex + 1).clamp(0, splashData.length - 1)]['color'];
    return Color.lerp(startColor, endColor, pageFraction)!;
  }

  // Get the text color based on the current page
  Color _getTextColor(double pageOffset) {
    int baseIndex = pageOffset.floor();
    double pageFraction = pageOffset - baseIndex;
    Color startTextColor = splashData[baseIndex]['textColor'];
    Color endTextColor = splashData[(baseIndex + 1).clamp(0, splashData.length - 1)]['textColor'];
    return Color.lerp(startTextColor, endTextColor, pageFraction)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          return Container(
            color: _getBackgroundColor(_pageController.hasClients ? _pageController.page ?? 0.0 : 0.0),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Expanded(
                      flex: 3,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (value) {
                          setState(() {
                            currentPage = value;
                          });
                        },
                        itemCount: splashData.length,
                        itemBuilder: (context, index) => SplashContent(
                          image: splashData[index]["image"],
                          text: splashData[index]['text'],
                          title: splashData[index]['title'],
                          textColor: splashData[index]['textColor'],
                          subTextColor: splashData[index]['subTextColor'],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: <Widget>[
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                splashData.length,
                                (index) => AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  margin: const EdgeInsets.only(right: 5),
                                  height: 6,
                                  width: currentPage == index ? 20 : 6,
                                  decoration: BoxDecoration(
                                    color: currentPage == index
                                        ? _getTextColor(_pageController.hasClients ? _pageController.page ?? 0.0 : 0.0)
                                        : const Color(0xFFD8D8D8),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(flex: 3),
                            ElevatedButton(
                              onPressed: () {
                                Get.off(const SignInPage());
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: _getTextColor(_pageController.hasClients ? _pageController.page ?? 0.0 : 0.0),
                                foregroundColor: (currentPage == 1)
                                    ? splashData[currentPage]['color']
                                    : Colors.white,
                                minimumSize: const Size(double.infinity, 48),
                                shape: const ContinuousRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(30)),
                                ),
                              ),
                              child: const Text("Continue"),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SplashContent extends StatelessWidget {
  const SplashContent({
    super.key,
    this.text,
    this.image,
    this.title,
    this.textColor,
    this.subTextColor,
  });
  
  final String? text, image, title;
  final Color? textColor, subTextColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Spacer(),
        Text(
          title!,
          softWrap: true,
          maxLines: 9,
          style: TextStyle(
            fontSize: 32,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          text!,
          textAlign: TextAlign.center,
          style: TextStyle(color: subTextColor),
        ),
        const Spacer(flex: 2),
        Image.asset(
          image!,
          fit: BoxFit.contain,
          height: 265,
          width: 235,
        ),
      ],
    );
  }
}
