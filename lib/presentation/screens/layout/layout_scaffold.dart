import 'package:flutter/material.dart';

class LayoutScaffold extends StatelessWidget {

  final Widget widget ;
  const LayoutScaffold({super.key , required this.widget});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: widget,
    );
  }
}