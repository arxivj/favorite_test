import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'like_controller.dart';

class FavoriteItemWidget extends StatelessWidget {
  final String ticker;
  final LikeController controller;

  const FavoriteItemWidget(
      {Key? key, required this.ticker, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      IconData iconData =
          controller.isLiked.value ? Icons.favorite : Icons.favorite_border;
      Color iconColor = controller.isLiked.value ? Colors.red : Colors.grey;
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          children: [
            Text(ticker, style: TextStyle(fontSize: 16)),
            Spacer(),
            IconButton(
              onPressed: () async {
                await controller.toggleLike();
              },
              icon: Icon(iconData, color: iconColor),
            ),
          ],
        ),
      );
    });
  }
}
