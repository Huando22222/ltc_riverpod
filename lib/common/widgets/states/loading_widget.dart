import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final Color? color;
  final String loadingTitle;
  const LoadingWidget({
    super.key,
    this.color,
    this.loadingTitle = 'Đang tải dữ liệu...',
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = color ?? Color(0xFF4A8FD3);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            strokeWidth: 3,
          ),
          SizedBox(height: 16),
          Text(
            loadingTitle,
            style: TextStyle(
              color: primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
