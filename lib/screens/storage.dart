import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class StorageScreen extends StatefulWidget {
  final String authorizationToken;
  final Future<List<dynamic>> Function() getProducts;
  late List<dynamic> productsList;

  final Future<List<dynamic>> Function() getSupplies;
  late List<dynamic> suppliesList;

  StorageScreen({
    super.key,
    required this.authorizationToken,
    required this.getProducts,
    required this.productsList,
    required this.getSupplies,
    required this.suppliesList,
  });

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  final storeTypeController = TextEditingController();

  final descriptionController = TextEditingController();
  final daysToGrowController = TextEditingController();
  final priceController = TextEditingController();

  final updatedescriptionController = TextEditingController();
  final updatedaysToGrowController = TextEditingController();
  final updatepriceController = TextEditingController();

  Future<void> createProducts(Map<String, Object> data) async {
    await http
        .post(
            Uri(
                scheme: "http",
                host: "localhost",
                port: 5256,
                path: "/api/Produce"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "bearer ${widget.authorizationToken.toString()}"
            },
            body: jsonEncode(data))
        .then((response) => {
              sleep(const Duration(seconds: 1)),
              widget
                  .getProducts()
                  .then((e) => {widget.productsList = e, setState(() {})})
            });
  }

  Future<void> deleteProducts(int id) async {
    Map<String, dynamic> params = {
      'ProduceId': id.toString(),
    };
    await http.delete(
        Uri(
            scheme: "http",
            host: "localhost",
            port: 5256,
            path: "/api/Produce",
            queryParameters: params),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "bearer ${widget.authorizationToken.toString()}"
        }).then((response) => {
          sleep(const Duration(seconds: 1)),
          widget
              .getProducts()
              .then((e) => {widget.productsList = e, setState(() {})})
        });
  }

  Future<void> updateProduct(Map<String, Object> data) async {
    await http
        .put(
            Uri(
                scheme: "http",
                host: "localhost",
                port: 5256,
                path: "/api/Produce"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "bearer ${widget.authorizationToken.toString()}"
            },
            body: jsonEncode(data))
        .then((response) => {
              sleep(const Duration(seconds: 1)),
              widget
                  .getProducts()
                  .then((e) => {widget.productsList = e, setState(() {})})
            });
  }

  Future<void> createSupplies(Map<String, Object> data) async {
    await http
        .post(
            Uri(
                scheme: "http",
                host: "localhost",
                port: 5256,
                path: "/api/Supply"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "bearer ${widget.authorizationToken.toString()}"
            },
            body: jsonEncode(data))
        .then((response) => {
              sleep(const Duration(seconds: 1)),
              widget
                  .getSupplies()
                  .then((e) => {widget.suppliesList = e, setState(() {})})
            });
  }

  Future<void> deleteSupplies(int id) async {
    Map<String, dynamic> params = {
      'SupplyId': id.toString(),
    };
    await http.delete(
        Uri(
            scheme: "http",
            host: "localhost",
            port: 5256,
            path: "/api/Supply",
            queryParameters: params),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "bearer ${widget.authorizationToken.toString()}"
        }).then((response) => {
          sleep(const Duration(seconds: 1)),
          widget
              .getSupplies()
              .then((e) => {widget.suppliesList = e, setState(() {})})
        });
  }

  Future<void> updateSupply(Map<String, Object> data) async {
    await http
        .put(
            Uri(
                scheme: "http",
                host: "localhost",
                port: 5256,
                path: "/api/Supply"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "bearer ${widget.authorizationToken.toString()}"
            },
            body: jsonEncode(data))
        .then((response) => {
              sleep(const Duration(seconds: 1)),
              widget
                  .getSupplies()
                  .then((e) => {widget.suppliesList = e, setState(() {})})
            });
  }

  var openIndexes = [];
  @override
  void initState() {
    super.initState();
    widget
        .getSupplies()
        .then((e) => {widget.suppliesList = e, setState(() {})});
    widget
        .getProducts()
        .then((e) => {widget.productsList = e, setState(() {})});
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
          padding: const EdgeInsets.only(top: 15, right: 15),
          //alignment: Alignment.topRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DropdownMenu(
                  controller: storeTypeController,
                  initialSelection: "Suprimento",
                  //expandedInsets: const EdgeInsets.only(left: 0, right: 0),
                  leadingIcon: const Icon(Icons.shopping_bag),
                  label: const Text("Tipo"),
                  onSelected: (value) {
                    setState(() {});
                  },
                  dropdownMenuEntries: const [
                    DropdownMenuEntry(value: "Produto", label: "Produto"),
                    DropdownMenuEntry(value: "Suprimento", label: "Suprimento")
                  ]),
              storeTypeController.text == "Produto"
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: const Text(
                        "+ Cadastrar Produto",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        descriptionController.text = "";
                        daysToGrowController.text = "";
                        priceController.text = "";
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                scrollable: true,
                                title: const Text('Novo Produto'),
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
                                              controller: daysToGrowController,
                                              decoration: const InputDecoration(
                                                labelText: 'Dias para crescer',
                                                icon: Icon(Icons.account_box),
                                              ),
                                            ),
                                            TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9]')),
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              controller: priceController,
                                              decoration: const InputDecoration(
                                                labelText: 'Preço',
                                                icon: Icon(Icons.price_change),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              132, 255, 82, 82)),
                                      child: const Text(
                                        "Cancelar",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      }),
                                  ElevatedButton(
                                      child: const Text("Cadastrar"),
                                      onPressed: () {
                                        createProducts({
                                          "description":
                                              descriptionController.text,
                                          "daysToGrow":
                                              daysToGrowController.text,
                                          "price": priceController.text,
                                        });
                                        setState(() {});
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      })
                                ],
                              );
                            });
                      },
                    )
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: const Text(
                        "+ Cadastrar Suprimento",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        descriptionController.text = "";
                        daysToGrowController.text = "";
                        priceController.text = "";
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                scrollable: true,
                                title: const Text('Novo Suprimento'),
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
                                              keyboardType:
                                                  TextInputType.number,
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(r'[0-9]')),
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              controller: priceController,
                                              decoration: const InputDecoration(
                                                labelText: 'Preço',
                                                icon: Icon(Icons.price_change),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              132, 255, 82, 82)),
                                      child: const Text(
                                        "Cancelar",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      }),
                                  ElevatedButton(
                                      child: const Text("Cadastrar"),
                                      onPressed: () {
                                        createSupplies({
                                          "description":
                                              descriptionController.text,
                                          "price": priceController.text,
                                        });
                                        setState(() {});
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      })
                                ],
                              );
                            });
                      },
                    ),
            ],
          )),
      Container(
          padding: const EdgeInsets.only(top: 5),
          width: double.infinity,
          height: MediaQuery.of(context).size.height - 177,
          child: storeTypeController.text != "Produto"
              ? ListView.builder(
                  itemCount: widget.suppliesList.length,
                  itemBuilder: (context, index) {
                    final supply =
                        widget.suppliesList[index] as Map<String, dynamic>;
                    return Card(
                        child: Column(children: [
                      ListTile(
                        title: Text(supply["description"]),
                        subtitle: Text("R\$ ${supply["price"]}"),
                        leading: const Icon(Icons.shopping_bag),
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
                                      children: [
                                        const Text(
                                          "Quantidade: ",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(supply["quantity"].toString(),
                                            style:
                                                const TextStyle(fontSize: 16))
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              updatedescriptionController.text =
                                                  supply["description"]
                                                      .toString();
                                              updatepriceController.text =
                                                  supply["price"].toString();
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      scrollable: true,
                                                      title: const Text(
                                                          'Atualizar Suprimento'),
                                                      content:
                                                          FractionallySizedBox(
                                                        widthFactor: 1,
                                                        child: Form(
                                                          child: SizedBox(
                                                              width: 600,
                                                              child: Column(
                                                                children: <Widget>[
                                                                  TextFormField(
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
                                                                        updatepriceController,
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      labelText:
                                                                          'Preço',
                                                                      icon: Icon(
                                                                          Icons
                                                                              .location_city),
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
                                                              updateSupply({
                                                                "id": supply[
                                                                    "id"],
                                                                "description":
                                                                    updatedescriptionController
                                                                        .text,
                                                                "price":
                                                                    updatepriceController
                                                                        .text
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
                                              deleteSupplies(supply["id"]);
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
                  })
              : ListView.builder(
                  itemCount: widget.productsList.length,
                  itemBuilder: (context, index) {
                    final product =
                        widget.productsList[index] as Map<String, dynamic>;
                    return Card(
                        child: Column(children: [
                      ListTile(
                        title: Text(product["description"]),
                        subtitle: Text("R\$ ${product["price"]}"),
                        leading: const Icon(Icons.shopping_bag),
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
                                      children: [
                                        const Text(
                                          "Dias para crescer: ",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(product["daysToGrow"].toString(),
                                            style:
                                                const TextStyle(fontSize: 16))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Quantidade: ",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(product["quantity"].toString(),
                                            style:
                                                const TextStyle(fontSize: 16))
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              updatedescriptionController.text =
                                                  product["description"]
                                                      .toString();
                                              updatedaysToGrowController.text =
                                                  product["daysToGrow"]
                                                      .toString();
                                              updatepriceController.text =
                                                  product["price"].toString();
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      scrollable: true,
                                                      title: const Text(
                                                          'Atualizar Produto'),
                                                      content:
                                                          FractionallySizedBox(
                                                        widthFactor: 1,
                                                        child: Form(
                                                          child: SizedBox(
                                                              width: 600,
                                                              child: Column(
                                                                children: <Widget>[
                                                                  TextFormField(
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
                                                                        updatedaysToGrowController,
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      labelText:
                                                                          'Dias para crescer',
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
                                                                        updatepriceController,
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      labelText:
                                                                          'Preço',
                                                                      icon: Icon(
                                                                          Icons
                                                                              .location_city),
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
                                                              updateProduct({
                                                                "id": product[
                                                                    "id"],
                                                                "description":
                                                                    updatedescriptionController
                                                                        .text,
                                                                "daysToGrow":
                                                                    updatedaysToGrowController
                                                                        .text,
                                                                "price":
                                                                    updatepriceController
                                                                        .text
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
                                              deleteProducts(product["id"]);
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
