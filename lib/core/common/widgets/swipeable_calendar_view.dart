import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:safenest/core/extensions/context_extensions.dart';

class SwipeableCalendarView extends StatefulWidget {
  final Function(DateTime, DateTime)? onDaySelected;

  const SwipeableCalendarView({
    super.key,
    this.onDaySelected,
  });

  @override
  _SwipeableCalendarViewState createState() => _SwipeableCalendarViewState();
}

class _SwipeableCalendarViewState extends State<SwipeableCalendarView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightAnimation;
  bool _isExpanded = false;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heightAnimation = Tween<double>(
      begin: 100,
      end: 400,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
        _calendarFormat = CalendarFormat.month;
      } else {
        _controller.reverse();
        _calendarFormat = CalendarFormat.week;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! < 0 && !_isExpanded) {
          _toggleExpansion();
        } else if (details.primaryVelocity! > 0 && _isExpanded) {
          _toggleExpansion();
        }
      },
      child: AnimatedBuilder(
        animation: _heightAnimation,
        builder: (context, child) {
          return Container(
            height: _heightAnimation.value,
            decoration: BoxDecoration(
              color: context.theme.cardColor,
              borderRadius: BorderRadius.circular(0),
            ),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildCalendar(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2023, 10, 16),
      lastDay: DateTime.utc(2026, 3, 14),
      focusedDay: _focusedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        widget.onDaySelected?.call(selectedDay, focusedDay);
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: context.theme.primaryColor.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: context.theme.primaryColor,
          shape: BoxShape.circle,
        ),
        markerDecoration: BoxDecoration(
          color: context.theme.colorScheme.secondary,
          shape: BoxShape.circle,
        ),
      ),
      headerVisible: _isExpanded,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          color: context.theme.primaryColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        leftChevronIcon: Icon(Icons.chevron_left, color: context.theme.primaryColor),
        rightChevronIcon: Icon(Icons.chevron_right, color: context.theme.primaryColor),
      ),
    );
  }
}