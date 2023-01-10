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
      ),

      drawer: sideBar(context),
    );
  }
}

class DataList extends StatelessWidget {
  List<FormData> data = [
    FormData("Astarte Farm", "09.12.2023"),
    FormData("Astarte Farm", "07.12.2023"),
    FormData("Astarte Farm", "06.12.2023"),
    FormData("New Farm", "06.12.2023"),
    FormData("Astarte Farm", "03.12.2023"),
    FormData("New Farm", "01.12.2023"),
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
              // TODO: show data of the tapped form
              Navigator.pushNamed(context, '/farm_data_form');
            },
          );
        },
    );
  }
}

class FormData {
  String farmName;
  String date;

  FormData(this.farmName, this.date);
}
