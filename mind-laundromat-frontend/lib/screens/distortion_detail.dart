import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import 'dart:math';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:convert';
import 'package:mind_laundromat/services/api_service.dart';


class DistortionDetail extends StatefulWidget {
  const DistortionDetail({super.key});

  @override
  State<DistortionDetail> createState() => _DistortionDetailState();
}

class _DistortionDetailState extends State<DistortionDetail> {
  // final List<String> distortionNames = [
  //   'BLACK_AND_WHITE_THINKING',
  //   'BLAMING',
  //   'CONTROL_FALLACY',
  //   'DISQUALIFYING_THE_POSITIVE',
  //   'EMOTIONAL_REASONING',
  //   'FALLACY_OF_FAIRNESS',
  //   'FORTUNE_TELLING',
  //   'JUMPING_TO_CONCLUSIONS',
  //   'LABELING',
  //   'MAGNIFICATION',
  //   'MENTAL_FILTERING',
  //   'MIND_READING',
  //   'MINIMIZATION',
  //   'OVERGENERALIZATION',
  //   'PERSONALIZATION',
  //   'SHOULD_STATEMENTS',
  // ];


  int selectedIndex = 0;
  bool isDescription = false;
  bool enableFlipAnimation = true;
  List<Map<String, dynamic>> distortionData = [];
  List<String> distortionNames = [];
  int total = 1;

  @override
  void initState() {
    super.initState();
    fetchDistortionData().then((_) {
      // 이미지 프리캐싱
      for (String name in distortionNames) {
        precacheImage(AssetImage('assets/distortion_card/$name.png'), context);
        precacheImage(AssetImage('assets/distortion_card/description/$name.png'), context);
        precacheImage(AssetImage('assets/distortion_card/icons/$name.png'), context);
      }
    });
  }

  // API 요청을 보내서 데이터를 받아오는 함수
  Future<void> fetchDistortionData() async {
    final response = await ApiService.get("/cbt/distortion/list");

    final data = json.decode(response.body); // JSON 파싱
    setState(() {
      total = data['data']['total'] ?? 1;
      distortionData = List<Map<String, dynamic>>.from(data['data']['distortionList']);
      distortionNames = distortionData.map((item) => item['distortionType'] as String).toList();
    });
  }

  void _changeImage(bool isNext) {
    setState(() {
      if (isNext) {
        // 오른쪽 버튼 클릭 시 인덱스 증가
        selectedIndex = (selectedIndex + 1) % distortionNames.length;
      } else {
        // 왼쪽 버튼 클릭 시 인덱스 감소
        selectedIndex = (selectedIndex - 1 + distortionNames.length) % distortionNames.length;
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    if (distortionNames.isEmpty || selectedIndex >= distortionNames.length) {
      // 아직 데이터가 로딩되지 않았거나 인덱스가 유효하지 않음
      return const Center(child: CircularProgressIndicator()); // 또는 SizedBox(), Text("로딩 중입니다") 등
    }


    // 선택된 distortion의 퍼센트 계산
    double percentage = 0.0;
    if (distortionData.isNotEmpty) {
      final distortion = distortionData.firstWhere(
            (item) => item['distortionType'] == distortionNames[selectedIndex],
        //orElse: () => {'count': 0, 'total': 1},
      );
      final count = distortion['count'] ?? 0;
      percentage = count / total * 100;
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: const CustomAppBar(title: 'My Distortion'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 카드 이미지 (그림자 + 카드)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/distortion_card/card_shadow.png',
                      height: 400,
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        if (!enableFlipAnimation) {
                          return child;
                        }

                        final rotate = Tween(begin: pi, end: 0.0).animate(animation);

                        return AnimatedBuilder(
                          animation: rotate,
                          child: child,
                          builder: (context, child) {
                            final isUnder = (ValueKey(isDescription) != child!.key);
                            var tilt = (animation.value - 0.5).abs() - 0.5;
                            tilt *= isUnder ? -0.003 : 0.003;
                            final value = isUnder ? min(rotate.value, pi / 2) : rotate.value;

                            return Transform(
                              transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
                              alignment: Alignment.center,
                              child: child,
                            );
                          },
                        );
                      },
                      layoutBuilder: (widget, list) => Stack(children: [if (widget != null) widget, ...list]),
                      child: GestureDetector(
                        key: ValueKey(isDescription),
                        onTap: () {
                          setState(() {
                            enableFlipAnimation = true;
                            isDescription = !isDescription;
                          });
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              isDescription
                                  ? 'assets/distortion_card/description/${distortionNames[selectedIndex]}.png'
                                  : 'assets/distortion_card/${distortionNames[selectedIndex]}.png',
                              height: 370,
                            ),
                            Positioned(
                              bottom: 30,
                              child: Image.asset(
                                'assets/icons/flip.png',
                                width: 25,
                                height: 25,
                              ),
                            ),
                            if (!isDescription)
                              Positioned(
                                top: 7,
                                left: 7,
                                child: CircularPercentIndicator(
                                  radius: 20.0,
                                  lineWidth: 6.0,
                                  animation: true,
                                  percent: percentage / 100,
                                  center: Text(
                                    "${percentage.toStringAsFixed(0)}%",
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  circularStrokeCap: CircularStrokeCap.round,
                                  progressColor: Colors.white,
                                  backgroundColor: Colors.black26,
                                ),
                              ),

                          ],
                        ),
                      ),
                    ),

                  ],
                ),
                // 왼쪽 화살표
                Positioned(
                  left: 0,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_left),
                      onPressed: () {
                        debugPrint('Left arrow clicked');
                        _changeImage(false);
                        enableFlipAnimation = false;
                        isDescription=false;
                      },
                    ),
                  ),
                ),

                // 오른쪽 화살표 버튼
                Positioned(
                  right: 0,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_right),
                      onPressed: () {
                        debugPrint('Right arrow clicked');
                        enableFlipAnimation=false;
                        isDescription=false;
                        _changeImage(true);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          /// GridView
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: RefreshIndicator(
                onRefresh: () async {
                  await fetchDistortionData();
                  await Future.delayed(const Duration(seconds: 1));
                  debugPrint('Refreshed!');
                },
                child: GridView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: distortionNames.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          enableFlipAnimation = false; // 애니메이션 비활성화
                          selectedIndex = index;
                          isDescription = false;  // 설명을 닫음
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/distortion_card/icons/${distortionNames[index]}.png',
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}