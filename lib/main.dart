import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'favorite_test_page.dart';
import 'likes_controller.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  Get.put(LikesController());
  runApp(const FavoriteTestPage());
}
