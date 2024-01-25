import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:g9_learn_firebase/models/car_model.dart';
import 'package:g9_learn_firebase/pages/login_page.dart';
import 'package:g9_learn_firebase/services/auth_service.dart';

import '../services/cloud_firestore_service.dart';

class HomePage extends StatefulWidget {
  final User? user;

  const HomePage({super.key, this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> list = [];

  TextEditingController nameCon = TextEditingController();
  TextEditingController colorCon = TextEditingController();
  TextEditingController costCon = TextEditingController();
  TextEditingController speedCon = TextEditingController();

  User? user;

  Future<void> read() async {
    isLoading = false;
    setState(() {});
    list = await CFSService.readAllData(collectionPath: "car");
    isLoading = true;
    setState(() {});
  }

  Future<void> create() async {
    // Car car = Car(name: "Cobalt", color: "white", cost: 13000, speed: 210, madeYear: 2023, type: "Petrol");
    await CFSService.createCollection(
        collectionPath: "car",
        data: {"memory": "128", "model": "iPhone 9", "name": "qwerty"});
  }

  @override
  void initState() {
    if (widget.user != null) {
      user = widget.user;
    }
    read();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await AuthService.logOut().then((value) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false);
              });
            },
            icon: const Icon(Icons.logout),
          )
        ],
        title: Text(
          "Hello ${user?.email.toString() ?? "No name"}",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.grey,
                          child: MaterialButton(
                            onPressed: () {},
                            onLongPress: () async {
                              /// deleting fields of map
                              // final deleteField = CFSService.db.collection("car").doc(list[index].id);
                              // final values =  <String, dynamic>{
                              //   "color": FieldValue.delete(),
                              //   "cost": FieldValue.delete(),
                              //   "name": FieldValue.delete(),
                              // };
                              // deleteField.update(values);
                              // await read();
                            },
                            child: ListTile(
                              title:
                                  Text(list[index].data()["name"] ?? "no name"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      nameCon.text = list[index]
                                              .data()["name"]
                                              .toString() ??
                                          "no name";
                                      colorCon.text = list[index]
                                              .data()["color"]
                                              .toString() ??
                                          "no color";
                                      costCon.text = list[index]
                                              .data()["cost"]
                                              .toString() ??
                                          "no cost";
                                      speedCon.text = list[index]
                                              .data()["speed"]
                                              .toString() ??
                                          "no speed";

                                      showDialog(
                                          context: context,
                                          builder: (_) {
                                            return AlertDialog(
                                              title: const Text("Update"),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    controller: nameCon,
                                                    decoration: const InputDecoration(
                                                        hintText: "Name",),
                                                  ),
                                                  TextField(
                                                    keyboardType: TextInputType.number,
                                                    decoration: const InputDecoration(
                                                        hintText: "Cost",),
                                                    controller: costCon,
                                                  ),
                                                  TextField(
                                                    keyboardType: TextInputType.number,
                                                    decoration: const InputDecoration(
                                                        hintText: "Speed",
                                                    ),
                                                    controller: speedCon,
                                                  ),
                                                  TextField(
                                                    decoration: const InputDecoration(
                                                        hintText: "Color",),
                                                    controller: colorCon,
                                                  ),
                                                ],
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Cancel"),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                    await CFSService.update(
                                                        collectionPath: "car",
                                                        id: list[index].id,
                                                        data: {
                                                          "name": nameCon.text,
                                                          "color":colorCon.text,
                                                          "cost":int.parse(costCon.text.trim()),
                                                          "speed":int.parse(speedCon.text.trim()),
                                                        });
                                                    await read();
                                                  },
                                                  child: const Text("OK"),
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      await CFSService.delete(
                                          collectionPath: "car",
                                          id: list[index].id);
                                      await read();
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    onPressed: () async {
                      Car car = Car(
                          name: "Cobalt",
                          color: "white",
                          cost: 200,
                          speed: 200,
                          madeYear: 2013,
                          type: "Petrol");
                      await CFSService.createCollection(
                          collectionPath: "car", data: car.toJson());
                      await read();
                    },
                    color: Colors.blueGrey,
                    child: const Text("Create"),
                  )
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
