// REFERENCE:
// https://hgic.clemson.edu/factsheet/tomato-diseases-disorders/

import 'package:flutter/material.dart';
import 'package:astarte/sidebar.dart';

class DiseasesPage extends StatelessWidget {
  const DiseasesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AstarteAppBar(title: 'Diseases'),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: const <Widget>[
          DiseaseCard(
            image: AssetImage('assets/images/diseases/bacterial-wilt.jpg'),
            name: 'Bacterial Wilt',
            nextPage: DiseaseInfoPage(
              name: 'Bacterial Wilt',
              path: 'assets/images/diseases/bacterial-wilt.jpg',
              information:
                  "Bacterial wilt or Southern bacterial blight is a serious disease caused by Ralstonia solanacearum (formerly Pseudomonas solanacearum). This bacterium survives in the soil for extended periods and enters the roots through wounds made by transplanting, cultivation, insect feeding damage, and natural wounds where secondary roots emerge.\n\nDisease development is favored by high temperatures and high moisture. The bacteria multiply rapidly inside the water-conducting tissue of the plant, filling it with slime. This results in rapid wilt of the plant while the leaves stay green. If an infected stem is cut crosswise, it will look brown and tiny drops of yellowish ooze may be visible.",
              prevention_treatment:
                  "Control of bacterial wilt of plants grown in infested soil is difficult. Rotation with non-susceptible plants, such as corn, beans, and cabbage, for at least three years provides some control. Do not use pepper, eggplant, potato, sunflower, or cosmos in this rotation. Remove and destroy all infected plant material. Plant only certified disease-free plants. The cultivar Kewalo is partially resistant to bacterial wilt but is an uncommon cultivar. Chemical control is not available for this disease.\n\nConsider growing all susceptible solanaceous plants (tomatoes, peppers, eggplants, and Irish potatoes) in a separate newly prepared garden site, completely separate from the original garden. Be sure to thoroughly hose off all soil from tiller tines and tools used in the original infested site before use in the new garden site.\n\nRecently, several bacterial wilt resistant rootstocks for grafted tomatoes, peppers, and eggplants have been tested and found to have a high level of resistance. Grafted plants may be available.",
            ),
          ),
          DiseaseCard(
            image: AssetImage('assets/images/diseases/early-blight.jpg'),
            name: 'Early Blight',
            nextPage: DiseaseInfoPage(
              name: 'Early Blight',
              path: 'assets/images/diseases/early-blight.jpg',
              information:
                  "This disease is caused by the fungi Alternaria linariae (formally known as A. solani) and is first observed on the plants as small, brown lesions mostly on the older foliage. Spots enlarge and concentric rings in a bull’s-eye pattern may be seen in the center of the diseased area. The tissue surrounding the spots may turn yellow. If high temperature and humidity occur at this time, much of the foliage is killed. Lesions on the stems are similar to those on leaves and sometimes girdle the plant if they occur near the soil line (collar rot). On the fruits, lesions attain considerable size, usually involving nearly the entire fruit. Concentric rings are also present on the fruit. Infected fruit frequently drops.\n\nThe fungus survives on infected debris in the soil, on seed, on volunteer tomato plants, and other solanaceous hosts, such as Irish potato, eggplant, and black nightshade (a common, related weed).",
              prevention_treatment:
                  "Use resistant or tolerant tomato cultivars. Use pathogen-free seed and do not set diseased plants in the field. Use crop rotation, eradicate weeds and volunteer tomato plants, space plants to not touch, mulch plants, fertilize properly, don’t wet tomato foliage with irrigation water, and keep the plants growing vigorously. Trim off and dispose of infected lower branches and leaves.\n\nTo reduce disease severity, test the garden soil annually and maintain a sufficient level of potassium. Lime the soil according to soil test results. Side dress tomato plants monthly with calcium nitrate for adequate growth.\n\nIf the disease is severe enough to warrant chemical control, select one of the following fungicides: mancozeb (very good); chlorothalonil or copper fungicides (good). Follow the directions on the label. See Table 1 for examples of fungicide products for home garden use. See Table 2 for tomato cultivars with resistance or tolerance to early blight.",
            ),
          ),
          DiseaseCard(
            image: AssetImage('assets/images/diseases/late-blight.jpg'),
            name: 'Late Blight',
            nextPage: DiseaseInfoPage(
              name: 'Late Blight',
              path: 'assets/images/diseases/late-blight.jpg',
              information:
                  "Late blight is a potentially serious disease of potato and tomato and is caused by the water mold pathogen Phytophthora infestans. Late blight is especially damaging during cool, wet weather. This pathogen can affect all plant parts. Young leaf lesions are small and appear as dark, water-soaked spots. These leaf spots will quickly enlarge, and a white mold will appear at the margins of the affected area on the lower surface of leaves. Complete defoliation (browning and shriveling of leaves and stems) can occur within 14 days from the first symptoms. Infected tomato fruits develop shiny, dark, or olive-colored lesions, which may cover large areas. Fungal spores are spread between plants and gardens by rain and wind. A combination of daytime temperatures in the upper 70s °F with high humidity is ideal for infection.",
              prevention_treatment:
                  "The following guidelines should be followed to minimize late blight problems:\nKeep foliage dry. Locate your garden where it will receive morning sun.\n• Allow extra room between the plants, and avoid overhead watering, especially late in the day.\n• Purchase certified disease-free seeds and plants.\n• Destroy volunteer tomato and potato plants, as well as nightshade family weeds, such as Carolina horsenettle or black nightshade, which may harbor the fungus.\n• Do not compost rotten, store-bought potatoes.\n• Pull out and destroy diseased plants.\n• If the disease is severe enough to warrant chemical control, select one of the following fungicides: chlorothalonil (very good), copper fungicide, or mancozeb (good). See Table 1 for examples of fungicide products for home garden use. Follow the directions on the label.\n• Plant resistant cultivars.",
            ),
          ),
          DiseaseCard(
            image: AssetImage('assets/images/diseases/septoria-leaf-spot.jpg'),
            name: 'Septoria Leaf Spot',
            nextPage: DiseaseInfoPage(
              name: 'Septoria Leaf Spot',
              path: 'assets/images/diseases/septoria-leaf-spot.jpg',
              information:
                  "This destructive disease of tomato foliage, petioles, and stems (fruit is not infected) is caused by the fungus Septoria lycopersici. Infection usually occurs on the lower leaves near the ground, after plants begin to set fruit. Numerous small, circular spots with dark borders surrounding a beige-colored center appear on the older leaves. Tiny black specks, which are spore-producing bodies, can be seen in the center of the spots. Severely spotted leaves turn yellow, die, and fall off the plant. The fungus is most active when temperatures range from 68 to 77° F, the humidity is high, and rainfall or overhead irrigation wets the plants. Defoliation weakens the plant, reduces the size and quality of the fruit, and exposes the fruit to sunscald (see below). The fungus is not soil-borne but can overwinter on crop residue from previous crops, decaying vegetation, and on some weeds related to tomato.",
              prevention_treatment:
                  "Most currently grown tomato cultivars are susceptible to Septoria leaf spot. Crop rotation of 3 years and sanitation (removal of crop debris) will reduce the amount of inoculum. Do not use overhead irrigation. Repeated fungicide applications with chlorothalonil (very good) or copper fungicide, or mancozeb (good) will keep the disease in check. See Table 1 for examples of fungicide products for home garden use.",
            ),
          ),
          DiseaseCard(
            image: AssetImage('assets/images/diseases/leaf-mold.jpg'),
            name: 'Leaf Mold',
            nextPage: DiseaseInfoPage(
              name: 'Leaf Mold',
              path: 'assets/images/diseases/leaf-mold.jpg',
              information:
                  "The fungus Passalora fulva causes leaf mold. It is first observed on older leaves near the soil where air movement is poor and humidity is high. The initial symptoms are pale green or yellowish spots on the upper leaf surface, which enlarge and turn a distinctive yellow.\n\nUnder humid conditions, the spots on the lower leaf surfaces become covered with a gray, velvety growth of the spores produced by the fungus. When infection is severe, the spots coalesce, and the foliage is killed. Occasionally, the fungus attacks stems, blossoms and fruits. Green and mature fruit can have a black, leathery rot on the stem end.\n\nThe fungus survives on crop residue and in the soil. Spores are spread by rain, wind, or tools. Seeds can be contaminated. The fungus is dependent on high relative humidity and high temperature for disease development.",
              prevention_treatment:
                  "Crop residue should be removed from the field. Staking and pruning to increase air circulation helps to control the disease. Space tomato plants further apart for better air circulation between plants. Avoid wetting leaves when watering. Rotate with vegetables other than tomatoes. Using a preventative fungicide program with chlorothalonil, mancozeb, or copper fungicide, can control the disease. See Table 1 for fungicide products for home garden use.",
            ),
          ),
          DiseaseCard(
            image: AssetImage('assets/images/diseases/bacterial-spot.jpg'),
            name: 'Bacterial Spot',
            nextPage: DiseaseInfoPage(
              name: 'Bacterial Spot',
              path: 'assets/images/diseases/bacterial-spot.jpg',
              information:
                  "This disease is caused by several species of the bacterium Xanthomonas (but primarily by Xanthomonas perforans), which infect green but not red tomatoes. Peppers are also infected. The disease is more prevalent during wet seasons. Damage to the plants includes leaf and fruit spots, which result in reduced yields, defoliation, and sunscalded fruit. The symptoms consist of numerous small, angular to irregular, water-soaked spots on the leaves and slightly raised to scabby spots on the fruits. The leaf spots may have a yellow halo. The centers dry out and frequently tear.\n\nThe bacteria survive the winter on volunteer tomato plants and on infected plant debris. Moist weather is conducive to disease development. Most outbreaks of the disease can be traced back to heavy rainstorms that occurred in the area. Infection of leaves occurs through natural openings. Infection of fruits must occur through insect punctures or other mechanical injuries.\n\nBacterial spot is difficult to control once it appears in the field. Any water movement from one leaf or plant to another, such as splashing raindrops, overhead irrigation, and touching or handling wet plants, may spread the bacteria from diseased to healthy plants.",
              prevention_treatment:
                  "Only use certified disease-free seeds and plants. Avoid areas that were planted with peppers or tomatoes during the previous year. Avoid overhead watering by using drip or furrow irrigation. Remove and dispose of all diseased plant material. Prune plants to promote air circulation. Spraying with a copper fungicide will give fairly good control of the bacterial disease. Follow the instructions on the label. See Table 1 for fungicide products for home garden use.",
            ),
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
    );
  }
}

class DiseaseCard extends StatelessWidget {
  final ImageProvider image;
  final String name;
  final Widget nextPage;

  const DiseaseCard({
    Key? key,
    required this.image,
    required this.name,
    required this.nextPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image(
                image: image,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                name,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DiseaseInfoPage extends StatelessWidget {
  final String name;
  final String path;
  final String information;
  final String prevention_treatment;

  const DiseaseInfoPage({
    Key? key,
    required this.name,
    required this.path,
    required this.information,
    required this.prevention_treatment,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AstarteAppBar(title: '$name Information'),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 16),
            Image.asset(
              path,
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
              child: Text(
                name,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Text(
                information,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 15, 20, 5),
              child: Text(
                'Prevention & Treatment:',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Text(
                prevention_treatment,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
