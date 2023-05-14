import 'package:astarte/sidebar.dart';
import 'package:astarte/theme/colors.dart';
import 'package:astarte/utils/calendar_utils.dart';
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

  static String _displayStringForOption(Worker option) =>
      '${option.name} ${option.surname}';

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
                      CustomColors.astarteLightBlue),
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WorkerCardDetail(
                              worker: selection,
                            )));
              },
            ));
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
          side: BorderSide(width: 1.5, color: CustomColors.astarteDarkGrey)),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WorkerCardDetail(
                      worker: worker,
                    ))),
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
                  child: ClipOval(child: worker.profilePhoto),
                ),
              ),
              Text("${worker.name} ${worker.surname}"),
              if (worker.event != null)
                SizedBox(height: 50, width: 50, child: worker.event?.getImage())
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
  late Worker _worker;

  @override
  void initState() {
    super.initState();
    _worker = widget.worker;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${_worker.name} ${_worker.surname}"),
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
                  child: _worker.profilePhoto,
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
                // TODO: Add remove job
                ElevatedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AssignJob(
                                worker: _worker,
                              ))),
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

class AssignJob extends StatefulWidget {
  const AssignJob({Key? key, required this.worker}) : super(key: key);

  final Worker worker;

  @override
  State<AssignJob> createState() => _AssignJobState();
}

class _AssignJobState extends State<AssignJob> {
  Future<List<Event>>? events;

  late Worker _worker;

  @override
  void initState() {
    super.initState();
    events = getAvailableJobs();
    _worker = widget.worker;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const AstarteAppBar(title: 'Assign Job'),
        body: FutureBuilder<List<Event>>(
            future: events,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Event>? eventsList = snapshot.data;

                return ListView.builder(
                    itemCount: eventsList?.length,
                    itemBuilder: (context, index) => Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  const MaterialStatePropertyAll<Color>(
                                      Color.fromRGBO(105, 199, 105, 1.0)),
                              padding:
                                  MaterialStateProperty.all<EdgeInsetsGeometry>(
                                const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 4.0,
                                ),
                              ),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  side: const BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                            onPressed: () {
                              assignJob(_worker, eventsList[index])
                                  .then((returnVal) {
                                if (returnVal) {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                  Navigator.pushNamed(context, '/workers');
                                } else {
                                  print("Unsuccessful");
                                }
                              });
                            },
                            child: eventsList![index].get(),
                          ),
                        ));
              }
              return const CircularProgressIndicator();
            }));
  }
}
