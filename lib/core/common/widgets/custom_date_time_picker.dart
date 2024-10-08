import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SlickDateTimePicker extends StatefulWidget {
  final Function(DateTime) onDateTimeSelected;

  const SlickDateTimePicker({Key? key, required this.onDateTimeSelected})
      : super(key: key);

  @override
  _SlickDateTimePickerState createState() => _SlickDateTimePickerState();
}

class _SlickDateTimePickerState extends State<SlickDateTimePicker> {
  DateTime? _selectedDateTime;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => _showSlickDateTimePicker(context),
      style: ButtonStyle(
        overlayColor: WidgetStateProperty.all(Colors.indigo.withOpacity(0.1)),
        backgroundColor: WidgetStateProperty.all(Colors.transparent),
        padding: WidgetStateProperty.all(EdgeInsets.zero),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _selectedDateTime != null
              ? Colors.indigo.withOpacity(0.05)
              : Colors.transparent,
          border: Border.all(color: Colors.indigo.withOpacity(0.5), width: 1),
          borderRadius: BorderRadius.circular(0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _selectedDateTime != null
                  ? DateFormat('MMM dd, yyyy HH:mm').format(_selectedDateTime!)
                  : 'Select Date and Time',
              style: TextStyle(
                color: Colors.indigo,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(Icons.event, color: Colors.indigo),
          ],
        ),
      ),
    );
  }

  void _showSlickDateTimePicker(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(primary: Colors.indigo),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
             
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        final DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          _selectedDateTime = selectedDateTime;
        });
        widget.onDateTimeSelected(selectedDateTime);
      }
    }
  }
}
