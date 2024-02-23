import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class test extends StatefulWidget {
  const test({super.key});

  @override
  State<test> createState() => _testState();
}

class _testState extends State<test> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
    Map<DateTime, List<String>> _events = {
    DateTime.utc(2024, 2, 1): ['Event 1'],
    DateTime.utc(2024, 2, 5): ['Event 2', 'Event 3'],
    DateTime.utc(2024, 2, 15): ['Event 4'],
    // เพิ่มเหตุการณ์อื่น ๆ ตามต้องการ
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('data'),),
    body:  TableCalendar(
            daysOfWeekHeight: 30,
            firstDay: DateTime.utc(1965, 1, 1),
            lastDay: DateTime(_focusedDay.year +3 ),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              if (day.weekday == DateTime.sunday ||
                  day.weekday == DateTime.saturday) {}
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                // Call `setState()` when updating the selected day
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  // _selectedEvents = _getEventsForDay(selectedDay);
                });
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                // Call `setState()` when updating calendar format
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              // No need to call `setState()` here
              _focusedDay = focusedDay;
            },
            calendarStyle: CalendarStyle(
              markersOffset: PositionedOffset(top: double.infinity),
              weekendTextStyle: TextStyle(color: Colors.red),
              holidayTextStyle: TextStyle(color: Colors.black),
              holidayDecoration: BoxDecoration(color: Colors.red,shape: BoxShape.circle),
              markersMaxCount: 1,
            ),
            eventLoader: (day) {
              return _events[day] ?? [];
            },
            holidayPredicate: (day) {
              return _events.containsKey(day);
            },
            weekendDays: [DateTime.saturday, DateTime.sunday],
            calendarBuilders: CalendarBuilders(
              dowBuilder: (
                context,
                day,
                
              ) {
                if (day.weekday == DateTime.sunday ||
                    day.weekday == DateTime.saturday) {
                  final text = DateFormat.E().format(day);
                  return Center(
                    child: Text(
                      text,
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
              },
            ),
          ),
    );
  }
}

