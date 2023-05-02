import 'package:astarte/diseases_page.dart';
import 'package:flutter/material.dart';
import 'package:astarte/sidebar.dart';
import 'package:astarte/pests_page.dart';

class PestsAndDiseases extends StatefulWidget {
  const PestsAndDiseases({Key? key}) : super(key: key);

  @override
  State<PestsAndDiseases> createState() => _PestsAndDiseasesState();
}

class _PestsAndDiseasesState extends State<PestsAndDiseases> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AstarteAppBar(title: 'Pests and Diseases'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PestsPage()),
                  );
                },
                child: const Text('Pests'),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DiseasesPage()),
                  );
                },
                child: const Text('Diseases'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement button press functionality for "Upload Photo" button
            },
            child: const Text('Upload Photo'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement button press functionality for "Reach an Agronomist" button
        },
        child: const Icon(Icons.info),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniStartDocked,
      drawer: NavBar(context),
    );
  }
}
