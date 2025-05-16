// lib/models/diary.dart

class Diary {
  int diaryId;
  String? beforeContent;
  String? afterContent;
  DateTime regDate;
  DateTime modDate;
  String emotionType;
  String? summation;
  String? solution;
  List<String> distortionType;

  Diary({
    required this.diaryId,
    required this.beforeContent,
    required this.afterContent,
    required this.regDate,
    required this.modDate,
    required this.emotionType,
    required this.summation,
    required this.solution,
    required this.distortionType,
  });

  // JSON 데이터를 Diary 객체로 변환하는 함수
  factory Diary.fromJson(Map<String, dynamic> json) {
    return Diary(
      diaryId: json['diary_id'],
      beforeContent: json['before_content'],
      afterContent: json['after_content'],
      regDate: DateTime.parse(json['regDate']+'Z').toLocal(),
      modDate: DateTime.parse(json['modDate']+'Z').toLocal(),
      emotionType: json['emotion_type'],
      summation: json['summation'],
      solution: json['solution'],
      distortionType: List<String>.from(json['distortion_type']),
    );
  }
}
