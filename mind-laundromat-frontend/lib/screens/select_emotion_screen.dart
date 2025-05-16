import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import 'package:mind_laundromat/screens/counsel_screen.dart';

class SelectEmotionScreen extends StatefulWidget {
  const SelectEmotionScreen({super.key});

  @override
  State<SelectEmotionScreen> createState() => _SelectEmotionScreenState();
}

class _SelectEmotionScreenState extends State<SelectEmotionScreen> {
  String? selectedEmotion;

  final emotions = [
    {'name': 'happiness', 'path': 'assets/emotions/happiness.png'},
    {'name': 'sadness', 'path': 'assets/emotions/sadness.png'},
    {'name': 'anger', 'path': 'assets/emotions/anger.png'},
    {'name': 'neutral', 'path': 'assets/emotions/neutral.png'},
    {'name': 'calm', 'path': 'assets/emotions/calm.png'},
  ];

  Widget emotionItem(Map<String, String> emotion) {
    final isSelected = selectedEmotion == emotion['name'];
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedEmotion = emotion['name'];
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            // 이미지
            Image.asset(
              emotion['path']!,
              width: 100,
              height: 100,
            ),
            // 동그라미 테두리
            if (isSelected)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Icon(Icons.check, color: Colors.white, size: 50,),
              ),
          ],
        ),
      ),
    );
  }

  void goToCounsel() {
    if (selectedEmotion != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CounselScreen(userEmotion: selectedEmotion!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: const CustomAppBar(title: ''),
      body: Column(
        children: [
          const SizedBox(height: 40),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 윗줄 3개
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return emotionItem(emotions[index]);
                  }),
                ),
                const SizedBox(height: 16),
                // 아랫줄 2개
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(2, (index) {
                    return emotionItem(emotions[index + 3]);
                  }),
                ),
                const SizedBox(height: 32),
                const Text(
                  'Pick how you feel',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: selectedEmotion != null ? goToCounsel : null, // 감정이 선택되지 않으면 null
            child: Container(
              margin: const EdgeInsets.only(bottom: 30),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selectedEmotion != null ? Colors.white : Colors.grey[350], // 선택되었을 때만 흰색
              ),
              child: Icon(
                Icons.arrow_forward,
                size: 30,
                color: selectedEmotion != null ? Colors.black : Colors.grey, // 선택되었을 때만 검정색
              ),
            ),
          ),
        ],
      ),
    );
  }
}
