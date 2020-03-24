import 'package:flutter/material.dart';

class DifficultySelector extends StatelessWidget {
  final ValueChanged<int> onDifficultyChanged;
  final int currentDifficulty;
  final diffSentences = [
    '굉장히 쉽고 단기간에 해결가능합니다.',
    '단기간에 해결가능합니다.',
    '해결하는데 시간이 걸립니다.',
    '어렵습니다.',
    '오래 걸리고 어렵습니다.',
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
          child: Column(
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
          )),
    );
  }
}

class DifficultyLevel extends StatelessWidget {
  final int level;
  final bool isActive;
  final Function onTap;
  Color color;
  DifficultyLevel(
      {@required this.level, @required this.isActive, @required this.onTap});
  @override
  Widget build(BuildContext context) {
    color = isActive ? Theme.of(context).primaryColor : Colors.white;
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
