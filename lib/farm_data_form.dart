import 'package:astarte/theme/colors.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:astarte/network_manager/models/sensor_data.dart';
import 'package:flutter/material.dart';
import 'package:astarte/sidebar.dart';
import 'package:provider/provider.dart';
import 'package:astarte/farm_sensor_data.dart';
import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';
import 'package:usb_serial/usb_serial.dart';

import 'network_manager/services/sensor_data_service.dart';

class FarmData extends StatelessWidget {
  FarmData({Key? key, required this.farmId}) : super(key: key);

  int farmId;

  @override
  Widget build(BuildContext context) {
    final formData = ModalRoute.of(context)?.settings.arguments as FormData?;
    return Scaffold(
      appBar: AppBar(
          title: const Text('Farm Data'),
          backgroundColor: CustomColors.astarteRed,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: FarmDataForm(farmId: farmId),
      drawer: NavBar(context),
    );
  }
}

class FarmDataForm extends StatefulWidget {
  int? farmId;

  FarmDataForm({Key? key, this.farmId}) : super(key: key);

  @override
  State<FarmDataForm> createState() => _FarmDataFormState();
}

class _FarmDataFormState extends State<FarmDataForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _dateController =
      TextEditingController(text: "");
  late TextEditingController _temperatureController =
      TextEditingController(text: "");
  late TextEditingController _moistureController =
      TextEditingController(text: "");
  late TextEditingController _phController = TextEditingController(text: "");
  late TextEditingController _phosphorusController =
      TextEditingController(text: "");
  late TextEditingController _potassiumController =
      TextEditingController(text: "");
  late TextEditingController _nitrogenController =
      TextEditingController(text: "");

  UsbPort? _port;
  StreamSubscription<Uint8List>? _subscription;
  late String _date;
  String _temperature = "";
  String _moisture = "";
  String _phosphorus = "";
  String _potassium = "";
  String _nitrogen = "";
  String _ph = "";

  @override
  void initState() {
    super.initState();
    connectToUSBDevice();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _port?.close();
    super.dispose();
  }

  Future<void> connectToUSBDevice() async {
    List<UsbDevice> devices = await UsbSerial.listDevices();
    if (devices.isEmpty) {
      // No USB device found
      return;
    }

    UsbDevice device = devices[0];

    _port = await device.create();
    _port?.open();
    _port?.setPortParameters(
        4800, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

    // Send command to request data from register
    Uint8List command = Uint8List.fromList([
      0x01, // Address
      0x03, // Function Code
      0x00, // Start Address (Hi)
      0x00, // Start Address (Lo)
      0x00, // Number of Points (Hi)
      0x07, // Number of Registers (Lo)
      0x04, // Error Check (Lo)
      0x08, // Error Check (Hi)
    ]);

    _port?.write(command);

    _subscription = _port!.inputStream!.listen((Uint8List data) {
      setState(() {
        _moisture = (_parseRegisterValue(data, 3) / 10).toString();
        _moistureController = TextEditingController(text: _moisture);
        _temperature = (s16(_parseRegisterValue(data, 5)) / 10.0).toString();
        _temperatureController = TextEditingController(text: _temperature);
        _ph = (_parseRegisterValue(data, 9) / 10.0).toString();
        _phController = TextEditingController(text: _ph);
        _nitrogen = (_parseRealValue(data, 11)).toString();
        _nitrogenController = TextEditingController(text: _nitrogen);
        _phosphorus = (_parseRealValue(data, 13)).toString();
        _phosphorusController = TextEditingController(text: _phosphorus);
        _potassium = (_parseRealValue(data, 15)).toString();
        _potassiumController = TextEditingController(text: _potassium);
      });
    });
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
              primary: CustomColors.astarteRed,
              onPrimary: Colors.white,
              surface: CustomColors.astarteRed,
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
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    _selectDate().then((value) {
                      _dateController.text = _date;
                    });
                  },
                  controller: _dateController,
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
                  //initialValue: _temperature,
                  controller: _temperatureController,
                  validator: (value) {
                    return _validateNumericalField(value);
                  },
                  onChanged: (value) {
                    _temperature = value;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    labelText: 'Temperature',
                  ),
                ),
                TextFormField(
                  //initialValue: _moisture,
                  controller: _moistureController,
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
                  //initialValue: _phosphorus,
                  controller: _phosphorusController,
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
                  //initialValue: _potassium,
                  controller: _potassiumController,
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
                  //initialValue: _nitrogen,
                  controller: _nitrogenController,
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
                TextFormField(
                  //initialValue: _ph,
                  controller: _phController,
                  validator: (value) {
                    return _validateNumericalField(value);
                  },
                  onChanged: (value) {
                    _ph = value;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    labelText: 'PH',
                  ),
                ),
                Visibility(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    side: const BorderSide(
                                        color:
                                            Color.fromRGBO(211, 47, 47, 1)))),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.all(12.0)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromRGBO(211, 47, 47, 1)),
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
                        final response = await Provider.of<SensorDataService>(
                                context,
                                listen: false)
                            .saveSensorData(
                                SensorData((b) => b
                                  ..formDate = _date
                                  ..temperature = double.parse(_temperature)
                                  ..moisture = double.parse(_moisture)
                                  ..phosphorus = double.parse(_phosphorus)
                                  ..potassium = double.parse(_potassium)
                                  ..nitrogen = double.parse(_nitrogen)
                                  ..ph = double.parse(_ph)
                                  ..latitude = _position.latitude
                                  ..longitude = _position.longitude),
                                widget.farmId as int);
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
                              content: Text(
                                  'Your data was not saved. Please try again.'),
                            ),
                          );
                        }
                      },
                      child: const Text('Submit Data',
                          style: TextStyle(fontSize: 16)),
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

double parseData(Uint8List data) {
  ByteData byteData = ByteData.view(data.buffer);
  double value = byteData.getFloat32(0, Endian.little);
  return value;
}

int _parseRegisterValue(Uint8List data, int startIndex) {
  int valueHi = data[startIndex];
  int valueLo = data[startIndex + 1];
  return (valueHi << 8 | valueLo);
}

double _parseRealValue(Uint8List data, int startIndex) {
  int valueHi = data[startIndex];
  int valueLo = data[startIndex + 1];
  Uint8List valueBytes = Uint8List.fromList([valueHi, valueLo]);
  ByteData byteData = ByteData.view(valueBytes.buffer);
  int value = byteData.getUint16(0, Endian.big);
  return value.toDouble();
}

int s16(int value) {
  const int mask = 0xFFFF; // Mask for 16 bits
  if (value & (1 << 15) != 0) {
    // Check if the most significant bit is set
    return -(value & mask) | (~mask); // Apply two's complement
  } else {
    return value & mask; // Positive value, no need for conversion
  }
}
