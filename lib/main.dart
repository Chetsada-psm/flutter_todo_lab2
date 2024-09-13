import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const TodaApp(),
    );
  }
}

class TodaApp extends StatefulWidget {
  const TodaApp({
    super.key,
  });

  @override
  State<TodaApp> createState() => _TodaAppState();
}

class _TodaAppState extends State<TodaApp> {
  late TextEditingController _texteditController;
  late TextEditingController _descriptionController;

  final List<String> _myList = [];
  @override
  void initState() {
    super.initState();
    _texteditController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  void addTodoHandle(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add new task"),
            content: SizedBox(
              width: 120,
              height: 140,
              child: Column(
                children: [
                  TextField(
                    controller: _texteditController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Input your task"),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: "Description"),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    CollectionReference Tasks =
                        FirebaseFirestore.instance.collection("Task");
                    Tasks.add({'name': _texteditController.text}).then((res) {
                      print(res);
                    }).catchError((onError) {
                      print("Field to add new Task");
                    });
                    setState(() {
                      _myList.add(_texteditController.text);
                    });
                    _texteditController.text = "";
                    Navigator.pop(context);
                  },
                  child: const Text("Save"))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("Task").snapshots(),
          builder: (context, snapshot) {
            return snapshot.data != null
                ? ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Text(snapshot.data?.docs[index]["name"]));
                    })
                : const Text("No data");
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTodoHandle(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
