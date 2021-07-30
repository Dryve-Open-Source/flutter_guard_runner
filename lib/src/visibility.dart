import 'package:flutter/material.dart';

import 'runner.dart';

class GuardRunnerVisibility extends StatelessWidget {
  /// A widget that show or hide its child according to [GuardRunner.hasPermission]
  final List<String> roles;
  final Widget child;

  const GuardRunnerVisibility(
      {Key? key, required this.roles, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: GuardRunner.hasPermission(roles),
      child: child,
    );
  }
}
