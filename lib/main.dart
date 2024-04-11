import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart';
import 'splashscreen.dart';
import 'package:path/path.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define a lighter color palette
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.lightBlue,
          secondary: Colors.lightGreen,
          background: Colors.white,
          surface: Colors.grey[200],
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onBackground: Colors.black,
          onSurface: Colors.black,
          brightness: Brightness.light,
        ),
        // Set other theme properties to match the lighter palette
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.lightBlue,
          foregroundColor: Colors.white,
        ),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.black),
          bodyText2: TextStyle(color: Colors.black),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue, // Button background color
            foregroundColor: Colors.white, // Button text color
          ),
        ),
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
              labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          SizedBox(height: 10),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            obscureText: true,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              bool isAuthenticated = await authenticateUser(
                _usernameController.text,
                _passwordController.text,
              );
              if (isAuthenticated) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SplashScreen()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Invalid username or password')),
                );
              }
            },
            child: Text('Login'),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignupPage()),
              );
            },
            child: Text('Create an account'),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// Rest of your code remains unchanged



class SignupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SignupForm(),
    );
  }
}
class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}
class _SignupFormState extends State<SignupForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: 'Username'),
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(labelText: 'Phone Number'),
          ),
          TextField(
            controller: _confirmController,
            decoration: InputDecoration(labelText: 'Confirm Password'),
            obscureText: true,
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () async {
              await saveUser(
                  _usernameController.text, _passwordController.text);
              Navigator.pop(context);
            },
            child: Text('Sign Up'),
          ),
        ],
      ),
    );
  }
}
class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Center(
        child: Text('Welcome!'),
      ),
    );
  }
}
Future<Database> openDB() async {
  return databaseFactoryWeb.openDatabase('user_database.db');
}
Future<void> saveUser(String username, String password) async {
  final Database db = await openDB();
  final store = intMapStoreFactory.store('users');
  await store.add(db, {'username': username, 'password': password});
}
Future<bool> authenticateUser(String username, String password) async {
  final Database db = await openDB();
  final store = intMapStoreFactory.store('users');
  final finder = Finder(filter: Filter.and([
    Filter.equals('username', username),
    Filter.equals('password', password),
  ]));
  final recordSnapshots = await store.find(db, finder: finder);
  return recordSnapshots.isNotEmpty;
}