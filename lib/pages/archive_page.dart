import 'package:flutter/material.dart';
import 'package:focusplanner/constants.dart';
import 'package:focusplanner/screens/add_category_card.dart';
import 'package:focusplanner/screens/category_card.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ArchivePage extends StatefulWidget {
  @override
  _ArchivePageState createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  double _scale = 1.0;
  double _previousScale;
  //todo 보기 모드 난이도별 / 카테고리별
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box(Boxes.categoryBox).listenable(),
      builder: (context, Box box, widget) {
        return Padding(
          padding: EdgeInsets.all(20.0),
          child: GestureDetector(
            onScaleStart: (ScaleStartDetails details) {
              print(details);
              // Does this need to go into setState, too?
              // We are only saving the scale from before the zooming started
              // for later - this does not affect the rendering...
              _previousScale = _scale;
            },
            onScaleUpdate: (ScaleUpdateDetails scaleDetails) {
              print(scaleDetails.scale);
              setState(() {
                _scale = _previousScale * 1 / scaleDetails.scale;
                if (_scale < 1)
                  _scale = 1.0;
                else if (_scale > 4) _scale = 4.0;
              });
              print(_scale);
            },
            onScaleEnd: (ScaleEndDetails details) {
              print(details);
              // See comment above
              _previousScale = null;
            },
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _scale.toInt(),
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
                childAspectRatio: 2 / 3,
              ),
              itemCount: box.length + 1,
              itemBuilder: (context, index) {
                //todo 루틴의 경우 매일 초기화되는 'goal'로 만들 것
                if (index != box.length) {
                  return CategoryCard(category: box.getAt(index));
                } else {
                  return AddCategoryCard();
                }
              },
            ),
          ),
        );
      },
    );
  }
}
