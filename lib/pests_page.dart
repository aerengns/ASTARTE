// REFERENCE:
// https://minnetonkaorchards.com/tomato-pests/

import 'package:flutter/material.dart';
import 'package:astarte/sidebar.dart';

class PestsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AstarteAppBar(title: 'Pests'),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: const <Widget>[
          PestCard(
            image: AssetImage('assets/images/pests/aphids.jpg'),
            name: 'Aphids',
            nextPage: PestInfoPage(
              name: 'Aphids',
              path: 'assets/images/pests/aphids.jpg',
              information:
                  'These pear-shaped, sap-sucking bugs—in particular, blackflies and greenflies—are known to affect a host of fruits and vegetables, including tomatoes. While a couple of aphids are somewhat harmless, these tomato pests find their strength in numbers. Large quantities will suck the nutrients from plant stems and bring tomato growth to a halt!',
              how_to_spot:
                  'Due to its miniature size, a lone aphid can be difficult to spot. Fortunately, aphids are usually present in large clusters that are hard to miss. Regularly inspect the undersides of leaves for green or black bugs that are roughly 1/8-inch long.',
              how_to_getridof:
                  "There are a few different ways to eliminate aphids. Your first course of action should be to prune any excess foliage where there are infestations. If the problem persists, release aphid-killing insects—such as ladybugs and lace bugs—that won't further damage your tomato plants.",
            ),
          ),
          PestCard(
            image: AssetImage('assets/images/pests/beetles.jpg'),
            name: 'Beetles',
            nextPage: PestInfoPage(
              name: 'Beetles',
              path: 'assets/images/pests/beetles.jpg',
              information:
                  "There are multiple species of adult beetles—including blister beetles, Colorado potato beetles, and flea beetles—that can threaten your tomato crop, as well as just about any other crop you're growing! Some of these beetles do minimal damage, while others leave tattered tomato plants in their wake.",
              how_to_spot:
                  "Make a habit of inspecting all areas of your tomato plants. Beetle infestations can occur on any part of the plant, depending on the species of bug.\n\n What's more, beetles vary in appearance. Blister beetles are black with red heads, Colorado potato beetles have alternating black and yellow stripes, and flea beetles are entirely black!",
              how_to_getridof:
                  "Unfortunately, there's no catchall solution for eliminating beetles, as different types of beetles respond to different methods. \n\nRegardless, be careful when dealing with these tomato pests. Certain species are harmful to not only tomatoes but also humans. Research the specific type of beetle you see and wear gloves when dealing with it!",
            ),
          ),
          PestCard(
            image: AssetImage('assets/images/pests/borers.jpg'),
            name: 'Borers',
            nextPage: PestInfoPage(
              name: 'Borers',
              path: 'assets/images/pests/borers.jpg',
              information:
                  "Like fruitworms, borers will often dig tiny holes that go unseen. The stalk borer, specifically, is a purple-colored caterpillar that preys on tomato plants and can be found throughout most of the United States.",
              how_to_spot:
                  "Newly hatched borers are much harder to spot than their adult counterparts, for obvious reasons. They do most of their insect damage at the stems of tomato plants, so watch for signs of disease or decay at the stems and foliage!",
              how_to_getridof:
                  "Frequent pruning and weed control are two of the most effective methods for eliminating borers. Cut down any tomato plants that have already been infested!",
            ),
          ),
          PestCard(
            image: AssetImage('assets/images/pests/cutworm.jpg'),
            name: 'Cutworms',
            nextPage: PestInfoPage(
              name: 'Cutworms',
              path: 'assets/images/pests/cutworm.jpg',
              information:
                  "Cutworms are soil-dwelling caterpillars that interfere with tomato seedlings by chewing right through their stems. In fact, these aggressive grubs need very little time to annihilate a newly planted crop.",
              how_to_spot:
                  "While you might spot a tomato cutworm anywhere on the plant, they do most of their damage at the base of the stem. These cream-colored grubs will usually stand out against your dark brown soil surface!",
              how_to_getridof:
                  "One of the best methods of eliminating cutworms is to scatter cornmeal around your tomato plants. What’s more, proper watering and soil care can help keep cutworms away from your crop.",
            ),
          ),
          PestCard(
            image: AssetImage('assets/images/pests/fruitworm.jpg'),
            name: 'Fruitworms',
            nextPage: PestInfoPage(
              name: 'Fruitworms',
              path: "assets/images/pests/fruitworm.jpg",
              information:
                  "Tomato fruitworms are the yellow-white larvae of adult moths that are found as far north as Canada, as far south as Argentina, and all throughout the United States.\n\nWhat makes the tomato fruitworm one of the most damaging garden pests is its ability to burrow tiny holes early on in its life cycle and do all its fruit damage from the inside of your tomatoes.",
              how_to_spot:
                  "The key to spotting a fruitworm infestation is to keep an eye out for the creamy-white eggs that are laid on your plants’ leaflets. If the larvae have time to hatch and burrow, they can go undetected until your tomatoes start to rot.",
              how_to_getridof:
                  "The most effective way of eliminating fruitworms from your garden is often to encourage their natural predators—pirate bugs and big-eyed bugs, to name only a few.",
            ),
          ),
          PestCard(
            image: AssetImage('assets/images/pests/nematodes.jpg'),
            name: 'Nematodes',
            nextPage: PestInfoPage(
              name: 'Nematodes',
              path: "assets/images/pests/nematodes.jpg",
              information:
                  "Nematodes, also known as tomato eelworms, are arguably the most problematic tomato pests. There are more than 20,000 different species of this insect worldwide, yet the species that typically affects tomato plants is the root-knot nematode. These grubs create knobby roots that prevent the plants from getting the nutrients they need.",
              how_to_spot:
                  "The first sign of a nematode infestation is usually plant discoloration. The most blatant sign of an infestation, however, is found once the plant is lifted from the soil: a knobby root system, filled with various bumps and galls.",
              how_to_getridof:
                  "Nematodes are difficult to manage, as they do much of their damage at the root and also play an important role in controlling other garden pests. If you have a severe nematode problem, focus on growing nematode-resistant varieties until these grubs have settled down.",
            ),
          ),
          PestCard(
            image: AssetImage('assets/images/pests/psylid.jpg'),
            name: 'Psyllids',
            nextPage: PestInfoPage(
              name: 'Psyllids',
              path: "assets/images/pests/psylid.jpg",
              information:
                  "Psyllids are plant lice that have the ability to jump, allowing them to move from plant to plant swiftly. Resembling miniature cicadas, these sap-suckers inflict a significant amount of damage and are considered the biggest threats to tomato plants in certain states.",
              how_to_spot:
                  "Psyllid saliva also has a toxic effect on tomato plants, bringing about a condition referred to as “psyllid yellows.” This causes foliage to turn yellow and fall from the plant. These bugs are also known to leave trails of psyllid sugar on leaves.",
              how_to_getridof:
                  "Sometimes winter will eradicate psyllid infestations naturally, as these jumping plant lice can’t survive harsh conditions. Allowing spiders, birds, and predatory insects to thrive can also help control psyllid populations.",
            ),
          ),
          PestCard(
            image: AssetImage('assets/images/pests/snail.jpg'),
            name: 'Slugs/Snails',
            nextPage: PestInfoPage(
              name: 'Slugs/Snails',
              path: "assets/images/pests/snail.jpg",
              information: "",
              how_to_spot: "",
              how_to_getridof: "",
            ),
          ),
          PestCard(
            image: AssetImage('assets/images/pests/spider-mites.jpg'),
            name: 'Spider Mites',
            nextPage: PestInfoPage(
              name: 'Spider Mites',
              path: "assets/images/pests/spider-mites.jpg",
              information:
                  "Spider mites are tiny arachnids that are most often found in areas that have cool weather—and especially in greenhouses and other indoor facilities. These pests will feast on a tomato plant by piercing its leaf surface and draining the nutrients.",
              how_to_spot:
                  "At first, spider mite infestations are difficult to identify. These bugs leave almost no trace aside from the occasional web and some fine speckling on leaves. Eventually, however, dead leaves will turn yellow and fall from your tomato plants.",
              how_to_getridof:
                  "To prevent spider mites, make sure your plants are adequately watered and fed. If your tomato plants have already been affected, carefully prune any bad foliage. Horticultural oil spray and insecticidal soap can be effective as well.",
            ),
          ),
          PestCard(
            image: AssetImage('assets/images/pests/stink-bug.jpg'),
            name: 'Leaf-Footed Bugs',
            nextPage: PestInfoPage(
              name: 'Leaf-Footed Bugs',
              path: "assets/images/pests/stink-bug.jpg",
              information:
                  "Leaf-footed bugs—including stink bugs and squash bugs—are so common that we often give them a free pass. These stealthy insects, however, are known to feed on more than 50 different trees and plants—including tomatoes!\n\nBecause these bugs thrive in hot weather, they are especially prevalent down south during the spring, summer, and fall months.",
              how_to_spot:
                  "Many leaf-footed bugs are similar in appearance, often taking on a green or brown hue and measuring at roughly 3/4-inch long. Because these tomato pests do very little direct damage yet carry viruses, the first time you notice any impact may be when your crops start to yield deformed, immature fruit.",
              how_to_getridof:
                  "As an immediate solution, you can handpick leaf-footed bugs from your plants. Otherwise, planting companion plants like buckwheat, garlic, lavender, or chrysanthemums nearby can attract and trap these bugs so that they steer clear of your yummy tomatoes!",
            ),
          ),
          PestCard(
            image: AssetImage('assets/images/pests/tarnished-plant-bugs.jpg'),
            name: 'Tarnished Plant Bugs',
            nextPage: PestInfoPage(
              name: 'Tarnished Plant Bugs',
              path: "assets/images/pests/tarnished-plant-bugs.jpg",
              information:
                  "The tarnished plant bug (Lygus lineolaris) is a tomato pest that, like many of the pests that have been mentioned, sucks nutrients from stems, leaves, flowers, and fruits alike. While it can be spotted in most regions throughout the country, it’s most prevalent along the eastern side.",
              how_to_spot:
                  "There are a handful of ways to identify a tarnished plant bug infestation—the first being the black spots that they leave in their path. These pesky bugs can also cause deformities, including catfacing and cloudy spots on tomato fruit.",
              how_to_getridof:
                  "Frequently weed the areas around your tomato plants, as certain weeds—such as dandelions and pigweed—can provoke an infestation. Encouraging pirate bugs and big-eyed bugs can also help keep tarnished plant bugs at bay!",
            ),
          ),
          PestCard(
            image: AssetImage('assets/images/pests/thrip.jpg'),
            name: 'Thrips',
            nextPage: PestInfoPage(
              name: 'Thrips',
              path: "assets/images/pests/thrip.jpg",
              information:
                  "Thrips are miniature, narrow insects that have sets of four wings. Unlike the average tomato pest, they do the majority of their damage through the wilt virus they carry—which can be devastating for seedlings.",
              how_to_spot:
                  "While thrips are very small and seemingly invisible without the aid of a microscope, they often leave trails of brown spots on your tomato leaves—making them fairly conspicuous!",
              how_to_getridof:
                  "Once you find the signature trail of dark spots, be sure to remove any infected plants and prune any infested foliage. Ladybugs and certain birds can keep thrips from returning to munch on your tomato plants!",
            ),
          ),
          PestCard(
            image: AssetImage('assets/images/pests/tomato-hornworm.jpg'),
            name: 'Hornworms',
            nextPage: PestInfoPage(
              name: 'Hornworms',
              path: "assets/images/pests/tomato-hornworm.jpg",
              information:
                  "Before they develop into five-spotted hawk moths, hornworms spend much of their youth terrorizing our crops. These common pests are prevalent throughout both Australia and North America—but particularly in the northern United States.",
              how_to_spot:
                  "While these large, green caterpillars stand out against the deep red hues of a ripe tomato, they just as easily blend in with the green foliage they prefer to munch on. They do, however, leave trails of black droppings on leaves that are a little easier to spot.",
              how_to_getridof:
                  "Because tomato hornworms are large, slow-moving grubs, most infestations are manageable. The best course of action is usually to carefully handpick them from your plants.",
            ),
          ),
          PestCard(
            image: AssetImage('assets/images/pests/whiteflies.jpg'),
            name: 'Whiteflies',
            nextPage: PestInfoPage(
              name: 'Whiteflies',
              path: "assets/images/pests/whiteflies.jpg",
              information:
                  "Similar to aphids, whiteflies are sap-sucking insects that like to steal nutrients from healthy plants. In addition to limiting crop yields, these nuisances carry viruses that they spread from plant to plant.",
              how_to_spot:
                  "Unfortunately for whiteflies, their bright appearance gives them away. Although an adult whitefly is roughly 1/32-inch long, you can easily spot it against a red tomato or against green foliage.",
              how_to_getridof:
                  "As you would with an aphid infestation, carefully prune any foliage that has been affected. You can also release ladybugs and lace bugs to deal with these pests for you!",
            ),
          ),
          PestCard(
            image: AssetImage('assets/images/pests/wireworm.jpg'),
            name: 'Wireworms',
            nextPage: PestInfoPage(
              name: 'Wireworms',
              path: "assets/images/pests/wireworm.jpg",
              information:
                  "Similar to cutworms, wireworms are the larval stage of another bug—click beetles. Before they are fully mature, these pesky grubs will attack tomatoes, their root systems, and their stems.",
              how_to_spot:
                  "Keep a close eye on your seedlings, as new plants are especially vulnerable to these tomato pests. While wireworms typically start at the root of the plant, they often inch their way up through the main stem as well.",
              how_to_getridof:
                  "If you’re dealing with a wireworm infestation, try to attract birds to that area. These are various species of birds that will feed on these frustrating grubs and eliminate them for you!",
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

class PestCard extends StatelessWidget {
  final ImageProvider image;
  final String name;
  final Widget nextPage;

  const PestCard({
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

class PestInfoPage extends StatelessWidget {
  final String name;
  final String path;
  final String information;
  final String how_to_spot;
  final String how_to_getridof;

  const PestInfoPage({
    Key? key,
    required this.name,
    required this.path,
    required this.information,
    required this.how_to_spot,
    required this.how_to_getridof,
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
              child: Text(
                'How to Spot an $name Infestation',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Text(
                how_to_spot,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 5),
              child: Text(
                'How to Get Rid of $name',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              child: Text(
                how_to_getridof,
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
