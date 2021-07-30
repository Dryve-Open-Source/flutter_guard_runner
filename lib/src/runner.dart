import 'package:collection/collection.dart';
import 'package:guard_runner/guard_runner.dart';
import 'model.dart';

class GuardRunner {
  /// GuardRunner is a singleton class that contains features to setup and control access permissions
  /// To work, it's need call [setup] before call [hasPermission] or [hasPermissionFromRoute]
  /// See [GuardRunnerVisibility] too, a widget that's show or hide his child according to access permissions

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

  /// Setup [_roles], [_rolesByRoutes] and [_isAdmin] fields.
  ///
  /// [roles] is a List of Strings that represents the roles to allow access.
  /// E.g roles => ['app_first_role'], ['app_second_role'].
  ///
  /// [rolesByRoutes] is the [GuardRunnerRouteModelList] that represents routes and its roles.
  /// E.g rolesByRoutes => GuardRunnerRouteModelList([
  ///   GuardRunnerRouteModel(routeName: 'first-route', roles: ['app_first_role'])
  /// ]).
  ///
  /// [isAdminRole] is a role that define's if an user is Admin. If pass it and roles contains it,
  /// then [_isAdmin] becomes true and [hasPermission] always return true.
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

  /// Returns if has permission according to the [_roles] contains any role in [rolesToCheck]
  ///
  /// if [rolesToCheck] is a wildcard '['*']' then returns true
  ///
  /// if [_isAdmin] is true, then returns true
  static bool hasPermission(List<String> rolesToCheck) {
    assert(_roles.isNotEmpty, 'GuardRunner: _roles cannot be empty');

    if (rolesToCheck.equals(_wildcard) || _isAdmin) {
      return true;
    }

    return rolesToCheck.any((element) => _roles.contains(element));
  }

  /// Returns if has permission to access certain route.
  ///
  /// if [routeName] is in [_rolesByRoutes] and its roles is included in [_roles],
  /// then returns true
  static bool hasPermissionFromRoute(String routeName) {
    assert(_rolesByRoutes.routes.isNotEmpty,
        'GuardRunner: _rolesByRoutes.routes cannot be empty');

    final List<String> rolesToCheck = _rolesByRoutes.routes
            .firstWhereOrNull((e) => e.routeName == routeName)
            ?.roles ??
        [];

    return hasPermission(rolesToCheck);
  }
}
