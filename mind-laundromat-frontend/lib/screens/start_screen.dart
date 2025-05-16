import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool? _isLoggedIn;
  double _dragPosition = 0.0;
  double _maxDragDistance = 0.0;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _loadLoginStatus();
  }

  Future<void> _loadLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token') ?? '';

    if (token.isEmpty){
      setState(() {
        _isLoggedIn = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/auth/info'),
        headers: {'Authorization': 'Bearer $token'}, // 'Bearer ' 붙여서 보냄
      );

      if (response.statusCode == 200) {
        setState(() {
          _isLoggedIn = true;
        });
      } else {
        setState(() {
          prefs.clear();
          _isLoggedIn = false;
        });
      }
    } catch (e) {
      print('Access token expired');
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_completed) return;

    setState(() {
      _dragPosition += details.delta.dx;
      if (_dragPosition < 0) _dragPosition = 0;
      if (_dragPosition > _maxDragDistance) {
        _dragPosition = _maxDragDistance;
        _handleSlideComplete();
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_dragPosition < _maxDragDistance) {
      setState(() => _dragPosition = 0);
    }
  }

  Future<void> _handleSlideComplete() async {
    if (_completed) return;
    setState(() => _completed = true);

    await Future.delayed(const Duration(milliseconds: 300));
    if (_isLoggedIn == true) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoggedIn == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFADCCEC), // 배경색
      body: Stack(
        children: [
          // 배경 반원 (전체화면 기준으로 표시됨)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/back_circle.png',
              fit: BoxFit.cover,
            ),
          ),

          // 실제 콘텐츠
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Column(
                  children: [
                    Image.asset(
                      'assets/images/start_logo.png',
                      width: 200,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Mind Laundromat",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(2, 2),       // 그림자 위치 (x, y)
                            blurRadius: 4.0,            // 그림자 번짐 정도
                            color: Colors.black26,      // 그림자 색상
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "For the thoughts left unsaid —\nwe’re here to listen and help you through.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        height: 1.5,
                        shadows: [
                          Shadow(
                            offset: Offset(2, 2),       // 그림자 위치 (x, y)
                            blurRadius: 2.0,            // 그림자 번짐 정도
                            color: Colors.black26,      // 그림자 색상
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    _maxDragDistance = width - 200;

                    return Center(
                      child: Container(
                        width: width,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Color(0xFF042043),//Colors.white.withOpacity(0.2),
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return const LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        Colors.white30,
                                        Colors.white70,
                                      ],
                                    ).createShader(bounds);
                                  },
                                  blendMode: BlendMode.srcIn,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: Image.asset(
                                      'assets/icons/arrow_hint.png',
                                      //width: 60, // 원하는 크기로 조절하세요
                                      //height: 20,
                                      //fit: BoxFit.contain,
                                      //color: Colors.white70, // 필요시 색 조정 (예: 텍스트 느낌 유지)
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: _dragPosition,
                              child: GestureDetector(
                                onPanUpdate: _onPanUpdate,
                                onPanEnd: _onPanEnd,
                                child: Container(
                                  width: 200,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(40),
                                    color: Colors.white,
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    "Get Started!",
                                    style: TextStyle(
                                      color: Color(0xFF042043),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
