import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'interest_list_controller.dart';
import 'like_controller.dart';
import 'favorite_item_widget.dart';
import 'likes_controller.dart';
import 'secure_storage.dart';

class FavoriteTestPage extends StatefulWidget {
  const FavoriteTestPage({Key? key}) : super(key: key);

  @override
  State<FavoriteTestPage> createState() => _FavoriteTestPageState();
}

class _FavoriteTestPageState extends State<FavoriteTestPage> {
  final String? testId = dotenv.env['TEST_ID'];
  final String? testPw = dotenv.env['TEST_PW'];

  final InterestListController interestListController =
      Get.put(InterestListController());
  final LikesController likesController = Get.find();

  // 로그인 기능
  Future<bool> login(String email, String password) async {
    var loginUri = Uri.http(Config.API_URL, '/users/login');
    final response = await http.post(
      loginUri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'passwd': password}),
    );

    if (response.statusCode == 200) {
      print("token : ${response.headers['authorization']}");
      print("Rtoken : ${response.headers['refresh']}");
      saveTokens(response);
      return true;
    } else {
      return false;
    }
  }

  // 토큰 저장 메서드
  void saveTokens(http.Response response) async {
    final authToken = response.headers['authorization']?.split(' ').last;
    final refreshToken = response.headers['refresh']?.split(' ').last;

    if (authToken != null && refreshToken != null) {
      await SecureStorage.saveAuthToken(authToken);
      await SecureStorage.saveRefreshToken(refreshToken);
    }
  }

  // 로그아웃 기능
  void logout() async {
    await SecureStorage.deleteAllTokens();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final List<String> aiProviderTicker = [
      'GOOGL',
      'AAPL',
      'MSFT',
      "MMM",
      "TSLA"
    ];

    return Obx(() {
      Map<String, LikeController> controllers = {};

      for (var ticker in aiProviderTicker) {
        bool isLiked = likesController.isLiked(ticker);
        // LikeController 인스턴스 생성 및 초기 좋아요 상태 설정
        controllers[ticker] = LikeController(ticker, isLiked);
      }

      return buildPage(aiProviderTicker, controllers);
    });
  }

  // 메인 페이지 구성
  Widget buildPage(
      List<String> tickers, Map<String, LikeController> controllers) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(gradient: createBackgroundGradient()),
            child: buildContent(tickers, controllers),
          ),
        ),
      ),
    );
  }

  // 스크롤 가능한 컨텐츠 구성
  Widget buildContent(
      List<String> tickers, Map<String, LikeController> controllers) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 50),
          ...tickers.map((ticker) => glassmorphismCard(
                child: FavoriteItemWidget(
                    ticker: ticker, controller: controllers[ticker]!),
              )),
          const SizedBox(height: 50),
          buildActionButton(),
        ],
      ),
    );
  }

  // 배경 그라데이션 생성
  LinearGradient createBackgroundGradient() {
    return LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        Color(0xFF7986CB), // Light Indigo
        Color(0xFFE1BEE7), // Light Purple
      ],
    );
  }

  // 액션 버튼 ( 로그인 / 로그아웃 ) 생성
  Widget buildActionButton() {
    return FutureBuilder<String?>(
      future: SecureStorage.getRefreshToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return LogoutButton();
        } else {
          return LoginButton();
        }
      },
    );
  }

// 글라스모피즘 카드 생성
  Widget glassmorphismCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.4),
                Colors.white.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget LoginButton() {
    return glassmorphismCard(
      child: ElevatedButton(
        onPressed: () async {
          bool loggedIn = await login(testId!, testPw!);
          if (loggedIn) {
            print("로그인 성공");
            setState(() {});
          } else {
            print("로그인 실패");
          }
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        child: const Text('LOGIN TEST',
            style: TextStyle(fontSize: 14, color: Colors.white)),
      ),
    );
  }

  // 로그아웃 버튼 위젯
  Widget LogoutButton() {
    return glassmorphismCard(
      child: ElevatedButton(
        onPressed: () async {
          await SecureStorage.deleteAllTokens();
          print("로그아웃 성공");
          setState(() {});
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        child: const Text('LOGOUT',
            style: TextStyle(fontSize: 14, color: Colors.white)),
      ),
    );
  }
}
