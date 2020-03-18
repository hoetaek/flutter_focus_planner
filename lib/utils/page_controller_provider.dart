import 'package:flutter/material.dart';

class PageControllerProvider extends InheritedWidget {
  final PageController pageController;
  PageControllerProvider({
    Widget child,
    this.pageController,
  }) : super(child: child);
  @override
  bool updateShouldNotify(PageControllerProvider oldWidget) =>
      pageController != oldWidget.pageController;
  static PageControllerProvider of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();
}
