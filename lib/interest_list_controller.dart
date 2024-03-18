import 'package:favorite_test/secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'config.dart';
import 'interest_model.dart';
import 'likes_controller.dart';

class InterestListController extends GetxController {
  var interestList = <Interest>[].obs;
  final LikesController likesController = Get.find();

  @override
  void onInit() {
    super.onInit();
    fetchInterestList();
  }

  Future<void> fetchInterestList() async {
    var interestListUri = Uri.http(Config.API_URL, '/interest/list');
    String? accessToken = await SecureStorage.getAuthToken();
    final response = await http.get(
      interestListUri,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      // 흠.. 응답이 딕셔너리로 오네. 추후 다른 데이터를 추가하기 위해..?
      List<String> likedTickers = data.map((item) => item["ticker"].toString()).toList();

      print('Liked Tickers: $likedTickers');

      // 업데이트 전 초기화
      likesController.likesMap.clear();

      for (var ticker in likedTickers) {
        likesController.likesMap[ticker] = true;
      }

      // 업데이트 ㄱ
      interestList.value = likedTickers.map((ticker) => Interest(ticker: ticker)).toList();

      // 강제로 상태 업데이트를 트리거
      likesController.likesMap.refresh();
    } else {
      print('Failed to load liked tickers list');
    }
  }
}