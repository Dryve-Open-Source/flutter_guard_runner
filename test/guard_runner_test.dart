import 'package:flutter_test/flutter_test.dart';
import 'package:guard_runner/guard_runner.dart';

void main() {
  group('GuardRunner.hasPermission', () {
    test('thowsA AssertionError when routes is empty', () {
      expect(
          () => GuardRunner.hasPermission([]),
          throwsA(predicate((e) =>
              e is AssertionError &&
              e.message == 'GuardRunner: _roles cannot be empty')));
    });

    test('returns true when pass a rolesToCheck that contains in roles', () {
      GuardRunner.setup(
          roles: ['one', 'two'],
          rolesByRoutes: GuardRunnerRouteModelList([
            GuardRunnerRouteModel(routeName: 'first', roles: ['one', 'two'])
          ]));

      expect(GuardRunner.hasPermission(['one']), isTrue);
    });

    test('returns false when pass a rolesToCheck that not contains in roles',
        () {
      GuardRunner.setup(
          roles: ['one', 'two'],
          rolesByRoutes: GuardRunnerRouteModelList([
            GuardRunnerRouteModel(routeName: 'first', roles: ['one', 'two'])
          ]));

      expect(GuardRunner.hasPermission(['tree']), isFalse);
    });

    test('returns true when pass a wildcard in rolesToCheck', () {
      GuardRunner.setup(
          roles: ['one', 'two'],
          rolesByRoutes: GuardRunnerRouteModelList([
            GuardRunnerRouteModel(routeName: 'first', roles: ['one', 'two'])
          ]));

      expect(GuardRunner.hasPermission(['*']), isTrue);
    });

    test('returns false when pass a empty rolesToCheck', () {
      GuardRunner.setup(
          roles: ['one', 'two'],
          rolesByRoutes: GuardRunnerRouteModelList([
            GuardRunnerRouteModel(routeName: 'first', roles: ['one', 'two'])
          ]));

      expect(GuardRunner.hasPermission([]), isFalse);
    });

    test(
        'returns true when pass a isRoleAdmin to setup and isAdmin becomes true',
        () {
      GuardRunner.setup(
          roles: ['one', 'two'],
          rolesByRoutes: GuardRunnerRouteModelList([
            GuardRunnerRouteModel(routeName: 'first', roles: ['one', 'two'])
          ]),
          isAdminRole: 'one');

      expect(GuardRunner.hasPermission([]), isTrue);
    });

    test(
        'returns false when pass a isRoleAdmin to setup that not included in roles',
        () {
      GuardRunner.setup(
          roles: ['one', 'two'],
          rolesByRoutes: GuardRunnerRouteModelList([
            GuardRunnerRouteModel(routeName: 'first', roles: ['one', 'two'])
          ]),
          isAdminRole: 'tree');

      expect(GuardRunner.hasPermission([]), isFalse);
    });
  });

  group('GuardRunner.hasPermissionFrouRoute', () {
    test('thowsA AssertionError when _routesAndRoles is empty', () {
      GuardRunner.setup(
          roles: ['one', 'two'], rolesByRoutes: GuardRunnerRouteModelList([]));

      expect(
          () => GuardRunner.hasPermissionFromRoute(''),
          throwsA(predicate((e) =>
              e is AssertionError &&
              e.message ==
                  'GuardRunner: _rolesByRoutes.routes cannot be empty')));
    });

    test('returns true when pass a wildcard to route', () {
      GuardRunner.setup(
          roles: ['one', 'two'],
          rolesByRoutes: GuardRunnerRouteModelList([
            GuardRunnerRouteModel(routeName: 'first', roles: ['*'])
          ]));

      expect(GuardRunner.hasPermissionFromRoute('first'), isTrue);
    });

    test('returns true when pass a role to route that is included in roles',
        () {
      GuardRunner.setup(
          roles: ['one', 'two'],
          rolesByRoutes: GuardRunnerRouteModelList([
            GuardRunnerRouteModel(routeName: 'first', roles: ['one'])
          ]));

      expect(GuardRunner.hasPermissionFromRoute('first'), isTrue);
    });

    test(
        'returns false when pass a role to route that is not included in roles',
        () {
      GuardRunner.setup(
          roles: ['one', 'two'],
          rolesByRoutes: GuardRunnerRouteModelList([
            GuardRunnerRouteModel(routeName: 'first', roles: ['tree'])
          ]));

      expect(GuardRunner.hasPermissionFromRoute('first'), isFalse);
    });

    test('returns false when pass a empty roles to route', () {
      GuardRunner.setup(
          roles: ['one', 'two'],
          rolesByRoutes: GuardRunnerRouteModelList(
              [GuardRunnerRouteModel(routeName: 'first', roles: [])]));

      expect(GuardRunner.hasPermissionFromRoute('first'), isFalse);
    });

    test(
        'returns false when pass a routeName that is not included in rolesByRoutes',
        () {
      GuardRunner.setup(
          roles: ['one', 'two'],
          rolesByRoutes: GuardRunnerRouteModelList([
            GuardRunnerRouteModel(routeName: 'two', roles: ['one'])
          ]));

      expect(GuardRunner.hasPermissionFromRoute('first'), isFalse);
    });
  });
}
