import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:zoom/Screen/auth/login_screen.dart';

const backgroundColor = Color(0xFFF0F4F8);
const buttonColor = Color(0xFF00BCD4);
const footerColor = Colors.white;
const secondaryBackgroundColor = Color(0xFFD9E1E8);

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: IntroductionScreen(
        globalBackgroundColor: backgroundColor,
        pages: [
          PageViewModel(
            title: "Welcome to Zoom Clone",
            body: "Join, host, and manage online meetings seamlessly.",
            image: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Image.asset('assets/images/meeting (1).png', height: 250),
            ),
            decoration: _pageDecoration(),
          ),
          PageViewModel(
            title: "Video Conferencing",
            body: "Enjoy high-quality video calls with secure connections.",
            image: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Image.asset('assets/images/video.png', height: 250),
            ),
            decoration: _pageDecoration(),
          ),
          PageViewModel(
            title: "Chat with Participants",
            body: "Stay connected through instant chat and reactions.",
            image: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Image.asset('assets/images/bubble-chat.png', height: 250),
            ),
            decoration: _pageDecoration(),
          ),
          PageViewModel(
            title: "Share Screen Easily",
            body: "Present your ideas with clear screen sharing.",
            image: Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Image.asset('assets/images/teaching.png', height: 250),
            ),
            decoration: _pageDecoration(),
          ),
        ],
        onDone: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        },
        showSkipButton: true,
        skip: const Text(
          "Skip",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        next: const Icon(Icons.arrow_forward, color: buttonColor),
        done: const Text(
          "Done",
          style: TextStyle(
            color: buttonColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        dotsDecorator: const DotsDecorator(
          size: Size(10, 10),
          color: Colors.grey,
          activeColor: buttonColor,
          activeSize: Size(22, 10),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
        ),
      ),
    );
  }

  PageDecoration _pageDecoration() {
    return const PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      bodyTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.black54,
      ),
      imagePadding: EdgeInsets.only(top: 20),
      pageColor: backgroundColor,
    );
  }
}
