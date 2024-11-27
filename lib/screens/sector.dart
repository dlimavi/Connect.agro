import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class SectorsScreen extends StatefulWidget {
  final String authorizationToken;
  final Function getSectors;
  late List<dynamic> sectorsList;

  SectorsScreen(
      {super.key,
      required this.authorizationToken,
      required this.getSectors,
      required this.sectorsList});

  @override
  State<SectorsScreen> createState() => _SectorsScreenState();
}

class _SectorsScreenState extends State<SectorsScreen> {
  final descriptionController = TextEditingController();
  final capacityController = TextEditingController();

  final updatedescriptionController = TextEditingController();
  final updatecapacityController = TextEditingController();

  Future<void> createSector(Map<String, Object> data) async {
    await http
        .post(
            Uri(
                scheme: "http",
                host: "localhost",
                port: 5256,
                path: "/api/Sector"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "bearer ${widget.authorizationToken.toString()}"
            },
            body: jsonEncode(data))
        .then((response) => {
              sleep(const Duration(seconds: 1)),
              widget
                  .getSectors()
                  .then((e) => {widget.sectorsList = e, setState(() {})})
            });
  }

  Future<void> deleteSector(int id) async {
    Map<String, dynamic> params = {
      'SectorId': id.toString(),
    };
    await http.delete(
        Uri(
            scheme: "http",
            host: "localhost",
            port: 5256,
            path: "/api/Sector",
            queryParameters: params),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "bearer ${widget.authorizationToken.toString()}"
        }).then((response) => {
          sleep(const Duration(seconds: 1)),
          widget
              .getSectors()
              .then((e) => {widget.sectorsList = e, setState(() {})})
        });
  }

  Future<void> updateSector(Map<String, Object> data) async {
    await http
        .put(
            Uri(
                scheme: "http",
                host: "localhost",
                port: 5256,
                path: "/api/Sector"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "bearer ${widget.authorizationToken.toString()}"
            },
            body: jsonEncode(data))
        .then((response) => {
              sleep(const Duration(seconds: 1)),
              widget
                  .getSectors()
                  .then((e) => {widget.sectorsList = e, setState(() {})})
            });
  }

  var openIndexes = [];

  @override
  void initState() {
    super.initState();
    widget.getSectors().then((e) => {widget.sectorsList = e, setState(() {})});
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        padding: const EdgeInsets.only(top: 15, right: 15),
        alignment: Alignment.topRight,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text(
            "+ Cadastrar Setor",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            descriptionController.text = "";
            capacityController.text = "";
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    title: const Text('Novo Setor'),
                    content: FractionallySizedBox(
                      widthFactor: 1,
                      child: Form(
                        child: SizedBox(
                            width: 600,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: descriptionController,
                                  decoration: const InputDecoration(
                                    labelText: 'Descrição',
                                    icon: Icon(Icons.account_box),
                                  ),
                                ),
                                TextFormField(
                                  controller: capacityController,
                                  decoration: const InputDecoration(
                                    labelText: 'Capacidade',
                                    icon: Icon(Icons.account_box),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(132, 255, 82, 82)),
                          child: const Text(
                            "Cancelar",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.of(context, rootNavigator: true).pop();
                          }),
                      ElevatedButton(
                          child: const Text("Cadastrar"),
                          onPressed: () {
                            createSector({
                              "description": descriptionController.text,
                              "capacity": capacityController.text
                            });
                            setState(() {});
                            Navigator.of(context, rootNavigator: true).pop();
                          })
                    ],
                  );
                });
          },
        ),
      ),
      Container(
          padding: const EdgeInsets.only(top: 5),
          width: double.infinity,
          height: MediaQuery.of(context).size.height - 167,
          child: ListView.builder(
              itemCount: widget.sectorsList.length,
              itemBuilder: (context, index) {
                final sector =
                    widget.sectorsList[index] as Map<String, dynamic>;
                return Card(
                    child: Column(children: [
                  ListTile(
                    title: Text(sector["description"]),
                    subtitle: Text("Capacidade: ${sector["capacity"]}"),
                    leading: const Icon(Icons.place_rounded),
                    trailing: ElevatedButton(
                      onPressed: () {
                        if (openIndexes.contains(index)) {
                          openIndexes.removeWhere((item) => item == index);
                        } else {
                          openIndexes.add(index);
                        }
                        setState(() {});
                      },
                      child: openIndexes.contains(index)
                          ? const Icon(Icons.arrow_drop_down)
                          : const Icon(Icons.arrow_drop_up),
                    ),
                  ),
                  openIndexes.contains(index)
                      ? Container(
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: Container(
                              margin: const EdgeInsets.all(8.0),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              updatedescriptionController.text =
                                                  sector["description"];
                                              updatecapacityController.text =
                                                  sector["capacity"].toString();
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      scrollable: true,
                                                      title: const Text(
                                                          'Atualizar Setor'),
                                                      content:
                                                          FractionallySizedBox(
                                                        widthFactor: 1,
                                                        child: Form(
                                                          child: SizedBox(
                                                              width: 600,
                                                              child: Column(
                                                                children: <Widget>[
                                                                  TextFormField(
                                                                    keyboardType:
                                                                        const TextInputType
                                                                            .numberWithOptions(),
                                                                    controller:
                                                                        updatedescriptionController,
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      labelText:
                                                                          'Descrição',
                                                                      icon: Icon(
                                                                          Icons
                                                                              .account_box),
                                                                    ),
                                                                  ),
                                                                  TextFormField(
                                                                    keyboardType:
                                                                        const TextInputType
                                                                            .numberWithOptions(),
                                                                    controller:
                                                                        updatecapacityController,
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      labelText:
                                                                          'Capacidade',
                                                                      icon: Icon(
                                                                          Icons
                                                                              .account_box),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )),
                                                        ),
                                                      ),
                                                      actions: [
                                                        ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                                backgroundColor:
                                                                    const Color
                                                                        .fromARGB(
                                                                        132,
                                                                        255,
                                                                        82,
                                                                        82)),
                                                            child: const Text(
                                                              "Cancelar",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .pop();
                                                            }),
                                                        ElevatedButton(
                                                            child: const Text(
                                                                "Atualizar"),
                                                            onPressed: () {
                                                              updateSector({
                                                                "id": sector[
                                                                    "id"],
                                                                "description":
                                                                    updatedescriptionController
                                                                        .text,
                                                                "capacity":
                                                                    updatecapacityController
                                                                        .text,
                                                              });
                                                              setState(() {});
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .pop();
                                                            })
                                                      ],
                                                    );
                                                  });
                                            },
                                            icon: const Icon(
                                              Icons.edit,
                                            )),
                                        const SizedBox(width: 30),
                                        IconButton(
                                            onPressed: () {
                                              deleteSector(sector["id"]);
                                              setState(() {});
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            )),
                                        const SizedBox(width: 20),
                                      ],
                                    )
                                  ])))
                      : Container()
                ]));
              }))
    ]);
  }
}
