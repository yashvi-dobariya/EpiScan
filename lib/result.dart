import 'package:flutter/material.dart';

class showResult extends StatefulWidget {
  final String result;
  final String accuracy;
  const showResult({super.key, required this.result, required this.accuracy});

  @override
  State<showResult> createState() => _showResultState();
}

class _showResultState extends State<showResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
               widget.result
            ),
            SizedBox(),
            Text(
                widget.accuracy
            ),
          ],
        ),
      ),

    );
  }
}
