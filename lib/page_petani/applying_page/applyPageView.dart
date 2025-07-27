import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: applyPageView(),
  ));
}

class applyPageView extends StatelessWidget {
  const applyPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply Page'),
      ),
      body: Center(
        child: Text('This is the apply page view.'),
      ),
    );
  }
}
