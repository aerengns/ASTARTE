import 'package:astarte/sidebar.dart';
import 'package:flutter/material.dart';

class Workers extends StatefulWidget {
  const Workers({Key? key}) : super(key: key);

  @override
  State<Workers> createState() => _WorkersState();
}

class _WorkersState extends State<Workers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AstarteAppBar(title: 'Workers'),
      body: ListView(
        children: [
          ListTile(
            title: ElevatedButton(
                onPressed: () {
                  debugPrint('Filter Tapped');
                },
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      Color.fromARGB(255, 133, 208, 222)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.person_search_rounded),
                    Expanded(child: Center(child: Text("Filter"))),
                  ],
                )),
          ),
          const WorkerCard(),
          const WorkerCard(),
          const WorkerCard(),
          const WorkerCard(),
          const WorkerCard(),
        ],
      ),
      drawer: NavBar(context),
    );
  }
}

class WorkerCard extends StatelessWidget {
  const WorkerCard({Key? key, this.profilePhoto, this.name, this.work})
      : super(key: key);

  final Image? profilePhoto;
  final Text? name;
  final Icon? work;

  @override
  Widget build(BuildContext context) {
    return Card(
      // clipBehavior is necessary because, without it, the InkWell's animation
      // will extend beyond the rounded edges of the [Card] (see https://github.com/flutter/flutter/issues/109776)
      // This comes with a small performance cost, and you should not set [clipBehavior]
      // unless you need it.
      clipBehavior: Clip.hardEdge,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          side: BorderSide(width: 1.5, color: Color.fromARGB(255, 34, 41, 42))),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const WorkerCardDetail())),
        child: SizedBox(
          height: 75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: CircleAvatar(
                  minRadius: 29,
                  maxRadius: 33,
                  child: ClipOval(
                    child: Image.network(
                      'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                      fit: BoxFit.cover,
                      width: 90,
                      height: 90,
                    ),
                  ),
                ),
              ),
              const Text('John Doe'),
              Container(
                padding: const EdgeInsets.only(right: 8.0),
                height: 60,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                clipBehavior: Clip.antiAlias,
                child: Image.asset('assets/icons/watering.png'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WorkerCardDetail extends StatelessWidget {
  const WorkerCardDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("John Doe"),
        backgroundColor: const Color.fromRGBO(211, 47, 47, 1),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left_rounded),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                minRadius: 45,
                maxRadius: 75,
                child: ClipOval(
                  child: Image.network(
                    'https://oflutter.com/wp-content/uploads/2021/02/girl-profile.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'John Doe',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Software Engineer',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'About Me',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
              'Pellentesque rutrum aliquam tellus, vel venenatis nibh '
              'efficitur vel. Aliquam lacinia augue vitae velit gravida, '
              'sed facilisis urna volutpat. Integer pellentesque dui vel '
              'quam tincidunt, at varius urna consequat. Donec ut nisl '
              'at nunc ultrices iaculis. Nullam gravida, nunc vel aliquam '
              'dignissim, ex metus pulvinar velit, eu egestas turpis mauris '
              'vel nisl. Nullam vel quam non massa sollicitudin dictum vitae '
              'quis sapien. Duis eu felis vel urna tincidunt aliquam. Sed '
              'at ornare velit. Donec eu tortor at metus pellentesque '
              'ullamcorper eu nec ex. Integer blandit, sapien ut dapibus '
              'tempus, dui augue maximus nisl, ac vestibulum velit erat ut '
              'tellus. Sed euismod auctor turpis, at euismod lorem cursus '
              'ut. Vestibulum bibendum sapien vel quam aliquet tristique. '
              'Donec imperdiet, nulla in dignissim efficitur, libero arcu '
              'pulvinar velit, ac tristique lacus augue nec turpis.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Currently Working On',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.only(right: 8.0),
                  height: 40,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset('assets/icons/watering.png'),
                ),
                const Text('Watering the soil on farm x'),
                ElevatedButton(
                  onPressed: () {},
                  style: const ButtonStyle(),
                  child: const Text('Assign Job'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
