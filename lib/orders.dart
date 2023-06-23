import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  final String uid;

  const Orders({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
