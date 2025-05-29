import 'package:flutter/material.dart';

class ToolSignalCard extends StatelessWidget {
  late final String title;
  late final IconData icon;
  late final VoidCallback onTap;

  ToolSignalCard(
      {required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          size: 40.0,
          color: Colors.amber,
        ),
        title: Text(
          title,
          style: TextStyle(
              fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        trailing: IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: onTap,
        ),
      ),
    );
  }
}
