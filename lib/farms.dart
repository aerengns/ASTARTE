import 'package:astarte/network_manager/models/sensor_data.dart';
import 'package:astarte/network_manager/services/sensor_data_service.dart';
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
              child: DataList(),
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
  List<FormData> data = [
    FormData("Astarte Farm", "09.12.2023", 0.7, 0.5, 0.2, 0.1),
    FormData("Next Farm", "10.12.2023", 0.3, 0.1, 0.6, 0.5),
  ];
  DataList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
        itemCount: data.length,
        prototypeItem: const ListTile(
          leading: Icon(Icons.newspaper),
          title: Text('Farm Name'),
          subtitle: Text('Date'),
        ),
        itemBuilder: (context, index) {
          return ListTile(
            // TODO: change with form data response
            leading: const Icon(Icons.newspaper),
            title: Text(data[index].farmName),
            subtitle: Text(data[index].date),
            onTap: () {
              Navigator.pushNamed(context, '/farm_data_form', arguments: data[index]);
            },
          );
        },
    );
  }
}

class FormData {
  String farmName;
  String date;
  double moisture;
  double phosphorus;
  double potassium;
  double nitrogen;

  FormData(this.farmName, this.date, this.moisture, this.phosphorus, this.potassium, this.nitrogen);
}
