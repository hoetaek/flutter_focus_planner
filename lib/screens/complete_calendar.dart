import 'package:flutter/material.dart';
import 'package:focusplanner/models/daily_goal.dart';
import 'package:table_calendar/table_calendar.dart';

class CompleteCalendar extends StatefulWidget {
  final Map<DateTime, List> events;
  const CompleteCalendar({Key key, this.events}) : super(key: key);
  @override
  _CompleteCalendarState createState() => _CompleteCalendarState();
}

class _CompleteCalendarState extends State<CompleteCalendar> {
  CalendarController _calendarController;
  Map<DateTime, List> _events;
  List _selectedEvents;

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedEvents = events;
    });
  }

  @override
  void initState() {
    final _selectedDay = DateTime.now().getDateDay();

    _events = widget.events;

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    super.initState();
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        TableCalendar(
          onDaySelected: _onDaySelected,
          events: _events,
          calendarController: _calendarController,
        ),
        const SizedBox(height: 8.0),
        Expanded(child: _buildEventList()),
      ],
    );
  }

  Widget _buildEventList() {
    return ListView(
      children: _selectedEvents
          .map((event) => Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  title: Text(event.toString()),
                  onTap: () => print('$event tapped!'),
                ),
              ))
          .toList(),
    );
  }
}
