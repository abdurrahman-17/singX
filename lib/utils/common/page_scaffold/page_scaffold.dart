import 'package:flutter/material.dart';
import 'package:singx/utils/common/app_widgets.dart';

class PageScaffold extends StatelessWidget {
  const PageScaffold({
    Key? key,
    required this.title,
    this.actions = const [],
    this.body,
    this.floatingActionButton,
    this.color,
    this.newBottomNav,
    this.scrollController,
    this.appbar,
  }) : super(key: key);
  final String title;
  final Color? color;
  final List<Widget> actions;
  final Widget? body;
  final Widget? floatingActionButton;
  final Widget? newBottomNav;
  final ScrollController? scrollController;
  final appbar;

  @override
  Widget build(BuildContext context) {
    return AppInActiveCheck(
      context: context,
      child: Scrollbar(
        controller: scrollController,
        child: Scaffold(
          appBar: appbar,
          body: body,
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: newBottomNav,
        ),
      ),
    );
  }
}
