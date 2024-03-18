import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:favorite_test/secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'config.dart';
import 'likes_controller.dart';

class LikeController extends GetxController {
  final String ticker;
  var isLiked = false.obs;
  final LikesController likesController = Get.find<LikesController>();

  LikeController(this.ticker, [bool isLikedInitially = false]) {
    isLiked.value = isLikedInitially;
    // 초기 좋아요 상태 설정
    isLiked.value = likesController.isLiked(ticker);
  }

  Future<void> toggleLike() async {
    final success = await sendLikeRequest(ticker);
    if (success) {
      isLiked.value = !isLiked.value;
      // LikesController에 상태 업데이트 요청
      likesController.toggleLike(ticker);
    }
  }

  Future<bool> sendLikeRequest(String ticker) async {
    var token = await SecureStorage.getAuthToken();
    var likeRequestUri = Uri.http(Config.API_URL, '/interest');
    var now = DateTime.now();
    var formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    var formattedDate = formatter.format(now);

    final response = await http.post(
      likeRequestUri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'ticker': ticker, 'date': formattedDate}),
    );

    if (response.statusCode == 201 ||
        response.statusCode == 200 ||
        response.statusCode == 202) {
      print('좋아요 성공 코드 : ${response.statusCode}');
      print('좋아요 응답 : ${response.body}');
      return true;
    } else {
      print('엥.. 좋아요 안됨 : ${response.statusCode}');
      return false;
    }
  }
}
