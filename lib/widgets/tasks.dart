import 'package:flutter/material.dart';

class Tasks extends StatelessWidget {
  final String? title;
  final String? description;
  Tasks({this.title, this.description});

  //const Tasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 25,
        vertical: 30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? '[Task Unspecified]',
            style: TextStyle(
              color: Colors.grey[750],
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              description ?? 'Description is not specified',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 17,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          20,
        ),
      ),
    );
  }
}
