import 'package:flutter/material.dart';

class ToDo extends StatelessWidget {
  final String? textField;
  final bool isFinished;
  ToDo({required this.isFinished, this.textField});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 26,
        vertical: 5.0,
      ),
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 15.0),
            child: Icon(
              isFinished ? Icons.check_box : Icons.check_box_outline_blank,
              color: isFinished ? Color(0xFFe05a00) : Colors.grey[500],
            ),
          ),
          Flexible(
            child: Text(
              textField ?? "[Unspecified Task]",
              style: TextStyle(
                color: isFinished ? Colors.grey[550] : Colors.grey[500],
                fontSize: 18,
                fontWeight: isFinished ? FontWeight.bold : FontWeight.w400,
              ),
            ),
          )
        ],
      ),
    );
  }
}
