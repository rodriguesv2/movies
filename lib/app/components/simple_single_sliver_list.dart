import 'package:flutter/material.dart';

class SimpleSingleSliverList extends StatelessWidget {
  final List<Widget> children;

  const SimpleSingleSliverList({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        children,
      ),
    );
  }
}
