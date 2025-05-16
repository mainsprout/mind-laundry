import 'package:flutter/material.dart';
import 'package:mind_laundromat/screens/distortion_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // 상단: 캘린더 아이콘
            Positioned(
              top: 30,
              left: 16,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(40),
                  onTap: () {
                    Navigator.pushNamed(context, '/calendar');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/icons/today.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
              ),
            ),

            // 오른쪽 상단: 프로필 아이콘
            Positioned(
              top: 30,
              right: 16,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(40),
                  onTap: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/icons/account_circle.png',
                      width: 40,
                      height: 40,
                    ),
                  ),
                ),
              ),
            ),

            // 중앙 : 이미지 + 텍스트
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 160.0), // 원하는 만큼 조절
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DistortionDetail()),
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset('assets/images/home_screen.png'),
                      Positioned(
                        bottom: 20,
                        child: Text(
                          'Tap on the picture!',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 2,
                                color: Colors.black45,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 하단 버튼
            Positioned(
              bottom: 40,
              left: 32,
              right: 32,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/select-emotions');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.black,
                ),
                child: const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Start a ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                      TextSpan(
                        text: 'Mind Cleanse',
                        style: TextStyle(
                          color: Color(0xFF83B6E7),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
