import 'package:flutter/material.dart';

class DifficultySelector extends StatelessWidget {
  final ValueChanged<int> onDifficultyChanged;
  final int currentDifficulty;

  DifficultySelector(
      {@required this.currentDifficulty, @required this.onDifficultyChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            border: Border.all(
              width: 1.0,
              color: Theme.of(context).primaryColor,
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List<Widget>.generate(
              5,
              (int index) => DifficultyLevel(
                  level: index + 1,
                  isActive: currentDifficulty == index + 1,
                  onTap: () {
                    onDifficultyChanged(index + 1);
                  })),
        ),
      ),
    );
  }
}

class DifficultyLevel extends StatelessWidget {
  final int level;
  final bool isActive;
  final Function onTap;
  DifficultyLevel(
      {@required this.level, @required this.isActive, @required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive ? Theme.of(context).primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            width: 1.0,
            color: Colors.grey[200],
          ),
        ),
        child: Text('$level'),
      ),
    );
  }
}
