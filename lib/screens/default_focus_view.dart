import 'package:flutter/material.dart';
import 'package:focusplanner/utils/page_controller_provider.dart';

class DefaultFocusView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('빈 페이지'),
      ),
      body: Center(
          child: GestureDetector(
        onTap: () {
          PageControllerProvider.of(context).pageController.animateToPage(
                0,
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
        },
        child: Text('목록을 추가해주세요.'),
      )),
    );
  }
}
