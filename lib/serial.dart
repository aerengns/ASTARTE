import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:usb_serial/usb_serial.dart';

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soil Sensor Reader',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  UsbPort? _port;
  StreamSubscription<Uint8List>? _subscription;
  double _sensorValue = 0.0;
  double _humidityValue = 0.0;
  double _temperatureValue = 0.0;
  double _phValue = 0.0;
  double _nValue = 0.0;
  double _pValue = 0.0;
  double _kValue = 0.0;

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

  void connectToUSBDevice() async {
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
      double value = parseData(data);
      setState(() {
        _sensorValue = value;
      });
      _humidityValue = _parseRegisterValue(data, 3) / 10;
      _temperatureValue = s16(_parseRegisterValue(data, 5)) / 10.0;
      _phValue = _parseRegisterValue(data, 9) / 10.0;
      _nValue = _parseRealValue(data, 11);
      _pValue = _parseRealValue(data, 13);
      _kValue = _parseRealValue(data, 15);
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Soil Sensor Reader'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Humidity Value: $_humidityValue',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Temperature Value: $_temperatureValue',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'PH Value: $_phValue',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Nitrogen Value: $_nValue',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Phosphorus Value: $_pValue',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Potassium Value: $_kValue',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Value: $_sensorValue',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
