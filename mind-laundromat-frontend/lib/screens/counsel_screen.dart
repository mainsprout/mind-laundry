import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:mind_laundromat/models/diary.dart';
import 'package:mind_laundromat/screens/diary_detail_screen.dart';
import 'package:mind_laundromat/services/api_service.dart';

class CounselScreen extends StatefulWidget {
  final String userEmotion;

  const CounselScreen({super.key, required this.userEmotion});

  @override
  State<CounselScreen> createState() => _CounselScreenState();
}

class _CounselScreenState extends State<CounselScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  String _userEmotion ='';
  String _botEmotion = '';
  bool _isSending = false;
  String _cookie = '';

  // 초기 메시지
  @override
  void initState() {
    super.initState();
    _userEmotion = widget.userEmotion;
    _fetchBotEmotion();
    _messages.add({
      'role': 'bot',
      'content': 'Hello! What are you worried about? Feel free to tell me. 😊',
    });
  }

  // 유저 정보에서 봇 프로필 가져오기
  Future<void> _fetchBotEmotion() async {
    try {
      final response = await ApiService.get("/auth/info");

      final data = json.decode(response.body);
      final emotion = data['data']['emotion']?.toString().toLowerCase();
      if (emotion != null && emotion.isNotEmpty) {
        setState(() {
          _botEmotion = emotion;
        });
      }
    } catch (e) {
      print('Failed to load emotion: $e');
    }
  }

  // 쿠키 파싱 함수
  String? extractCookie(String? setCookieHeader) {
    if (setCookieHeader == null) return null;

    // 여러 개의 쿠키가 있을 수 있으므로 세미콜론이나 콤마로 잘라줌
    final cookies = setCookieHeader.split(',');
    final cookieParts = <String>[];

    for (var cookie in cookies) {
      final parts = cookie.split(';');
      if (parts.isNotEmpty) {
        cookieParts.add(parts[0].trim()); // 이름=값 형태만 추출
      }
    }

    return cookieParts.join('; ');
  }

  // 메시지 주고받기
  Future<void> _sendMessage() async {
    final userInput = _controller.text.trim();
    if (userInput.isEmpty || _isSending) return;

    setState(() {
      _messages.add({'role': 'user', 'content': userInput});
      _isSending = true;
      _controller.clear();
    });
    try {
      //메시지 보내기
      final String body = userInput;

      final response = await ApiService.postMessage(
          "/gemini/chat", _cookie, body
      );

      // 메시지 받기
      final setCookie = response.headers['set-cookie'];
      if (setCookie != null) {
        _cookie = extractCookie(setCookie) ?? '';
      }

      final Map<String, dynamic> data = jsonDecode(response.body);
      final String botResponse = data['gemini']!;

      setState(() {
        _messages.add({'role': 'bot', 'content': botResponse});
      });
    } catch (e) {
      setState(() {
        _messages.add({'role': 'bot', 'content': 'An error occurred.'});
      });
    } finally {
      setState(() {
        _isSending = false;
      });
    }
  }

  // 종료 시그널 보내기
  Future<String?> _sendEndSignal() async {
    try {
      final response = await ApiService.postMessage(
          "/gemini/chat/complete?emotion=$_userEmotion",
          _cookie,
          ""
      );

      final Map<String, dynamic> data = jsonDecode(response.body);
      final diaryId = data['diary_id'];
      print('다이어리 아이디는 $diaryId');
      return diaryId;

    } catch (e) {
      print("예외 발생: $e");
    }
    return null;
  }

  Future<void> _getDiary(String diaryId) async{
    try {
      // 다이어리 정보 가져오기
      final response = await ApiService.get("/cbt/$diaryId");

      // 전체 다이어리 정보 받기
      final Map<String, dynamic> data = jsonDecode(response.body);

      if (data['code'] == 'S201') {
        // 서버에서 받은 다이어리 데이터
        final diaryJson = data['data'];
        final Diary diary = Diary.fromJson(diaryJson);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => DiaryDetailScreen(diary: diary),
          ),
        );
      } else {
        print("서버 응답 코드: ${data['code']}, 메시지: ${data['message']}");
      }
    } catch (e) {
      print("다이어리 정보 예외!!: $e");
    }
  }

  // 뒤로가기 버튼 클릭 시 동작
  void _goBack() {
    Navigator.pop(context);
  }

  // 챗 종료
  Future<void> _endChat() async {
    final diaryId = await _sendEndSignal();
    if (diaryId != null) {
      await _getDiary(diaryId);
    } else {
      print('다이어리 ID를 받지 못해 이동할 수 없습니다.');
    }
  }

  Future<void> _onEndPressed() async {
    final shouldEnd = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("End the chat?"),
          content: Text("Are you sure you want to end the conversation? Your diary will be saved based on the current chat."),
          backgroundColor: Colors.white,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("Cancel", style: TextStyle(color: Colors.grey[400]),),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("End", style: TextStyle(color: Colors.blue),),
            ),
          ],
        );
      },
    );

    if (shouldEnd == true) {
      setState(() {
        _isSending = true;
      });

      await _endChat();

      setState(() {
        _isSending = false;
      });
    }
  }


  Widget _buildMessage(Map<String, String> message) {
    final isUser = message['role'] == 'user';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _botEmotion.isNotEmpty
                ? Image.asset(
                  'assets/emotions/$_botEmotion.png',
                  width: 32,
                  height: 32,
                  //fit: BoxFit.cover,
                ) : Container(
                  width: 32,
                  height: 32,
                  color: Colors.grey[200], // 로딩 중일 때 배경
                ),
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              constraints: const BoxConstraints(maxWidth: 250),
              decoration: BoxDecoration(
                color: isUser
                    ? const Color(0xFFFEFEFE)
                    : const Color(0xFFADCCEC),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(isUser ? 12 : 0),
                  topRight: Radius.circular(isUser ? 0 : 12),
                  bottomLeft: const Radius.circular(12),
                  bottomRight: const Radius.circular(12),
                ),
              ),
              child: Text(
                message['content'] ?? '',
                style: TextStyle(
                  color:
                  isUser ? const Color(0xFF313131) : Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      //appBar: const CustomAppBar(title: ''),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),  // 왼쪽 아이콘과 벽 사이의 간격 설정
          child: IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.black, size: 30),
            onPressed: _goBack,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),  // 오른쪽 아이콘과 벽 사이의 간격 설정
            child: IconButton(
              icon: const Icon(Icons.exit_to_app, color: Colors.black, size: 30),
              onPressed: _onEndPressed,
            ),
          ),
        ],
        toolbarHeight: 60,
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final reversedIndex = _messages.length - 1 - index;
                return _buildMessage(_messages[reversedIndex]);
              },
            ),
          ),
          if (_isSending)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: CircularProgressIndicator(),
            ),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.fromLTRB(12, 16, 12, 32),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Send Message...',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Transform.rotate(
                    angle: -0.2,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFADCCEC),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
