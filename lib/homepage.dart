import 'package:flutter/material.dart';
import 'package:astarte/sidebar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('ASTARTE'),
        ),
        body: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/astarte.jpg',
                height: 200,
                width: 200,
              ),
              const Text(
                'Welcome to the ASTARTE!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Here you can track your farm, from planting and harvesting crops to taking care of pests. Explore our site to discover all the different ways you can get help in farming and make a difference in the world.',
                style: TextStyle(
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 100,),
              Padding(
                padding: const EdgeInsets.only(right: 100.0, left: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: (){}, icon:  const Icon(Icons.water_drop_rounded, size: 100,color:Colors.blueAccent)),
                    IconButton(onPressed: (){}, icon: const Icon(Icons.pest_control_rounded, size: 100, color: Colors.brown,)),
                  ],
                ),
              ),
            ],
          ),
        ),
        drawer: sideBar(context));
  }
}








