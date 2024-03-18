import 'package:get/get.dart';

class LikesController extends GetxController {
  var likesMap = <String, bool>{}.obs;

  void toggleLike(String ticker) {
    if (likesMap.containsKey(ticker)) {
      likesMap[ticker] = !likesMap[ticker]!;
    } else {
      likesMap[ticker] = true;
    }
    update();
  }

  bool isLiked(String ticker) {
    return likesMap[ticker] ?? false;
  }
}
