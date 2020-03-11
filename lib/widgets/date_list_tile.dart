import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateListTile extends StatelessWidget {
  DateListTile({
    @required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    String formatted = DateFormat('yyyy-MM-dd').format(date);
    return Text(
      formatted,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
    );
  }
}
