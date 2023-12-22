import 'package:baseoo/expand/extension.dart';
import 'package:baseoo/ui/title_common_view.dart';
import 'package:flutter/material.dart';

abstract class BaseBodyView extends StatelessWidget {
  const BaseBodyView({required this.child, this.title, super.key});

  final Widget child;

  final String? title;

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];

    if (title.notEmpty) {
      list.add(TitleCommonView(title!));
    }

    list.add(child);

    return Scaffold(
      body: list.length > 1 ? Column(children: list) : list[0]
    );
  }
}
