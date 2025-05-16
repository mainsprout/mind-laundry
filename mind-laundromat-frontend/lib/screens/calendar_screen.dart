import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mind_laundromat/widgets/custom_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:mind_laundromat/screens/diary_detail_screen.dart';
import 'package:mind_laundromat/models/diary.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:mind_laundromat/services/api_service.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  final double circleMargin = 4.0;
  final double fontSize = 14.0;

  List<DateTime> diaryDays = [];
  List<Diary> diaries = [];

  Future<String> getTimezoneName() async {
    return await FlutterTimezone.getLocalTimezone();
  }

  // 월별 다이어리가 기록된 날짜
  Future<void> fetchDiaryDatesForMonth(DateTime month) async {
    try {
      final timezone = await getTimezoneName();

      final response = await ApiService.post("/cbt/month/list", {
        'localDate': DateFormat('yyyy-MM-dd').format(month), // 선택된 월의 첫 번째 날짜
        'timezone' : timezone,
      });

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['code'] == 'S201') {
        // 서버에서 받은 날짜 데이터
        List<String> dateStrings = List<String>.from(data['data']);
        setState(() {
          diaryDays = dateStrings.map((date) => DateTime.parse(date)).toList();
        });
      } else {
        throw Exception(data['message']);
      }
    } catch (e) {
      // 오류 처리
      print('Error fetching diary dates: $e');
    }
  }

  // 날짜별 다이어리들
  Future<void> fetchDiaryForDay(DateTime day) async {
    try {
      final timezone = await getTimezoneName();

      final response = await ApiService.post('/cbt/list', {
        'localDate': DateFormat('yyyy-MM-dd').format(day),
        'timezone': timezone,
      });

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['code'] == 'S201') {
        setState(() {
          diaries = (data['data'] as List)
              .map((e) => Diary.fromJson(e))
              .toList();
        });
      } else {
        throw Exception(data['message']);
      }
    } catch (e) {
      // 오류 처리
      print('Error fetching diary for day: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    fetchDiaryDatesForMonth(_focusedDay); // 앱이 시작될 때 현재 월의 다이어리 날짜 데이터 가져오기
    fetchDiaryForDay(_focusedDay); // 기본적으로 현재 날짜의 다이어리 정보 불러오기
  }

  // 월이 바뀌면 다이어리 날짜 데이터를 다시 받아옴
  void _onMonthChanged(DateTime focusedMonth) {
    setState(() {
      _focusedDay = focusedMonth;  // focusedDay를 바꿔주고
      _selectedDay = DateTime(focusedMonth.year, focusedMonth.month, 1); // 선택은 해당 월의 1일로
    });
    fetchDiaryDatesForMonth(focusedMonth); // 월에 맞는 데이터 새로 불러오기
    fetchDiaryForDay(_selectedDay!); // 선택 날짜의 다이어리도 불러오기

    if (_focusedDay.year == DateTime.now().year &&
        _focusedDay.month == DateTime.now().month) {
      _selectedDay = DateTime.now(); // 만약 오늘이 있으면 선택은 오늘날짜로
    }
  }

  // 날짜가 선택되면 해당 날짜에 대한 다이어리를 불러옴
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    // 선택된 날짜에 대한 다이어리 정보 가져오기
    fetchDiaryForDay(selectedDay);
  }

  bool isDiaryDay(DateTime day) {
    // 같은 연도, 월, 일이 일치하는 경우 다이어리 있는 날로 처리
    return diaryDays.any((diaryDay) =>
    diaryDay.year == day.year &&
        diaryDay.month == day.month &&
        diaryDay.day == day.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Calendar'),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: [
            // White box wrapping the calendar with some padding at top and bottom
            Container(
              //margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0), // 바깥여백
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 30.0), // 내부 여백

              child: TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: _onDaySelected,
                onPageChanged: _onMonthChanged,

                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  headerPadding: EdgeInsets.only(bottom: 16),
                  leftChevronIcon: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[300]!, width: 1.5),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.chevron_left,
                      color: Colors.grey[300],
                    ),
                  ),
                  rightChevronIcon: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: Colors.grey[300]!, width: 1.5),
                    ),
                    padding: const EdgeInsets.all(6),
                    child: Icon(
                      Icons.chevron_right,
                      color: Colors.grey[300],
                    ),
                  ),
                  leftChevronMargin: const EdgeInsets.only(right: 20.0),
                  rightChevronMargin: const EdgeInsets.only(left: 20.0),
                ),

                //rowHeight: 48.0,
                daysOfWeekHeight: 30,
                calendarStyle: CalendarStyle(
                  cellMargin: EdgeInsets.zero,
                  outsideDaysVisible: false,
                ),


                calendarBuilders: CalendarBuilders(
                  dowBuilder: (context, day) {
                    if (day.weekday == DateTime.sunday) {
                      final text = DateFormat.E().format(day);
                      return Center(
                        child: Text(
                          text,
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    return null;
                  },

                  defaultBuilder: (context, day, focusedDay) {
                    if (isDiaryDay(day)) {
                      return Container(
                        margin: EdgeInsets.all(circleMargin),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6BA8E6),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          day.day.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: fontSize,
                          ),
                        ),
                      );
                    }
                    return null;
                  },

                  selectedBuilder: (context, date, focusedDay) {
                    final isToday = isSameDay(date, DateTime.now());
                    final isDiary = isDiaryDay(date);

                    BoxDecoration? decoration;
                    TextStyle? textStyle;

                    if (isToday) {
                      decoration = BoxDecoration(
                        color: const Color(0xFFE2E8ED),
                        shape: BoxShape.circle,
                      );
                      textStyle = TextStyle(
                          color: Color(0xFF446E9A),
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize,
                      );
                    } else if (isDiary) {
                      decoration = BoxDecoration(
                        color: const Color(0xFF6BA8E6),
                        shape: BoxShape.circle,
                      );
                      textStyle = TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      );
                    }

                      return Stack(
                      alignment: Alignment.center,
                      children: [
                        if (decoration != null)
                          Container(
                            margin: EdgeInsets.all(circleMargin),
                            decoration: decoration,
                            alignment: Alignment.center,
                            child: Text(
                              date.day.toString(),
                              style: textStyle,
                            ),
                          )
                        else
                          Text(date.day.toString()),

                        Container(
                          margin: EdgeInsets.all(circleMargin),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(100),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF6BA8E6),
                              width: 2,
                            ),
                          ),
                        ),
                      ],
                    );
                  },

                  todayBuilder: (context, day, focusedDay) {
                    return Container(
                      margin: EdgeInsets.all(circleMargin),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8ED),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          color: Color(0xFF446E9A),
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: diaries.length,
                itemBuilder: (context, index) {
                  final diary = diaries[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DiaryDetailScreen(diary: diary),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // 텍스트 영역
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat('HH:mm').format(diary.regDate),
                                    style: const TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text(
                                    diary.summation ?? '',
                                    style: const TextStyle(fontSize: 16.0),
                                  ),
                                  const SizedBox(height: 8.0),
                                ],
                              ),
                            ),
                          ),

                          // 감정 이미지
                          Image.asset(
                            'assets/items/calendar_emotions/${diary.emotionType}.png',
                            width: 80,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
