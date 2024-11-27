import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class ClientScreen extends StatefulWidget {
  final String authorizationToken;
  final Function getClients;
  late List<dynamic> clientsList;

  ClientScreen(
      {super.key,
      required this.authorizationToken,
      required this.getClients,
      required this.clientsList});

  @override
  State<ClientScreen> createState() => _ClientScreenState();
}

class _ClientScreenState extends State<ClientScreen> {
  final nameController = TextEditingController();
  final cpfController = TextEditingController();
  final addressController = TextEditingController();
  final mailController = TextEditingController();

  final updatenameController = TextEditingController();
  final updatecpfController = TextEditingController();
  final updateaddressController = TextEditingController();
  final updatemailController = TextEditingController();

  Future<void> createClients(Map<String, Object> data) async {
    await http
        .post(
            Uri(
                scheme: "http",
                host: "localhost",
                port: 5256,
                path: "/api/Customer"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "bearer ${widget.authorizationToken.toString()}"
            },
            body: jsonEncode(data))
        .then((response) => {
              sleep(const Duration(seconds: 1)),
              widget
                  .getClients()
                  .then((e) => {widget.clientsList = e, setState(() {})})
            });
  }

  Future<void> deleteClients(int id) async {
    Map<String, dynamic> params = {
      'CustomerId': id.toString(),
    };
    await http.delete(
        Uri(
            scheme: "http",
            host: "localhost",
            port: 5256,
            path: "/api/Customer",
            queryParameters: params),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "bearer ${widget.authorizationToken.toString()}"
        }).then((response) => {
          sleep(const Duration(seconds: 1)),
          widget
              .getClients()
              .then((e) => {widget.clientsList = e, setState(() {})})
        });
  }

  Future<void> updateClient(Map<String, Object> data) async {
    await http
        .put(
            Uri(
                scheme: "http",
                host: "localhost",
                port: 5256,
                path: "/api/Customer"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "bearer ${widget.authorizationToken.toString()}"
            },
            body: jsonEncode(data))
        .then((response) => {
              sleep(const Duration(seconds: 1)),
              widget
                  .getClients()
                  .then((e) => {widget.clientsList = e, setState(() {})})
            });
  }

  var openIndexes = [];

  @override
  void initState() {
    super.initState();
    widget.getClients().then((e) => {widget.clientsList = e, setState(() {})});
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
            "+ Cadastrar Cliente",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            nameController.text = "";
            cpfController.text = "";
            addressController.text = "";
            mailController.text = "";
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    title: const Text('Novo Cliente'),
                    content: FractionallySizedBox(
                      widthFactor: 1,
                      child: Form(
                        child: SizedBox(
                            width: 600,
                            child: Column(
                              children: <Widget>[
                                TextFormField(
                                  controller: nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Nome',
                                    icon: Icon(Icons.account_box),
                                  ),
                                ),
                                TextFormField(
                                  controller: cpfController,
                                  decoration: const InputDecoration(
                                    labelText: 'CPF/CNPJ',
                                    icon: Icon(Icons.data_object),
                                  ),
                                ),
                                TextFormField(
                                  controller: addressController,
                                  decoration: const InputDecoration(
                                    labelText: 'Endereço',
                                    icon: Icon(Icons.place),
                                  ),
                                ),
                                TextFormField(
                                  controller: mailController,
                                  decoration: const InputDecoration(
                                    labelText: 'Email',
                                    icon: Icon(Icons.mail),
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
                            createClients({
                              "businessName": nameController.text,
                              "document": cpfController.text,
                              "address": addressController.text,
                              "email": mailController.text
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
              itemCount: widget.clientsList.length,
              itemBuilder: (context, index) {
                final client =
                    widget.clientsList[index] as Map<String, dynamic>;
                return Card(
                    child: Column(children: [
                  ListTile(
                    title: Text(client["businessName"]),
                    subtitle: Text(client["document"]),
                    leading: const Icon(Icons.person),
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
                    //trailing: Icon(Icons.star),
                  ),
                  openIndexes.contains(index)
                      ? Container(
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: Container(
                            margin: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  children: [
                                    const Text(
                                      "Endereço: ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(client["address"] ?? "",
                                        style: const TextStyle(fontSize: 16))
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Email: ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(client["email"] ?? "",
                                        style: const TextStyle(fontSize: 16))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          updatenameController.text =
                                              client["businessName"];
                                          updatecpfController.text =
                                              client["document"];
                                          updateaddressController.text =
                                              client["address"];
                                          updatemailController.text =
                                              client["email"];
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  scrollable: true,
                                                  title: const Text(
                                                      'Atualizar Cliente'),
                                                  content: FractionallySizedBox(
                                                    widthFactor: 1,
                                                    child: Form(
                                                      child: SizedBox(
                                                          width: 600,
                                                          child: Column(
                                                            children: <Widget>[
                                                              TextFormField(
                                                                controller:
                                                                    updatenameController,
                                                                decoration:
                                                                    const InputDecoration(
                                                                  labelText:
                                                                      'Nome',
                                                                  icon: Icon(Icons
                                                                      .account_box),
                                                                ),
                                                              ),
                                                              TextFormField(
                                                                controller:
                                                                    updatecpfController,
                                                                decoration:
                                                                    const InputDecoration(
                                                                  labelText:
                                                                      'CPF/CNPJ',
                                                                  icon: Icon(Icons
                                                                      .data_object),
                                                                ),
                                                              ),
                                                              TextFormField(
                                                                controller:
                                                                    updateaddressController,
                                                                decoration:
                                                                    const InputDecoration(
                                                                  labelText:
                                                                      'Endereço',
                                                                  icon: Icon(Icons
                                                                      .place),
                                                                ),
                                                              ),
                                                              TextFormField(
                                                                controller:
                                                                    updatemailController,
                                                                decoration:
                                                                    const InputDecoration(
                                                                  labelText:
                                                                      'Email',
                                                                  icon: Icon(
                                                                      Icons
                                                                          .mail),
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                    ),
                                                  ),
                                                  actions: [
                                                    ElevatedButton(
                                                        style: ElevatedButton
                                                            .styleFrom(
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
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        onPressed: () {
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pop();
                                                        }),
                                                    ElevatedButton(
                                                        child: const Text(
                                                            "Atualizar"),
                                                        onPressed: () {
                                                          updateClient({
                                                            "id": client["id"],
                                                            "businessName":
                                                                updatenameController
                                                                    .text,
                                                            "document":
                                                                updatecpfController
                                                                    .text,
                                                            "address":
                                                                updateaddressController
                                                                    .text,
                                                            "email":
                                                                updatemailController
                                                                    .text
                                                          });
                                                          setState(() {});
                                                          Navigator.of(context,
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
                                          deleteClients(client["id"]);
                                          setState(() {});
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        )),
                                    const SizedBox(width: 20),
                                  ],
                                )
                              ],
                            ),
                          ))
                      : Container()
                ]));
              }))
    ]);
  }
}
