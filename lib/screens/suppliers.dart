import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class SupplierScreen extends StatefulWidget {
  final String authorizationToken;
  final Function getSuppliers;
  late List<dynamic> suppliersList;

  SupplierScreen(
      {super.key,
      required this.authorizationToken,
      required this.getSuppliers,
      required this.suppliersList});

  @override
  State<SupplierScreen> createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  final nameController = TextEditingController();
  final cpfController = TextEditingController();
  final mailController = TextEditingController();

  final updatenameController = TextEditingController();
  final updatecpfController = TextEditingController();
  final updatemailController = TextEditingController();

  Future<void> createSuppliers(Map<String, Object> data) async {
    await http
        .post(
            Uri(
                scheme: "http",
                host: "localhost",
                port: 5256,
                path: "/api/Supplier"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "bearer ${widget.authorizationToken.toString()}"
            },
            body: jsonEncode(data))
        .then((response) => {
              sleep(const Duration(seconds: 1)),
              widget
                  .getSuppliers()
                  .then((e) => {widget.suppliersList = e, setState(() {})})
            });
  }

  Future<void> deleteSuppliers(int id) async {
    Map<String, dynamic> params = {
      'supplierId': id.toString(),
    };
    await http.delete(
        Uri(
            scheme: "http",
            host: "localhost",
            port: 5256,
            path: "/api/Supplier",
            queryParameters: params),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "bearer ${widget.authorizationToken.toString()}"
        }).then((response) => {
          sleep(const Duration(seconds: 1)),
          widget
              .getSuppliers()
              .then((e) => {widget.suppliersList = e, setState(() {})})
        });
  }

  Future<void> updateSupplier(Map<String, Object> data) async {
    await http
        .put(
            Uri(
                scheme: "http",
                host: "localhost",
                port: 5256,
                path: "/api/Supplier"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "bearer ${widget.authorizationToken.toString()}"
            },
            body: jsonEncode(data))
        .then((response) => {
              sleep(const Duration(seconds: 1)),
              widget
                  .getSuppliers()
                  .then((e) => {widget.suppliersList = e, setState(() {})})
            });
  }

  var openIndexes = [];

  @override
  void initState() {
    super.initState();
    widget
        .getSuppliers()
        .then((e) => {widget.suppliersList = e, setState(() {})});
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
            "+ Cadastrar Fornecedor",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            nameController.text = "";
            cpfController.text = "";
            mailController.text = "";
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    title: const Text('Novo Fornecedor'),
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
                            createSuppliers({
                              "businessName": nameController.text,
                              "document": cpfController.text,
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
              itemCount: widget.suppliersList.length,
              itemBuilder: (context, index) {
                final supplier =
                    widget.suppliersList[index] as Map<String, dynamic>;
                return Card(
                    child: Column(children: [
                  ListTile(
                    title: Text(supplier["businessName"]),
                    subtitle: Text(supplier["document"]),
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
                                      "Email: ",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(supplier["email"] ?? "",
                                        style: const TextStyle(fontSize: 16))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          updatenameController.text =
                                              supplier["businessName"];
                                          updatecpfController.text =
                                              supplier["document"];
                                          updatemailController.text =
                                              supplier["email"];
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  scrollable: true,
                                                  title: const Text(
                                                      'Atualizar Fornecedor'),
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
                                                          updateSupplier({
                                                            "id":
                                                                supplier["id"],
                                                            "businessName":
                                                                updatenameController
                                                                    .text,
                                                            "document":
                                                                updatecpfController
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
                                          deleteSuppliers(supplier["id"]);
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
