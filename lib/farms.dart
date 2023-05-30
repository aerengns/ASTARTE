import 'package:astarte/network_manager/models/farm_data.dart' as f;
import 'package:astarte/sidebar.dart';
import 'package:astarte/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'farm_detail.dart';
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
          Padding(padding: EdgeInsets.only(bottom: 20)),
          const DataList(),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/create_farm'),
            child: const Text('Add New Farm', style: TextStyle(fontSize: 20)),
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
          return Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      splashColor: CustomColors.astarteRed.withAlpha(30),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  FarmDetail(farmId: data[index].id)),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Center(
                            child: Image.asset(
                              'assets/images/farm.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  data[index].name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: CustomColors.astarteBlack,
                                  ),
                                ),
                                Row(
                                  children: const [
                                    Text(
                                      'Location',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: CustomColors.astarteBlack,
                                      ),
                                    ),
                                    Icon(Icons.location_pin),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
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
