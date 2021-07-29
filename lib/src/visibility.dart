import 'package:flutter/material.dart';

import 'runner.dart';

class GuardRunnerVisibility extends StatelessWidget {
  final List<String> permissions;
  final Widget child;

  const GuardRunnerVisibility(
      {Key? key, required this.permissions, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: GuardRunner.hasPermission(permissions),
      child: child,
    );
  }
}
