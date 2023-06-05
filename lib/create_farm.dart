import 'package:astarte/network_manager/services/farm_data_service.dart';
import 'package:astarte/sidebar.dart';
import 'package:astarte/theme/colors.dart';
import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'farm_detail.dart';
import 'network_manager/models/farm.dart';

class CreateFarm extends StatelessWidget {
  const CreateFarm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Create FARM'),
          backgroundColor: CustomColors.astarteRed,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: CreateFarmForm(),
      drawer: NavBar(context),
    );
  }
}

class CreateFarmForm extends StatefulWidget {
  const CreateFarmForm({Key? key}) : super(key: key);

  @override
  _CreateFarmFormState createState() => _CreateFarmFormState();
}

class _CreateFarmFormState extends State<CreateFarmForm> {
  final _formKey = GlobalKey<FormState>();
  final _farmNameController = TextEditingController();
  List<CornerPoint> _points = [];

  @override
  void dispose() {
    _farmNameController.dispose();
    //for (var controller in _pointControllers) {
    //  controller.dispose();
    //}
    super.dispose();
  }

  void _addNewPoint() async {
    Position _position = await _getUserLocation();
    setState(() {
      _points.add(CornerPoint((b) => b
        ..latitude = _position.latitude
        ..longitude = _position.longitude));
    });
  }

  void _removePoint(int index) {
    setState(() {
      _points.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _farmNameController,
                decoration: const InputDecoration(labelText: 'Farm Name'),
                validator: (value) {
                  if (value?.trim().isEmpty ?? false) {
                    return 'Please enter the farm name';
                  }
                  return null;
                },
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _points.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          initialValue:
                              'Lat: ${_points[index].latitude}, Lon: ${_points[index].longitude}',
                          decoration: const InputDecoration(labelText: 'Point'),
                          readOnly: true,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _removePoint(index),
                      )
                    ],
                  );
                },
              ),
              if (_points.length < 7)
                ElevatedButton(
                  onPressed: _addNewPoint,
                  child: const Text('Add New Point'),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate() && _points.length >= 3) {
            final response =
                await Provider.of<FarmDataService>(context, listen: false)
                    .createFarm(Farm((b) => b
                      ..name = _farmNameController.text
                      ..cornerPoints = ListBuilder<CornerPoint>(_points)));

            if (response.isSuccessful) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Data Saved Successfully'),
                ),
              );
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FarmDetail(farmId: response.body['farm_id'])),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Your data was not saved. Please try again.'),
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("You must have at least 3 points."),
              ),
            );
          }
        },
        tooltip: 'Save',
        child: const Icon(Icons.save),
      ),
    );
  }

  Future<Position> _getUserLocation() async {
    bool locationServiceEnabled;
    LocationPermission permission;

    locationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!locationServiceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
