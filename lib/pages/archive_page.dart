import 'package:flutter/material.dart';
import 'package:focusplanner/pages/goal_add_page.dart';
import 'package:focusplanner/widgets/actions_icon_button.dart';

class ArchivePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ActionsIconButton(
        buttonState: ButtonState.add,
        addPage: GoalAddPage(),
      ),
    );
  }
}
