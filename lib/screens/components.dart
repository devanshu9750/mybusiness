import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class Components {
  static showLoading(BuildContext context) {
    showModal(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          height: 50,
          width: 50,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
