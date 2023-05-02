import 'package:astarte/sidebar.dart';
import 'package:astarte/theme/colors.dart';
import 'package:flutter/material.dart';

import 'utils/workers_util.dart';

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
                      CustomColors.astarteLightBlue
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.person_search_rounded),
                    Expanded(child: Center(child: Text("Filter"))),
                  ],
                )),
          ),
          SizedBox(
              height: 100000000,
              child: FutureBuilder<List<Worker>>(
                future: getWorkerData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Worker>? workers = snapshot.data;
                    return ListView.builder(
                      itemCount: workers?.length,
                      itemBuilder: (BuildContext context, int index) {
                        return WorkerCard(worker: workers![index]);
                      },
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ))
        ],
      ),
      drawer: NavBar(context),
    );
  }
}

class WorkerCard extends StatelessWidget {
  const WorkerCard({Key? key, required this.worker}) : super(key: key);

  final Worker worker;

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
          side: BorderSide(width: 1.5, color: CustomColors.astarteDarkGrey)),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => WorkerCardDetail(worker: worker,))),
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
                    child: worker.profilePhoto
                  ),
                ),
              ),
              Text("${worker.name} ${worker.surname}"),
              if (worker.event != null)
                SizedBox(
                  height: 50,
                    width: 50,
                    child:worker.event?.getImage())
              else
                Container(
                  padding: const EdgeInsets.only(right: 8.0),
                  height: 60,
                  child: const Icon(Icons.hotel_rounded),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class WorkerCardDetail extends StatelessWidget {
  const WorkerCardDetail({Key? key, required this.worker}) : super(key: key);

  final Worker worker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${worker.name} ${worker.surname}"),
        backgroundColor: CustomColors.astarteRed,
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
            Text(
              "${worker.name} ${worker.surname}",
              style: const TextStyle(
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
            Text(
              '${worker.about}',
              style: const TextStyle(
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
                if (worker.event != null)
                  Expanded(child: worker.event?.get())
                else
                  Container(
                    padding: const EdgeInsets.only(right: 8.0),
                    height: 30,
                    child: const Icon(Icons.hotel_rounded),
                  ),
                ElevatedButton(
                  onPressed: () {},
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
