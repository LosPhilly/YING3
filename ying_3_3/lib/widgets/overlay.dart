import 'package:flutter/material.dart';

class SlideUpOverlayWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Description',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          GestureDetector(
            onTap: () {
              // Perform action when "Post Task" box is clicked
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.content_paste,
                    size: 24.0,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Post Task',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.0),
          GestureDetector(
            onTap: () {
              // Perform action when "Request Skill" box is clicked
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.green,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.content_paste,
                    size: 24.0,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Request Skill',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton.icon(
            onPressed: () {
              // Perform action when "Proceed" button is clicked
            },
            icon: Icon(Icons.arrow_forward),
            label: Text('Proceed'),
          ),
        ],
      ),
    );
  }
}
