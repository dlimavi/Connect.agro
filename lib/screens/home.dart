import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/screens/clients.dart';
import 'package:mobile/screens/operations.dart';
import 'package:mobile/screens/sector.dart';
import 'package:mobile/screens/planting.dart';
import 'package:mobile/screens/storage.dart';
import 'package:mobile/screens/suppliers.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final String authorizationToken;

  const HomeScreen({super.key, required this.authorizationToken});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _indiceAtual = 0;

  var productsList = [];

  Future<List> getProducts() async {
    var response = await http.get(
      Uri(
          scheme: "http",
          host: "localhost",
          port: 5256,
          path: "/api/Produce/List"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "bearer ${widget.authorizationToken.toString()}"
      },
    );
    return jsonDecode(response.body)["payload"] as List<dynamic>;
  }

  var suppliesList = [];

  Future<List> getSupplies() async {
    var response = await http.get(
      Uri(
          scheme: "http",
          host: "localhost",
          port: 5256,
          path: "/api/Supply/List"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "bearer ${widget.authorizationToken.toString()}"
      },
    );
    return jsonDecode(response.body)["payload"] as List<dynamic>;
  }

  var clientsList = [
    {
      "clientid": 0,
      "name": "Alberto",
      "cpf/cnpj": "000.000.000-00",
      "address": "São Paulo",
      "mail": "email@email.com",
    }
  ];

  Future<List> getClients() async {
    var response = await http.get(
      Uri(
          scheme: "http",
          host: "localhost",
          port: 5256,
          path: "/api/Customer/List"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "bearer ${widget.authorizationToken.toString()}"
      },
    );
    return jsonDecode(response.body)["payload"] as List<dynamic>;
  }

  var suppliersList = [];

  Future<List> getSuppliers() async {
    var response = await http.get(
      Uri(
          scheme: "http",
          host: "localhost",
          port: 5256,
          path: "/api/Supplier/List"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "bearer ${widget.authorizationToken.toString()}"
      },
    );
    return jsonDecode(response.body)["payload"] as List<dynamic>;
  }

  var sectorsList = [];

  Future<List> getSectors() async {
    var response = await http.get(
      Uri(
          scheme: "http",
          host: "localhost",
          port: 5256,
          path: "/api/Sector/List"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "bearer ${widget.authorizationToken.toString()}"
      },
    );
    return jsonDecode(response.body)["payload"] as List<dynamic>;
  }

  var plantationsList = [];

  Future<List> getPlantations() async {
    var response = await http.get(
      Uri(
          scheme: "http",
          host: "localhost",
          port: 5256,
          path: "/api/Plantation/List"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "bearer ${widget.authorizationToken.toString()}"
      },
    );
    return jsonDecode(response.body)["payload"] as List<dynamic>;
  }

  var operationsList = [];

  var salesList = [];

  Future<List> getSales() async {
    await Future.delayed(const Duration(seconds: 1));
    var response = await http.get(
      Uri(
          scheme: "http",
          host: "localhost",
          port: 5256,
          path: "/api/Sale/List"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "bearer ${widget.authorizationToken.toString()}"
      },
    );
    return jsonDecode(response.body)["payload"] as List<dynamic>;
  }

  var entriesList = [];

  Future<List> getEntries() async {
    await Future.delayed(const Duration(seconds: 1));
    var response = await http.get(
      Uri(
          scheme: "http",
          host: "localhost",
          port: 5256,
          path: "/api/Entry/List"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "bearer ${widget.authorizationToken.toString()}"
      },
    );
    return jsonDecode(response.body)["payload"] as List<dynamic>;
  }

  Future<List> getOperations() async {
    entriesList = [];
    salesList = [];
    await getEntries().then((entries) => {
          for (var entry in entries)
            {
              entriesList.add({
                "type": "Compra",
                "id": entry["id"],
                "date": entry["date"],
                "productId": entry["productId"],
                "quantity": entry["quantity"],
                "supplierId": entry["supplierId"]
              })
            },
        });
    await getSales().then((sales) => {
          for (var sale in sales)
            {
              salesList.add({
                "type": "Venda",
                "id": sale["id"],
                "date": sale["date"],
                "productId": sale["productId"],
                "quantity": sale["quantity"],
                "customerId": sale["customerId"]
              })
            }
        });
    return [...entriesList, ...salesList];
  }

  late final List<Widget> _telas = [
    InitialScreen(authorizationToken: widget.authorizationToken),
    StorageScreen(
        authorizationToken: widget.authorizationToken,
        productsList: productsList,
        getProducts: getProducts,
        suppliesList: suppliesList,
        getSupplies: getSupplies),
    ClientScreen(
        authorizationToken: widget.authorizationToken,
        clientsList: clientsList,
        getClients: getClients),
    SupplierScreen(
        authorizationToken: widget.authorizationToken,
        suppliersList: suppliersList,
        getSuppliers: getSuppliers),
    SectorsScreen(
        authorizationToken: widget.authorizationToken,
        sectorsList: sectorsList,
        getSectors: getSectors),
    PlantationsScreen(
        authorizationToken: widget.authorizationToken,
        productsList: productsList,
        sectorsList: sectorsList,
        plantationsList: plantationsList,
        getSectors: getSectors,
        getProducts: getProducts,
        getPlantations: getPlantations),
    OperationScreen(
        authorizationToken: widget.authorizationToken,
        operationsList: operationsList,
        suppliersList: suppliersList,
        clientsList: clientsList,
        suppliesList: suppliesList,
        productsList: productsList,
        getClients: getClients,
        getProducts: getProducts,
        getSuppliers: getSuppliers,
        getSupplies: getSupplies,
        getOperations: getOperations)
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Connect",
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.orange,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ".Agro",
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            body: _telas[_indiceAtual],
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: const Color.fromRGBO(103, 97, 75, 1),
              currentIndex: _indiceAtual,
              onTap: onTabTapped,
              items: const [
                BottomNavigationBarItem(
                    backgroundColor: Color.fromRGBO(103, 97, 75, 1),
                    icon: Icon(Icons.home),
                    label: "Inicio"),
                BottomNavigationBarItem(
                    backgroundColor: Color.fromRGBO(103, 97, 75, 1),
                    icon: Icon(Icons.shopping_bag),
                    label: "Estoque"),
                BottomNavigationBarItem(
                    backgroundColor: Color.fromRGBO(103, 97, 75, 1),
                    icon: Icon(Icons.person),
                    label: "Clientes"),
                BottomNavigationBarItem(
                    backgroundColor: Color.fromRGBO(103, 97, 75, 1),
                    icon: Icon(Icons.local_shipping),
                    label: "Fornecedores"),
                BottomNavigationBarItem(
                    backgroundColor: Color.fromRGBO(103, 97, 75, 1),
                    icon: Icon(Icons.edit_square),
                    label: "Setor"),
                BottomNavigationBarItem(
                    backgroundColor: Color.fromRGBO(103, 97, 75, 1),
                    icon: Icon(Icons.energy_savings_leaf),
                    label: "Plantação"),
                BottomNavigationBarItem(
                    backgroundColor: Color.fromRGBO(103, 97, 75, 1),
                    icon: Icon(Icons.monetization_on),
                    label: "Faturamento"),
              ],
            )));
  }

  void onTabTapped(int index) {
    setState(() {
      _indiceAtual = index;
    });
  }
}

class InitialScreen extends StatefulWidget {
  final String authorizationToken;

  const InitialScreen({super.key, required this.authorizationToken});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20.0)),
                      color: Colors.grey[200],
                    ),
                    width: 200,
                    height: 200,
                    child: Column(
                      children: [
                        IconButton(
                            color: Colors.grey[500],
                            onPressed: () {},
                            icon: const Icon(
                              Icons.arrow_upward,
                              size: 130,
                            )),
                        Text(
                          "Vendas do Mês",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600]),
                        )
                      ],
                    )),
                Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20.0)),
                      color: Colors.grey[200],
                    ),
                    width: 200,
                    height: 200,
                    child: Column(
                      children: [
                        IconButton(
                            color: Colors.grey[500],
                            onPressed: () {},
                            icon: const Icon(
                              Icons.arrow_downward,
                              size: 130,
                            )),
                        Text(
                          "Compras do Mês",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600]),
                        )
                      ],
                    ))
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20.0)),
                      color: Colors.grey[200],
                    ),
                    width: 200,
                    height: 200,
                    child: Column(
                      children: [
                        IconButton(
                            color: Colors.grey[500],
                            onPressed: () {},
                            icon: const Icon(
                              Icons.shopping_bag_outlined,
                              size: 130,
                            )),
                        Text(
                          "Produtos do Mês",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600]),
                        )
                      ],
                    )),
                Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20.0)),
                      color: Colors.grey[200],
                    ),
                    width: 200,
                    height: 200,
                    //color: Colors.grey[200],
                    child: Column(
                      children: [
                        IconButton(
                            color: Colors.grey[500],
                            onPressed: () {},
                            icon: const Icon(
                              Icons.shopping_bag_outlined,
                              size: 130,
                            )),
                        Text(
                          "Suprimentos do Mês",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600]),
                        )
                      ],
                    ))
              ],
            ),
          ],
        ));
  }
}
