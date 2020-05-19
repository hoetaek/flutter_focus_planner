import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future alertReallyDelete({
  @required BuildContext context,
  @required String name,
  @required Function onAction,
  Function onCancel,
}) {
  if (Platform.isAndroid)
    return showDialog(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text('$name 삭제 확인'),
            content: Text('$name을/를 정말 삭제하시겠습니까?'),
            actions: <Widget>[
              FlatButton(
                child: Text('취소'),
                onPressed: () {
                  onCancel?.call();
                  Navigator.pop(dialogContext);
                },
              ),
              FlatButton(
                child: Text('확인'),
                onPressed: () {
                  onAction();
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          );
        });
  else
    return showCupertinoDialog(
        context: context,
        builder: (dialogContext) {
          return CupertinoAlertDialog(
            title: Text('$name 삭제 확인'),
            content: Text('$name을/를 정말 삭제하시겠습니까?'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('취소'),
                onPressed: () {
                  onCancel?.call();
                  Navigator.pop(dialogContext);
                },
              ),
              CupertinoDialogAction(
                child: Text('확인'),
                onPressed: () {
                  onAction();
                  Navigator.pop(dialogContext);
                },
              ),
            ],
          );
        });
}
