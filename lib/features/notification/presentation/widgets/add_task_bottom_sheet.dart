import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:safenest/core/common/widgets/custom_date_time_picker.dart';

import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safenest/features/notification/data/model/child_task_model.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final Function(ChildTaskModel) onTaskCreated;

  const AddTaskBottomSheet({Key? key, required this.onTaskCreated})
      : super(key: key);

  @override
  _AddTaskBottomSheetState createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  String _selectedPriority = 'Medium';
  DateTime? _selectedDateTime;

  final Map<String, Color> _priorityColors = {
    'Low': Colors.green,
    'Medium': Colors.orange,
    'High': Colors.red,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDragHandle(),
              const SizedBox(height: 16),
              _buildTaskTitleInput(),
              const SizedBox(height: 16),
              _buildTaskDescriptionInput(),
              const SizedBox(height: 16),
              _buildDateTimePicker(),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Priority',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: _priorityColors.entries.map((entry) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: _buildPriorityButton(entry.key, entry.value),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildRewardPointsSlider(),
              const SizedBox(height: 16),
              _buildAdditionalOptions(),
              const SizedBox(height: 16),
              _buildCreateTaskButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildTaskTitleInput() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Task Title',
        labelStyle: GoogleFonts.montserrat(color: Colors.grey[600]),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: context.theme.primaryColor),
        ),
      ),
      style: GoogleFonts.montserrat(),
    );
  }

  Widget _buildTaskDescriptionInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        maxLines: null,
        minLines: 3,
        maxLength: 200,
        decoration: InputDecoration(
          labelText: 'Task Description',
          labelStyle: GoogleFonts.montserrat(
            color: context.theme.primaryColor,
            fontSize: 16,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: InputBorder.none,
          suffixIcon: Icon(
            Icons.edit_note,
            color: context.theme.primaryColor,
          ),
          counterStyle: GoogleFonts.montserrat(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        style: GoogleFonts.montserrat(fontSize: 14),
        cursorColor: context.theme.primaryColor,
      ),
    );
  }

   Widget _buildDateTimePicker() {
    return Row(
      children: [
        Expanded(
          child: SlickDateTimePicker(
            onDateTimeSelected: (DateTime dateTime) {
              setState(() {
                _selectedDateTime = dateTime;
              });
            },
          ),
        ),
        const SizedBox(width: 8),
        _buildVoiceInput(),
      ],
    );
  }

  Widget _buildVoiceInput() {
    return TextButton(
      onPressed: () {
        // TODO: Implement voice input functionality
      },
      style: TextButton.styleFrom(
        backgroundColor: context.theme.primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: Icon(Icons.mic, size: 18),
    );
  }

  Widget _buildPriorityButton(String priority, Color color) {
    bool isSelected = _selectedPriority == priority;
    return GestureDetector(
      onTap: () => _selectPriority(priority),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          border: Border.all(color: color, width: .5),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                      color: color.withOpacity(0.4),
                      blurRadius: 4,
                      offset: Offset(0, 2))
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getPriorityIcon(priority),
              color: isSelected ? Colors.white : color,
              size: 24,
            ),
            const SizedBox(width: 4),
            Text(
              priority,
              style: GoogleFonts.plusJakartaSans(
                color: isSelected ? Colors.white : color,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority) {
      case 'Low':
        return Icons.flag_outlined;
      case 'Medium':
        return Icons.flag;
      case 'High':
        return Icons.flag_rounded;
      default:
        return Icons.flag;
    }
  }

  void _selectPriority(String priority) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedPriority = priority;
    });
  }

  Widget _buildRewardPointsSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reward Points',
          style: GoogleFonts.montserrat(
            color: Colors.grey[600],
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: context.theme.primaryColor,
            inactiveTrackColor: Colors.grey[300],
            thumbColor: context.theme.primaryColor,
            overlayColor: context.theme.primaryColor.withOpacity(0.2),
            valueIndicatorColor: context.theme.primaryColor,
            valueIndicatorTextStyle: GoogleFonts.montserrat(
              color: Colors.white,
            ),
          ),
          child: Slider(
            value: 50, // TODO: Replace with actual value from state
            min: 0,
            max: 100,
            divisions: 10,
            label: '50 points', // TODO: Replace with actual value from state
            onChanged: (value) {
              // TODO: Update reward points in the state
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalOptions() {
    return ExpansionTile(
      title: Text(
        'Additional Options',
        style: GoogleFonts.montserrat(
          color: Colors.grey[600],
          fontSize: 16,
        ),
      ),
      children: [
        CheckboxListTile(
          title: Text('Recurring Task', style: GoogleFonts.montserrat()),
          value: false, // TODO: Replace with actual value from state
          onChanged: (value) {
            // TODO: Update recurring task option in the state
          },
        ),
        CheckboxListTile(
          title: Text('Set Reminder', style: GoogleFonts.montserrat()),
          value: false, // TODO: Replace with actual value from state
          onChanged: (value) {
            // TODO: Update reminder option in the state
          },
        ),
      ],
    );
  }

  Widget _buildCreateTaskButton() {
    return TextButton(
      onPressed: () {
        // TODO: Implement task creation logic
        // Create a ChildTask object and call widget.onTaskCreated(childTask);
      },
      child: Text('Create Task',
          style: GoogleFonts.montserrat(fontSize: 18, color: Colors.white)),
      style: TextButton.styleFrom(
        backgroundColor: context.theme.primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
