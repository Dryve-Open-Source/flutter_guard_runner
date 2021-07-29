class GuardRunnerRouteModelList {
  final List<GuardRunnerRouteModel> routes;

  GuardRunnerRouteModelList(this.routes);
}

class GuardRunnerRouteModel {
  final String routeName;
  final List<String> roles;

  GuardRunnerRouteModel({
    required this.routeName,
    required this.roles,
  });
}
