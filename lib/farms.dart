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
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/farm.jpg',
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
              )),
          Align(
            alignment: Alignment.center,
            child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/farm_detail');
                  },
                  child: const Text('Add New Data',
                      style: TextStyle(fontSize: 20)),
                )),
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
      future: Provider.of<FarmDataService>(context, listen: false)
          .getFarms()
          .then((response) => response.body!.toList()),
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
              return ListTile(
                leading: const Icon(Icons.home),
                title: Text(data[index].name),
                onTap: () {
                  Navigator.pushNamed(context, '/farm_detail',
                      arguments: data[index].id);
                  },
                );
            },
          );
        }
      },
    );
  }
}

class FormData {
  String farmName;
  String date;
  double parcelNo;
  double temperature;
  double moisture;
  double phosphorus;
  double potassium;
  double nitrogen;
  double ph;

  FormData(
      this.farmName,
      this.date,
      this.moisture,
      this.parcelNo,
      this.temperature,
      this.phosphorus,
      this.potassium,
      this.nitrogen,
      this.ph);
}
