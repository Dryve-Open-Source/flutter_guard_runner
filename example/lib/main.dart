import 'package:flutter/material.dart';
import 'package:guard_runner/guard_runner.dart';

void setup(isAdmin) {
  GuardRunner.setup(
      roles: ['app_first_role', 'app_second_role', 'admin_role'],
      rolesByRoutes: GuardRunnerRouteModelList([
        GuardRunnerRouteModel(routeName: '/', roles: ['*']),
        GuardRunnerRouteModel(
            routeName: '/second-page',
            roles: ['app_first_role', 'app_second_role']),
        GuardRunnerRouteModel(
            routeName: '/third-page', roles: ['app_third_role']),
        GuardRunnerRouteModel(routeName: '/unauthorized-page', roles: ['*'])
      ]),
      isAdminRole: isAdmin ? 'admin_role' : null);
}

void main() {
  setup(false);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GuardRunner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isAdmin = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('isAdmin: $_isAdmin'),
                Switch(
                    value: _isAdmin,
                    onChanged: (value) {
                      setState(() {
                        _isAdmin = value;
                      });
                      setup(value);
                    }),
              ],
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/second-page');
                },
                child: Text('Second Page')),
            // it will redirect to unauthorized (when isAdmin no redirect)
            TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/third-page');
                },
                child: Text('Third Page')),
            TextButton(
                onPressed: () {
                  if (GuardRunner.hasPermissionFromRoute('/third-page')) {
                    Navigator.of(context).pushNamed('/third-page');
                  } else {
                    Navigator.of(context).pushNamed('/third-page');
                  }
                },
                child: Text('Conditional navigation to Third')),

            GuardRunnerVisibility(
                child: Text('Showing because has permission...'),
                roles: ['app_first_role']),

            SizedBox(height: 12),

            GuardRunnerVisibility(
                child: Text('Showing because has permission...'), roles: []),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Second Page')),
      body: Center(child: Text('Second page here...')),
    );
  }
}

class ThirdPage extends StatelessWidget {
  const ThirdPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Third Page')),
      body: Center(child: Text('Third page here...')),
    );
  }
}

class UnauthorizedPage extends StatelessWidget {
  const UnauthorizedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Unauthorized access')),
      body: Center(child: Text('you do not access this page...')),
    );
  }
}
