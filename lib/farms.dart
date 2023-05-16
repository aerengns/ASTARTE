import 'package:astarte/network_manager/models/sensor_data.dart';
import 'package:astarte/network_manager/services/sensor_data_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:astarte/sidebar.dart';

import 'farm_data_form.dart';
import 'package:astarte/network_manager/models/farm_data.dart' as f;
import 'network_manager/services/farm_data_service.dart';

class Farms extends StatefulWidget {
  const Farms({Key? key}) : super(key: key);

  @override
  State<Farms> createState() => _FarmsState();
}

class _FarmsState extends State<Farms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AstarteAppBar(title: 'Farms'),
      body: Column(
        children: [
          Align (
            alignment: Alignment.center,
            child: Image.asset('assets/images/farm.jpg',
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.7,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.5,
              child: const DataList(),
            )
          ),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 50.0,
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            side: const BorderSide(color: Color.fromRGBO(211, 47, 47, 1))
                        )
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.all(12.0)
                    ),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor: MaterialStateProperty.all<Color>(const Color.fromRGBO(211, 47, 47, 1)),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/farm_detail');
                  },
                  child: const Text('Add New Data', style: TextStyle(fontSize: 20)),
                )
            ),
          ),
        ],
      ),
      drawer: NavBar(context),
    );
  }
}

class DataList extends StatelessWidget {
  const DataList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<f.FarmData>>(

      future: Provider.of<FarmDataService>(context, listen: false).getFarms().then((response) => response.body!.toList()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final data = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Card(
                  child:ListTile(
                      leading: const Icon(Icons.home),
                      title: Text(data[index].name),
                      onTap: () {
                        Navigator.pushNamed(context, '/farm_detail', arguments: data[index].id);
                  },
                )
              );
            },
          );
        }
      },
    );
  }
}


