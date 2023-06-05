import 'package:flutter/material.dart';
import 'package:astarte/sidebar.dart';
import 'package:provider/provider.dart';
import 'package:astarte/utils/parameters.dart' as parameters;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<parameters.CurrentUser>(context);
    return Scaffold(
      appBar: const AstarteAppBar(title: 'ASTARTE'),
      body: Container(
        color: const Color.fromRGBO(237, 230, 231, 1),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16.0),
              Image.asset(
                'assets/icons/launcher_icon.png',
                height: 200,
                width: 200,
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Welcome to the ASTARTE!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32.0),
              if (currentUser.userType != 'Worker')
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/farms'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 16.0),
                    textStyle: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('Manage Farms'),
                ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/workers'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 16.0),
                  textStyle: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Manage Workers'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/posts'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32.0, vertical: 16.0),
                  textStyle: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Communicate'),
              ),
              // TODO: Add text about the product (i can take from the website)
            ],
          ),
        ),
      ),
      drawer: NavBar(context),
    );
  }
}
