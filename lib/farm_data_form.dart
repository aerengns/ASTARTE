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
        backgroundColor: Colors.red,
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
                  enabled: widget.formData == null,
                  initialValue: _date,
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
                              side: const BorderSide(color: Colors.red)
                          )
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          const EdgeInsets.all(12.0)
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState?.validate() != true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill in all fields'),
                          ),
                        );
                      }
                      final response = await Provider.of<SensorDataService>(context, listen: false).saveSensorData(
                          SensorData(
                                  (b) => b
                                ..farmName = _farmName
                                ..formDate = _date
                                ..moisture = double.parse(_moisture)
                                ..phosphorus = double.parse(_phosphorus)
                                ..potassium = double.parse(_potassium)
                                ..nitrogen = double.parse(_nitrogen)
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
