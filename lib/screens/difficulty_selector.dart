import 'package:flutter/material.dart';

class DifficultySelector extends StatelessWidget {
  final ValueChanged<int> onDifficultyChanged;
  final int currentDifficulty;
  static const diffSentences = [
    '하루 안에 할 계획입니다.',
    '2~3일 안에 할 계획니다.',
    '2~3주 안에 할 계획니다.',
    '2~3달 안에 할 계획니다.',
    '장기적으로 생각하고 있습니다.',
  ];

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
          child: DifficultyLevelList(
            currentDifficulty: currentDifficulty,
            onDifficultyChanged: onDifficultyChanged,
          )),
    );
  }
}

class DifficultyLevelList extends StatelessWidget {
  final int currentDifficulty;
  final ValueChanged<int> onDifficultyChanged;

  static const diffSentences = [
    '하루 안에 할 계획입니다.',
    '2~3일 안에 할 계획니다.',
    '2~3주 안에 할 계획니다.',
    '2~3달 안에 할 계획니다.',
    '장기적으로 생각하고 있습니다.',
  ];

  const DifficultyLevelList(
      {Key key, this.currentDifficulty, this.onDifficultyChanged})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
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
        Padding(
          padding: EdgeInsets.only(left: 20.0, top: 5.0, bottom: 10.0),
          child: Text('${diffSentences[currentDifficulty - 1]}'),
        )
      ],
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
    Color color = isActive ? Theme.of(context).primaryColor : Colors.white;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(10.0),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            width: 1.0,
            color: Colors.grey[200],
          ),
        ),
        child: Text(
          '$level',
          style: TextStyle(
              color:
                  color.computeLuminance() > 0.5 ? Colors.black : Colors.white),
        ),
      ),
    );
  }
}
