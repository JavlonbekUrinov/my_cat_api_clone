import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WidgetsCatalog{

  /// Dialog
  static void androidDialog({
    required String title,
    required String content,
    required GestureTapCallback onTapNo,
    required GestureTapCallback onTapYes,
    required BuildContext context,
  }) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                  onPressed: onTapNo,
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: onTapYes,
                  child: const Text("Confirm"))
            ],
          );
        });
  }

  static   AnimatedContainer loadMoreAnim(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.easeIn,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.white54),
      duration: const Duration(milliseconds: 4),

      /// Lottie_Loading appear when User reach last post and start Load More
      child: Center(
          child: Lottie.asset('assets/anims/loading.json',
              width: 100)),
    );
  }

  /// SnackBar
  static void showSnackBar(BuildContext context, String content) {
    SnackBar snackBar = SnackBar(
      content: Text(content,style: const TextStyle(color: Colors.yellow),),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}