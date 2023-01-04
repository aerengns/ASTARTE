import 'package:flutter/material.dart';
import 'package:astarte/sidebar.dart';

class Farms extends StatefulWidget {
  const Farms({Key? key}) : super(key: key);

  @override
  State<Farms> createState() => _FarmsState();
}

class _FarmsState extends State<Farms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farms'),
      ),
      body: Container(
        child: Column(
          children: [
            Align (
              alignment: Alignment.center,
              child: Image.asset('assets/images/farm.jpg',
                height: 250,
                width: 300,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                  width: 300.0,
                  height: 50.0,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: const BorderSide(color: Colors.red)
                          )
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.all(12.0)
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/farm_data_form');
                    },
                    child: Text('Add New Data', style: TextStyle(fontSize: 20)),
                  )
              ),
            ),
          ],
        ),
      ),
      drawer: sideBar(context),
    );
  }
}