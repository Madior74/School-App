import 'package:flutter/material.dart';
import 'package:school_app/theme/color.dart';

class CourseItem extends StatelessWidget {
  final String subject;
  final String time;
  final String room;
  final String? teacher;
  final Color? subjectColor;

  const CourseItem({
    super.key,
    required this.subject,
    required this.time,
    required this.room,
    this.teacher,
    this.subjectColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: subjectColor ?? myblueColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 14,
                    color: textSecondaryColor,
                  ),
                ),
                Text(
                  room,
                  style: TextStyle(
                    fontSize: 14,
                    color: textSecondaryColor,
                  ),
                ),
                if (teacher != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Prof: $teacher',
                    style: TextStyle(
                      fontSize: 12,
                      color: textSecondaryColor,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
