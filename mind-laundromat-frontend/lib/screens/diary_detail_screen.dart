import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mind_laundromat/models/diary.dart';
import 'package:mind_laundromat/widgets/custom_app_bar.dart';

class DiaryDetailScreen extends StatefulWidget {
  final Diary diary;

  const DiaryDetailScreen({super.key, required this.diary});

  @override
  State<DiaryDetailScreen> createState() => _DiaryDetailScreenState();
}

class _DiaryDetailScreenState extends State<DiaryDetailScreen> {
  Diary? _diary;

  @override
  void initState() {
    super.initState();
    _diary = widget.diary;
  }

  @override
  Widget build(BuildContext context) {
    final regDate = _diary!.regDate;
    final monthDay = DateFormat('MMM d,').format(regDate);
    final year = DateFormat('yyyy').format(regDate);
    final time = DateFormat('HH:mm').format(regDate);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Diary'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 회색 배경 박스
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              padding: const EdgeInsets.only(bottom: 28), // summation 하단 여백
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 26),
                  // 이미지 + 날짜, 시간
                  Stack(
                    children: [
                      Image.asset(
                        'assets/items/diary_emotions/${_diary!.emotionType}.png',
                        height: 160,
                        fit: BoxFit.contain,
                      ),
                      // 이미지 좌상단에 날짜
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              monthDay,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w300,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              year,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 이미지 좌하단에 시간
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Text(
                          time,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black38,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // summation 텍스트
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36.0),
                    child: Text(
                      _diary?.summation ?? '',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),


            // 텍스트 내용은 아래 패딩 영역
            Padding(
              padding: const EdgeInsets.all(26.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //const SizedBox(height: 8),

                  const Text(
                    'What I First Thought',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _diary?.beforeContent ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 26),
                  // distortionType 이미지 리스트 출력
                  if (_diary!.distortionType.isNotEmpty )
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _diary!.distortionType.map((distortion) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Image.asset(
                            'assets/items/distortion_banners/$distortion.png',
                            fit: BoxFit.contain,
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 32),

                  const Text(
                    "Let's reframe that",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _diary?.afterContent ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 44),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'A Gentle Note For Me',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Image(
                        image: AssetImage('assets/emotions/calm.png'),
                        height: 50,
                        //width: 36,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _diary?.solution ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
