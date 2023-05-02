import 'package:astarte/sidebar.dart';
import 'package:flutter/material.dart';

import 'utils/workers_util.dart';

class Workers extends StatefulWidget {
  const Workers({Key? key}) : super(key: key);

  @override
  State<Workers> createState() => _WorkersState();
}

class _WorkersState extends State<Workers> {
  late Future<List<Worker>>? _workersData;
  List<Worker> workerOptions = [];

  @override
  void initState() {
    super.initState();
    _workersData = getWorkerData();
  }

  static String _displayStringForOption(Worker option) => '${option.name} ${option.surname}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AstarteAppBar(title: 'Workers'),
      body: ListView(
        children: [
          ListTile(
            title: ElevatedButton(
                onPressed: showWorkerFilterDialog,
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      Color.fromARGB(255, 133, 208, 222)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.person_search_rounded),
                    Expanded(child: Center(child: Text("Find"))),
                  ],
                )),
          ),
          SizedBox(
              height: 100000000,
              child: FutureBuilder<List<Worker>>(
                future: _workersData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Worker>? workers = snapshot.data;
                    workerOptions = workers!;

                    return ListView.builder(
                      itemCount: workers.length,
                      itemBuilder: (BuildContext context, int index) {
                        return WorkerCard(worker: workers[index]);
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

  void showWorkerFilterDialog() async {
    final result = await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Find Worker'),
          content: Autocomplete<Worker>(
            displayStringForOption: _displayStringForOption,
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<Worker>.empty();
              }
              return workerOptions.where((Worker option) {
                return option
                    .toString()
                    .contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (Worker selection) {
              Navigator.of(context).pop();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => WorkerCardDetail(worker: selection,)));
            },
          )
        );
      },
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
          side: BorderSide(width: 1.5, color: Color.fromARGB(255, 34, 41, 42))),
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

class WorkerCardDetail extends StatefulWidget {
  const WorkerCardDetail({Key? key, required this.worker}) : super(key: key);

  final Worker worker;

  @override
  State<WorkerCardDetail> createState() => _WorkerCardDetailState();
}

class _WorkerCardDetailState extends State<WorkerCardDetail> {

  late Worker _worker; // declare a private variable to store the worker

  @override
  void initState() {
    super.initState();
    _worker = widget.worker; // access the worker variable via widget property
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${_worker.name} ${_worker.surname}"),
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
            Text(
              "${_worker.name} ${_worker.surname}",
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
              '${_worker.about}',
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
                if (_worker.event != null)
                  Expanded(child: _worker.event?.get())
                else
                  Container(
                    padding: const EdgeInsets.only(right: 8.0),
                    height: 30,
                    child: const Icon(Icons.hotel_rounded),
                  ),
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
