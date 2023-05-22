import 'package:astarte/diseases_page.dart';
import 'package:astarte/pests_page.dart';
import 'package:astarte/sidebar.dart';
import 'package:astarte/theme/colors.dart';
import 'package:flutter/material.dart';

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
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PestsPage()),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/images/pests_logo.jpeg',
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: CustomColors.astarteBlue.withOpacity(0.54),
                          ),
                          child: const Center(
                            child: Text(
                              'Pests',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DiseasesPage()),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'assets/images/diseases_logo.avif',
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: CustomColors.astarteYellow.withOpacity(0.54),
                          ),
                          child: const Center(
                            child: Text(
                              'Diseases',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: (){
                Navigator.of(context).pushNamed('/create-post');
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const Icon(Icons.photo_camera_rounded, size: 300,),
                  Container(
                    decoration: BoxDecoration(
                      color: CustomColors.astarteLightBlue.withOpacity(0.54),
                    ),
                    child: const Center(
                      child: Text(
                        'Upload Photo',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/posts'),
        child: const Icon(Icons.info),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniStartDocked,
      drawer: NavBar(context),
    );
  }
}
