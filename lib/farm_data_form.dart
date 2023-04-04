import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:astarte/network_manager/models/sensor_data.dart';
import 'package:flutter/material.dart';
import 'package:astarte/sidebar.dart';
import 'package:provider/provider.dart';
import 'package:astarte/farms.dart';

import 'network_manager/services/sensor_data_service.dart';

class FarmData extends StatelessWidget {
  const FarmData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formData = ModalRoute.of(context)?.settings.arguments as FormData?;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Data'),
        backgroundColor: const Color.fromRGBO(211, 47, 47, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ),
      body: FarmDataForm(formData: formData),
      drawer: NavBar(context),
    );
  }
}

class FarmDataForm extends StatefulWidget {
  final FormData? formData;

  const FarmDataForm({Key? key, this.formData}) : super(key: key);

  @override
  State<FarmDataForm> createState() => _FarmDataFormState();
}

class _FarmDataFormState extends State<FarmDataForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _dateController = TextEditingController(text: _date);

  late String _farmName;
  late String _date;
  late String _moisture;
  late String _phosphorus;
  late String _potassium;
  late String _nitrogen;

  @override
  void initState() {
    super.initState();
    _farmName = widget.formData?.farmName ?? '';
    _date = widget.formData?.date ?? '';
    _moisture = widget.formData?.moisture.toString() ?? '';
    _phosphorus = widget.formData?.phosphorus.toString() ?? '';
    _potassium = widget.formData?.potassium.toString() ?? '';
    _nitrogen = widget.formData?.nitrogen.toString() ?? '';
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color.fromRGBO(211, 47, 47, 1),
              onPrimary: Colors.white,
              surface:Color.fromRGBO(211, 47, 47, 1),
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final formatter = DateFormat('dd-MM-yyyy');
      setState(() {
        _date = formatter.format(picked);
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFormField(
                  enabled: widget.formData == null,
                  initialValue: _farmName,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Please enter a value';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _farmName = value;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    labelText: 'Farm Name',
                    hintText: 'Enter Farm Name',
                  ),
                ),
                TextFormField(
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _selectDate().then((value) {
                      _dateController.text = _date;
                    });
                  },
                  controller: _dateController,
                  enabled: widget.formData == null,
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Please enter a value';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _date = value;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    labelText: 'Date',
                    hintText: 'Enter Date',
                  ),
                ),
                TextFormField(
                  enabled: widget.formData == null,
                  initialValue: _moisture,
                  validator: (value) {
                    return _validateNumericalField(value);
                  },
                  onChanged: (value) {
                    _moisture = value;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    labelText: 'Moisture',
                  ),
                ),
                TextFormField(
                  enabled: widget.formData == null,
                  initialValue: _phosphorus,
                  validator: (value) {
                    return _validateNumericalField(value);
                  },
                  onChanged: (value) {
                    _phosphorus = value;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    labelText: 'Phosphorus',
                  ),
                ),
                TextFormField(
                  enabled: widget.formData == null,
                  initialValue: _potassium,
                  validator: (value) {
                    return _validateNumericalField(value);
                  },
                  onChanged: (value) {
                    _potassium = value;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    labelText: 'Potassium',
                  ),
                ),
                TextFormField(
                  enabled: widget.formData == null,
                  initialValue: _nitrogen,
                  validator: (value) {
                    return _validateNumericalField(value);
                  },
                  onChanged: (value) {
                    _nitrogen = value;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    labelText: 'Nitrogen',
                  ),
                ),
                Visibility(
                  visible: widget.formData == null,
                  child: Padding(
                  padding: const EdgeInsets.all(30.0),
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
                    onPressed: () async {
                      if (_formKey.currentState?.validate() != true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in all fields'),
                          ),
                        );
                      }
                      Position _position = await _getUserLocation();
                      final response = await Provider.of<SensorDataService>(context, listen: false).saveSensorData(
                          SensorData(
                                  (b) => b
                                    ..farmName = _farmName
                                    ..formDate = _date
                                    ..moisture = double.parse(_moisture)
                                    ..phosphorus = double.parse(_phosphorus)
                                    ..potassium = double.parse(_potassium)
                                    ..nitrogen = double.parse(_nitrogen)
                                    ..latitude = _position.latitude
                                    ..longitude = _position.longitude
                          ));
                      if (response.isSuccessful) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Data Saved Successfully'),
                          ),
                        );
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Your data was not saved. Please try again.'),
                          ),
                        );
                      }
                    },
                    child: const Text('Submit Data', style: TextStyle(fontSize: 16)),
                  ),
                ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

String? _validateNumericalField(String? value) {
  if (value?.isEmpty == true) {
    return 'Please enter a value';
  } else if (double.tryParse(value!) == null) {
    return 'Please enter a valid number';
  }
  return null;
}
