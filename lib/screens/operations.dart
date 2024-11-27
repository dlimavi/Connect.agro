import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class OperationScreen extends StatefulWidget {
  final String authorizationToken;
  final Function getOperations;
  late List<dynamic> operationsList;
  final Function getSuppliers;
  late List<dynamic> suppliersList;
  final Function getClients;
  late List<dynamic> clientsList;
  final Function getProducts;
  late List<dynamic> productsList;
  final Function getSupplies;
  late List<dynamic> suppliesList;

  OperationScreen(
      {super.key,
      required this.authorizationToken,
      required this.getOperations,
      required this.operationsList,
      required this.getSuppliers,
      required this.suppliersList,
      required this.getClients,
      required this.clientsList,
      required this.getProducts,
      required this.productsList,
      required this.getSupplies,
      required this.suppliesList});

  @override
  State<OperationScreen> createState() => _OperationScreenState();
}

class _OperationScreenState extends State<OperationScreen> {
  final typeController = TextEditingController();
  var operationType = "";
  final dateController = TextEditingController();
  final quantityController = TextEditingController();
  final supplierclientController = TextEditingController();
  var supplierclientid;
  final productsupplyController = TextEditingController();
  var productsupplyid;

  final updatetypeController = TextEditingController();
  final updatedateController = TextEditingController();
  final updatequantityController = TextEditingController();
  final updatesupplierclientController = TextEditingController();
  final updateproductsupplyController = TextEditingController();
  var updateproductsupplyid;

  Future<void> createSale(Map<String, Object> data) async {
    print(data);
    await http
        .post(
            Uri(
                scheme: "http",
                host: "localhost",
                port: 5256,
                path: "/api/Sale"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "bearer ${widget.authorizationToken.toString()}"
            },
            body: jsonEncode(data))
        .then((response) => {
              print(response.body),
              sleep(const Duration(seconds: 1)),
              widget
                  .getOperations()
                  .then((e) => {widget.operationsList = e, setState(() {})})
            });
  }

  Future<void> createEntry(Map<String, Object> data) async {
    print(data);
    await http
        .post(
            Uri(
                scheme: "http",
                host: "localhost",
                port: 5256,
                path: "/api/Entry"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "bearer ${widget.authorizationToken.toString()}"
            },
            body: jsonEncode(data))
        .then((response) => {
              print(response.body),
              sleep(const Duration(seconds: 1)),
              widget
                  .getOperations()
                  .then((e) => {widget.operationsList = e, setState(() {})})
            });
  }

  Future<void> deleteSale(int id) async {
    Map<String, dynamic> params = {
      'SaleId': id.toString(),
    };
    await http.delete(
        Uri(
            scheme: "http",
            host: "localhost",
            port: 5256,
            path: "/api/Sale",
            queryParameters: params),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "bearer ${widget.authorizationToken.toString()}"
        }).then((response) => {
          sleep(const Duration(seconds: 1)),
          widget
              .getOperations()
              .then((e) => {widget.operationsList = e, setState(() {})})
        });
  }

  Future<void> deleteEntry(int id) async {
    Map<String, dynamic> params = {
      'EntryId': id.toString(),
    };
    await http.delete(
        Uri(
            scheme: "http",
            host: "localhost",
            port: 5256,
            path: "/api/Entry",
            queryParameters: params),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "bearer ${widget.authorizationToken.toString()}"
        }).then((response) => {
          sleep(const Duration(seconds: 1)),
          widget
              .getOperations()
              .then((e) => {widget.operationsList = e, setState(() {})})
        });
  }

  void updateSale(int id, Map<String, Object> data) {
    print(data);
  }

  void updateEntry(int id, Map<String, Object> data) {
    print(data);
  }

  Map<String, dynamic> getSupplierById(int id) {
    final index =
        widget.suppliersList.indexWhere((supplier) => supplier["id"] == id);
    if (index == -1) return widget.suppliersList[0];
    return widget.suppliersList[index];
  }

  Map<String, dynamic> getClientById(int id) {
    final index = widget.clientsList.indexWhere((client) => client["id"] == id);
    if (index == -1) return widget.clientsList[0];
    return widget.clientsList[index];
  }

  Map<String, dynamic> getProductById(int id) {
    final index =
        widget.productsList.indexWhere((product) => product["id"] == id);
    if (index == -1) return widget.productsList[0];
    return widget.productsList[index];
  }

  Map<String, dynamic> getSuppliesById(int id) {
    final index =
        widget.suppliesList.indexWhere((supply) => supply["id"] == id);
    if (index == -1) return widget.suppliesList[0];
    return widget.suppliesList[index];
  }

  var openIndexes = [];

  @override
  void initState() {
    super.initState();
    //widget.getClients().t
    widget
        .getProducts()
        .then((e) => {widget.productsList = e, setState(() {})});
    widget.getClients().then((e) => {widget.clientsList = e, setState(() {})});
    widget
        .getSuppliers()
        .then((e) => {widget.suppliersList = e, setState(() {})});
    widget
        .getSupplies()
        .then((e) => {widget.suppliesList = e, setState(() {})});
    widget
        .getOperations()
        .then((e) => {widget.operationsList = e, setState(() {})});
  }

  @override
  Widget build(BuildContext context) {
    List<DropdownMenuEntry<dynamic>> menuClients = [];
    List<DropdownMenuEntry<dynamic>> menuSuppliers = [];

    List<DropdownMenuEntry<dynamic>> menuSupplies = [];
    List<DropdownMenuEntry<dynamic>> menuProducts = [];

    for (var client in widget.clientsList) {
      menuClients.add(DropdownMenuEntry(
          value: client["id"].toString(),
          label: client["businessName"].toString()));
    }
    for (var supplier in widget.suppliersList) {
      menuSuppliers.add(DropdownMenuEntry(
          value: supplier["id"].toString(),
          label: supplier["businessName"].toString()));
    }
    for (var supplie in widget.suppliesList) {
      menuSupplies.add(DropdownMenuEntry(
          value: supplie["id"].toString(),
          label: supplie["description"].toString()));
    }
    for (var product in widget.productsList) {
      menuProducts.add(DropdownMenuEntry(
          value: product["id"].toString(),
          label: product["description"].toString()));
    }

    return Column(children: [
      Container(
        padding: const EdgeInsets.only(top: 15, right: 15),
        alignment: Alignment.topRight,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text(
            "+ Nova Operação",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            typeController.text = "";
            productsupplyController.text = "";
            dateController.text = "";
            quantityController.text = "";
            supplierclientController.text = "";
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    title: const Text('Nova Operação'),
                    content: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                      return FractionallySizedBox(
                        widthFactor: 1,
                        child: Form(
                          child: SizedBox(
                              width: 600,
                              child: Column(
                                children: <Widget>[
                                  DropdownMenu(
                                      controller: typeController,
                                      expandedInsets: const EdgeInsets.all(0),
                                      leadingIcon:
                                          const Icon(Icons.shopping_bag),
                                      label: const Text("Tipo de Operação"),
                                      onSelected: (value) {
                                        setState(() {
                                          supplierclientController.text = "";
                                        });
                                      },
                                      dropdownMenuEntries: const [
                                        DropdownMenuEntry(
                                            value: "Compra", label: "Compra"),
                                        DropdownMenuEntry(
                                            value: "Venda", label: "Venda")
                                      ]),
                                  const SizedBox(height: 10),
                                  DropdownMenu(
                                      controller: supplierclientController,
                                      expandedInsets: const EdgeInsets.all(0),
                                      onSelected: (value) {
                                        supplierclientid = value;
                                      },
                                      leadingIcon:
                                          const Icon(Icons.shopping_bag),
                                      label: typeController.text == "Compra"
                                          ? const Text("Fornecedor")
                                          : const Text("Cliente"),
                                      dropdownMenuEntries:
                                          typeController.text == "Compra"
                                              ? menuSuppliers
                                              : menuClients),
                                  const SizedBox(height: 10),
                                  DropdownMenu(
                                      controller: productsupplyController,
                                      onSelected: (value) =>
                                          {productsupplyid = value},
                                      expandedInsets: const EdgeInsets.all(0),
                                      leadingIcon:
                                          const Icon(Icons.shopping_bag),
                                      label: typeController.text == "Compra"
                                          ? const Text("Suprimento")
                                          : const Text("Produto"),
                                      dropdownMenuEntries:
                                          typeController.text == "Compra"
                                              ? menuSupplies
                                              : menuProducts),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: quantityController,
                                    decoration: const InputDecoration(
                                      labelText: 'Quantidade',
                                      icon: Icon(Icons.account_box),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      );
                    }),
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
                            typeController.text == "Compra"
                                ? createEntry({
                                    "productId": productsupplyid,
                                    "date": DateTime.now().toIso8601String(),
                                    "quantity": quantityController.text,
                                    "supplierId": supplierclientid
                                  })
                                : createSale({
                                    "productId": productsupplyid,
                                    "date": DateTime.now().toIso8601String(),
                                    "quantity": quantityController.text,
                                    "customerId": supplierclientid
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
              itemCount: widget.operationsList.length,
              itemBuilder: (context, index) {
                final operation =
                    widget.operationsList[index] as Map<String, dynamic>;
                return Card(
                    child: Column(children: [
                  ListTile(
                    title: operation["type"] == "Compra"
                        ? Text(getSuppliesById(
                                operation["productId"])["description"]
                            .toString())
                        : Text(
                            getProductById(
                                    operation["productId"])["description"]
                                .toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                    subtitle: Text(DateFormat('dd/MM/yyyy HH:mm')
                        .format(DateTime.parse(operation["date"]))),
                    leading: operation["type"] == "Compra"
                        ? const Icon(
                            Icons.arrow_downward,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.arrow_upward,
                            color: Colors.green,
                          ),
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
                                    operation["type"] == "Compra"
                                        ? Row(
                                            children: [
                                              const Text(
                                                "Fornecedor: ",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  operation["supplierId"] !=
                                                          null
                                                      ? getSupplierById(operation[
                                                                  "supplierId"])[
                                                              "businessName"]
                                                          .toString()
                                                      : "",
                                                  style: const TextStyle(
                                                      fontSize: 16))
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              const Text(
                                                "Cliente: ",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                  operation["customerId"] !=
                                                          null
                                                      ? getClientById(operation[
                                                                  "customerId"])[
                                                              "businessName"]
                                                          .toString()
                                                      : "",
                                                  style: const TextStyle(
                                                      fontSize: 16))
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
                                        Text(operation["quantity"].toString(),
                                            style:
                                                const TextStyle(fontSize: 16))
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        /*IconButton(
                                            onPressed: () {
                                              updatetypeController.text =
                                                  operation["type"].toString();
                                              updateproductsupplyController
                                                  .text = getProductById(
                                                      operation["productId"])[
                                                  "description"];
                                              updatesupplierclientController
                                                  .text = getClientById(
                                                      operation["customerId"])[
                                                  "businessName"];
                                              if (operation["customerId"] !=
                                                  null) {
                                                supplierclientid =
                                                    operation["customerId"];
                                              }
                                              updatedateController.text =
                                                  operation["date"].toString();
                                              updatequantityController.text =
                                                  operation["quantity"]
                                                      .toString();
                                              if (operation["supplierId"] !=
                                                  null) {
                                                supplierclientController.text =
                                                    operation["supplierId"]
                                                        .toString();
                                              } else {
                                                supplierclientController.text =
                                                    operation["customerId"]
                                                        .toString();
                                              }
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      scrollable: true,
                                                      title: const Text(
                                                          'Atualizar Operação'),
                                                      content: StatefulBuilder(
                                                          builder: (BuildContext
                                                                  context,
                                                              StateSetter
                                                                  setState) {
                                                        return FractionallySizedBox(
                                                          widthFactor: 1,
                                                          child: Form(
                                                            child: SizedBox(
                                                                width: 600,
                                                                child: Column(
                                                                  children: <Widget>[
                                                                    DropdownMenu(
                                                                        controller:
                                                                            updatetypeController,
                                                                        expandedInsets: const EdgeInsets
                                                                            .all(
                                                                            0),
                                                                        leadingIcon:
                                                                            const Icon(Icons
                                                                                .shopping_bag),
                                                                        label: const Text(
                                                                            "Tipo de Operação"),
                                                                        onSelected:
                                                                            (value) {
                                                                          setState(
                                                                              () {
                                                                            updatesupplierclientController.text =
                                                                                "";
                                                                          });
                                                                        },
                                                                        dropdownMenuEntries: const [
                                                                          DropdownMenuEntry(
                                                                              value: "Compra",
                                                                              label: "Compra"),
                                                                          DropdownMenuEntry(
                                                                              value: "Venda",
                                                                              label: "Venda")
                                                                        ]),
                                                                    const SizedBox(
                                                                        height:
                                                                            10),
                                                                    DropdownMenu(
                                                                        controller:
                                                                            updatesupplierclientController,
                                                                        expandedInsets: const EdgeInsets
                                                                            .all(
                                                                            0),
                                                                        onSelected:
                                                                            (value) {
                                                                          supplierclientid =
                                                                              value;
                                                                        },
                                                                        leadingIcon:
                                                                            const Icon(Icons
                                                                                .shopping_bag),
                                                                        label: updatetypeController.text ==
                                                                                "Compra"
                                                                            ? const Text(
                                                                                "Fornecedor")
                                                                            : const Text(
                                                                                "Cliente"),
                                                                        dropdownMenuEntries: updatetypeController.text ==
                                                                                "Compra"
                                                                            ? menuSuppliers
                                                                            : menuClients),
                                                                    const SizedBox(
                                                                        height:
                                                                            10),
                                                                    DropdownMenu(
                                                                        controller:
                                                                            updateproductsupplyController,
                                                                        onSelected:
                                                                            (value) => {
                                                                                  updateproductsupplyid = value
                                                                                },
                                                                        expandedInsets: const EdgeInsets
                                                                            .all(
                                                                            0),
                                                                        leadingIcon:
                                                                            const Icon(Icons
                                                                                .shopping_bag),
                                                                        label: updatetypeController.text ==
                                                                                "Compra"
                                                                            ? const Text(
                                                                                "Suprimento")
                                                                            : const Text(
                                                                                "Produto"),
                                                                        dropdownMenuEntries: updatetypeController.text ==
                                                                                "Compra"
                                                                            ? menuSupplies
                                                                            : menuProducts),
                                                                    const SizedBox(
                                                                        height:
                                                                            10),
                                                                    TextFormField(
                                                                      controller:
                                                                          updatequantityController,
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        labelText:
                                                                            'Quantidade',
                                                                        icon: Icon(
                                                                            Icons.account_box),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )),
                                                          ),
                                                        );
                                                      }),
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
                                                              if (operation[
                                                                      "type"] ==
                                                                  "Compra") {
                                                                updateEntry(
                                                                    operation[
                                                                        "id"],
                                                                    {
                                                                      "id": operation[
                                                                          "id"],
                                                                    });
                                                              } else {
                                                                updateSale(
                                                                    operation[
                                                                        "id"],
                                                                    {
                                                                      "id": operation[
                                                                          "id"],
                                                                    });
                                                              }
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
                                            )),*/
                                        const SizedBox(width: 30),
                                        IconButton(
                                            onPressed: () {
                                              if (operation["type"] ==
                                                  "Compra") {
                                                deleteEntry(operation["id"]);
                                              } else {
                                                deleteSale(operation["id"]);
                                              }
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
