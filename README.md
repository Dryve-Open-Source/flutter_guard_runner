# Guard Runner

A guardian that protects against unauthorized access to routes and actions, as well as protects data viewing, based on the user's roles.


## Features

- Protect route against not authorized access
- Verify a permission to perform an action
- Show or hide an widget based on user's roles.

  
## Installation

Open project's `pubspec.yaml` and add `guard_runner` as a dependency

```yaml
dependencies:
  guard_runner: any
```
    
## Usage

### Setup roles, routes and isAdmin
First of all, it's need to call `GuardRunner.setup` to load all roles, routes and its respective roles.

```dart
import 'package:guard_runner/guard_runner.dart';
...
/// The all allowed roles
final List<String> roles = ['app_first_role', 'app_second_role', 'admin_role'];

/// The routes of app and it's respective roles
final rolesByRoutes = GuardRunnerRouteModelList([
        GuardRunnerRouteModel(routeName: '/', roles: ['*']),
        GuardRunnerRouteModel(
            routeName: '/second-page',
            roles: ['app_first_role', 'app_second_role']),
        GuardRunnerRouteModel(
            routeName: '/third-page', roles: ['app_third_role']),
        GuardRunnerRouteModel(routeName: '/unauthorized-page', roles: ['*'])
      ]);

GuardRunner.setup(
      roles: roles,
      rolesByRoutes: rolesByRoutes,
      isAdminRole: 'admin_role');
```

### Checking if a route has permission to navigate

Warning: It's an example, you can be adapt it to your needs.

```dart
import 'package:guard_runner/guard_runner.dart';
...
@override
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      onGenerateRoute: (settings) {
        final routeName = settings.name;

        final routes = {
          '/': MyHomePage(title: 'GuardRunner Home Page'),
          '/second-page': SecondPage(),
          '/third-page': ThirdPage(),
          '/unauthorized-page': UnauthorizedPage(),
        };

        if (routes.keys.contains(routeName)) {
          final hasPermission = GuardRunner.hasPermissionFromRoute(routeName!);

          return MaterialPageRoute(
            builder: (context) {
              final toRoute = hasPermission ? routeName : '/unauthorized-page';
              return routes[toRoute]!;
            },
          );
        }

        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
    );
  }
}
```
In this example, if has permission, then navigate to pushed route, if hasn't permission, then go to UnauthorizedPage.

### Verifying permission

To verify if user has permission to execute an action, you can use `GuardRunner.hasPermission` and/or `GuardRunner.hasPermissionFromRoute`

```dart
import 'package:guard_runner/guard_runner.dart';
...

if (GuardRunner.hasPermission(['app_first_role']) {
    doSomething();
} else {
    doNothing();
}

///
if (GuardRunner.hasPermissionFromRoute('/third-page')) {
    Navigator.of(context).pushNamed('/third-page');
} else {
    Navigator.of(context).pushNamed('/third-page');
}
...
```

### Using GuardRunnerVisibility to show or hide a widget.

GuardRunnerVisibility is a widget that show it's child if has permission and hide if hasn't permission, according to the roles passed as a parameter.
```dart
import 'package:guard_runner/guard_runner.dart';
...
GuardRunnerVisibility(
    child: Text('Showing because has permission...'),
    roles: ['app_first_role']),
```

### Passing a wildcard as parameter

If you wish a full access to a route or to show the child of GuardRunnerVisibility, you can pass a wildcard as a parameter.
```dart
import 'package:guard_runner/guard_runner.dart';
...

/// Example of using wildcard in a route
GuardRunnerRouteModel(routeName: '/', roles: ['*']),

/// Example of using wildcard with GuardRunnerVisibility
GuardRunnerVisibility(
    child: Text('Showing because has permission...'),
    roles: ['*']),
```

### Setup isAdmin
If you wish give a full access to a user, you can set `isAdminRole` property when call `GuardRunner.setup`.

isAdminRole is optional, **if defined and it's included in roles** list, then full access will be defined.

```dart
import 'package:guard_runner/guard_runner.dart';
...
/// The all allowed roles
final List<String> roles = ['app_first_role', 'app_second_role', 'admin_role'];

GuardRunner.setup(
      roles: roles,
      rolesByRoutes: rolesByRoutes,
      isAdminRole: 'admin_role');
```

  
## Example

See the full [example](/example)

  
## Authors

- [@Dryve-Open-Source](https://github.com/Dryve-Open-Source)

  
## License

[APACHE](https://choosealicense.com/licenses/apache-2.0/)

  