import 'package:collection/collection.dart';
import 'model.dart';

class GuardRunner {
  static final GuardRunner _instance = GuardRunner._internal();

  factory GuardRunner() {
    return _instance;
  }

  GuardRunner._internal();

  static final List<String> _wildcard = ['*'];

  static List<String> _roles = [];

  static GuardRunnerRouteModelList _rolesByRoutes =
      GuardRunnerRouteModelList([]);

  static bool _isAdmin = false;
  static String? _isAdminRole;

  static void setup(
      {required List<String> roles,
      required GuardRunnerRouteModelList rolesByRoutes,
      String? isAdminRole}) {
    _roles = roles;
    _rolesByRoutes = rolesByRoutes;
    _isAdminRole = isAdminRole;

    _isAdmin = _roles.isNotEmpty &&
        _isAdminRole != null &&
        _roles.contains(_isAdminRole);
  }

  static bool hasPermission(List<String> rolesToCheck) {
    try {
      if (_roles.isEmpty) {
        throw 'GuardRunner: _roles cannot be empty';
      }

      if (rolesToCheck.equals(_wildcard) || _isAdmin) {
        return true;
      }

      return rolesToCheck.any((element) => _roles.contains(element));
    } catch (_) {}
    return false;
  }

  static bool hasPermissionFromRoute(String routeName) {
    try {
      if (_rolesByRoutes.routes.isEmpty) {
        throw 'GuardRunner: _rolesByRoutes.routes cannot be empty';
      }

      final List<String> rolesToCheck = _rolesByRoutes.routes
              .firstWhereOrNull((e) => e.routeName == routeName)
              ?.roles ??
          [];

      return hasPermission(rolesToCheck);
    } catch (_) {}
    return false;
  }
}
