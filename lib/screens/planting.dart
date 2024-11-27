import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class PlantationsScreen extends StatefulWidget {
  final String authorizationToken;
  final Function getPlantations;
  late List<dynamic> plantationsList;
  final Function getSectors;
  late List<dynamic> sectorsList;
  final Function getProducts;
  late List<dynamic> productsList;

  PlantationsScreen(
      {super.key,
      required this.authorizationToken,
      required this.getPlantations,
      required this.plantationsList,
      required this.getSectors,
      required this.sectorsList,
      required this.getProducts,
      required this.productsList});

  @override
  State<PlantationsScreen> createState() => _PlantationsScreenState();
}

class _PlantationsScreenState extends State<PlantationsScreen> {
  List<DropdownMenuEntry<dynamic>> menuProducts = [];
  List<DropdownMenuEntry<dynamic>> menuSectors = [];
  var predictDate;

  final productidController = TextEditingController();
  var productidSelected;
  final dateController = TextEditingController();
  final quantityController = TextEditingController();
  final dateharvestController = TextEditingController();
  final sectoridController = TextEditingController();
  var sectoridSelected;

  final updateproductidController = TextEditingController();
  var updateproductidSelected;
  final updatedateController = TextEditingController();
  final updatequantityController = TextEditingController();
  final updatedateharvestController = TextEditingController();
  final updatesectoridController = TextEditingController();
  var updatesectoridSelected;

  String stringDateFormat(dateString) {
    var parts = dateString.split(' ');
    var dateParts = parts[0].split('/');
    var hoursParts = parts[1].split(':');
    var stringDate = dateParts[2] +
        '-' +
        dateParts[1] +
        '-' +
        dateParts[0] +
        'T' +
        hoursParts[0] +
        ':' +
        hoursParts[1] +
        ':00.341Z';
    return stringDate;
  }

  Future<void> createPlantations(Map<String, Object> data) async {
    await http
        .post(
            Uri(
                scheme: "http",
                host: "localhost",
                port: 5256,
                path: "/api/Plantation"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "bearer ${widget.authorizationToken.toString()}"
            },
            body: jsonEncode(data))
        .then((response) => {
              sleep(const Duration(seconds: 1)),
              widget.getPlantations().then((e) =>
                  {widget.plantationsList = e, print(e), setState(() {})})
            });
  }

  Future<void> deletePlantations(int id) async {
    Map<String, dynamic> params = {
      'plantationId': id.toString(),
    };
    await http.delete(
        Uri(
            scheme: "http",
            host: "localhost",
            port: 5256,
            path: "/api/Plantation",
            queryParameters: params),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "bearer ${widget.authorizationToken.toString()}"
        }).then((response) => {
          sleep(const Duration(seconds: 1)),
          widget
              .getPlantations()
              .then((e) => {widget.plantationsList = e, setState(() {})})
        });
  }

  Future<void> updatePlantation(Map<String, Object> data) async {
    await http
        .put(
            Uri(
                scheme: "http",
                host: "localhost",
                port: 5256,
                path: "/api/Plantation"),
            headers: {
              "Content-Type": "application/json",
              "Authorization": "bearer ${widget.authorizationToken.toString()}"
            },
            body: jsonEncode(data))
        .then((response) => {
              sleep(const Duration(seconds: 1)),
              widget
                  .getPlantations()
                  .then((e) => {widget.plantationsList = e, setState(() {})})
            });
  }

  dynamic getProductById(int id) {
    final index = widget.productsList.indexWhere(
        (product) => product["id"].toString() == (id - 1).toString());
    if (index == -1) return widget.productsList[0];
    return widget.productsList[index];
  }

  dynamic getSectorById(int id) {
    final index = widget.sectorsList
        .indexWhere((sector) => sector["id"].toString() == id.toString());
    if (index == -1) return widget.sectorsList[0];
    return widget.sectorsList[index];
  }

  var openIndexes = [];

  @override
  void initState() {
    super.initState();
    widget.getProducts().then((e) => {
          widget.productsList = e,
          setState(() {
            for (var product in widget.productsList) {
              menuProducts.add(DropdownMenuEntry(
                  value: product["id"],
                  label: product["description"].toString()));
            }
          })
        });
    widget.getSectors().then((e) => {
          widget.sectorsList = e,
          setState(() {
            for (var sector in widget.sectorsList) {
              menuSectors.add(DropdownMenuEntry(
                  value: sector["id"],
                  label: sector["description"].toString()));
            }
          })
        });
    widget
        .getPlantations()
        .then((e) => {widget.plantationsList = e, setState(() {})});
  }

  @override
  Widget build(BuildContext context) {
    void calculatePredictDate() {
      if (dateController.text != "" && productidController.text != "") {
        if (predictDate != null) {
          dateharvestController.text = DateFormat('dd/MM/yyyy HH:mm').format(
              predictDate.add(Duration(
                  days: getProductById(productidSelected + 1)["daysToGrow"])));
        } else {
          dateharvestController.text = "";
        }
      } else {
        dateharvestController.text = "";
      }
    }

    void updatecalculatePredictDate() {
      if (updatedateController.text != "" &&
          updateproductidController.text != "") {
        if (predictDate != null) {
          updatedateharvestController.text = DateFormat('dd/MM/yyyy HH:mm')
              .format(predictDate.add(Duration(
                  days: getProductById(
                      updateproductidSelected + 1)["daysToGrow"])));
        } else {
          updatedateharvestController.text = "";
        }
      } else {
        updatedateharvestController.text = "";
      }
    }

    return Column(children: [
      Container(
        padding: const EdgeInsets.only(top: 15, right: 15),
        alignment: Alignment.topRight,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text(
            "+ Agendar Plantação",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            productidController.text = "";
            dateController.text = "";
            quantityController.text = "";
            dateharvestController.text = "";
            sectoridController.text = "";
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    title: const Text('Nova Plantação'),
                    content: FractionallySizedBox(
                      widthFactor: 1,
                      child: Form(
                        child: SizedBox(
                            width: 600,
                            child: Column(
                              children: <Widget>[
                                TextField(
                                    controller: dateController,
                                    decoration: const InputDecoration(
                                        icon: Icon(Icons
                                            .calendar_today), //icon of text field
                                        labelText: "Data" //label text of field
                                        ),
                                    readOnly:
                                        true, // when true user cannot edit text
                                    onTap: () async {
                                      await showDatePicker(
                                              context: context,
                                              initialDate: DateTime
                                                  .now(), //get today's date
                                              firstDate: DateTime
                                                  .now(), //DateTime.now() - not to allow to choose before today.
                                              lastDate: DateTime(2101))
                                          .then((selectedDate) {
                                        if (selectedDate != null) {
                                          showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          ).then((selectedTime) {
                                            if (selectedTime != null) {
                                              DateTime selectedDateTime =
                                                  DateTime(
                                                selectedDate.year,
                                                selectedDate.month,
                                                selectedDate.day,
                                                selectedTime.hour,
                                                selectedTime.minute,
                                              );
                                              dateController.text =
                                                  DateFormat('dd/MM/yyyy HH:mm')
                                                      .format(selectedDateTime);
                                              predictDate = selectedDateTime;
                                              calculatePredictDate();
                                            }
                                          });
                                        }
                                      });
                                    }),
                                const SizedBox(height: 10),
                                DropdownMenu(
                                    controller: productidController,
                                    onSelected: (value) => {
                                          productidSelected = value,
                                          calculatePredictDate()
                                        },
                                    expandedInsets: const EdgeInsets.all(0),
                                    leadingIcon: const Icon(Icons.shopping_bag),
                                    label: const Text("Produto"),
                                    dropdownMenuEntries: menuProducts),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: quantityController,
                                  decoration: const InputDecoration(
                                      icon: Icon(Icons.calendar_today),
                                      labelText: "Quantidade"),
                                ),
                                const SizedBox(height: 10),
                                DropdownMenu(
                                    controller: sectoridController,
                                    onSelected: (value) =>
                                        {sectoridSelected = value},
                                    expandedInsets: const EdgeInsets.all(0),
                                    leadingIcon:
                                        const Icon(Icons.place_rounded),
                                    label: const Text("Local"),
                                    dropdownMenuEntries: menuSectors),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: dateharvestController,
                                  decoration: const InputDecoration(
                                      icon: Icon(Icons.calendar_today),
                                      labelText: "Data prevista"),
                                  readOnly: true,
                                )
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
                            createPlantations({
                              "productId": productidSelected,
                              "date": stringDateFormat(dateController.text),
                              "quantity": quantityController.text,
                              "estimatedHarvestDate":
                                  stringDateFormat(dateharvestController.text),
                              "sectorId": sectoridSelected
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
              itemCount: widget.plantationsList.length,
              itemBuilder: (context, index) {
                final plantation =
                    widget.plantationsList[index] as Map<String, dynamic>;
                return Card(
                    child: Column(children: [
                  ListTile(
                    title: Text(DateFormat('dd/MM/yyyy HH:mm')
                        .format(DateTime.parse(plantation["date"]))),
                    //subtitle: Text("Cliente"),
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
                                      children: [
                                        const Text(
                                          "Local: ",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            plantation["sectorId"] != null
                                                ? getSectorById(plantation[
                                                            "sectorId"])[
                                                        "description"]
                                                    .toString()
                                                : "",
                                            style:
                                                const TextStyle(fontSize: 16))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Produto: ",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            plantation["productId"] != null
                                                ? getProductById(plantation[
                                                            "productId"])[
                                                        "description"]
                                                    .toString()
                                                : "",
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
                                        Text(plantation["quantity"].toString(),
                                            style:
                                                const TextStyle(fontSize: 16))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Text(
                                          "Data prevista: ",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            DateFormat('dd/MM/yyyy HH:mm')
                                                .format(DateTime.parse(
                                                    plantation[
                                                        "expectedHarvestDate"])),
                                            style:
                                                const TextStyle(fontSize: 16))
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              updateproductidSelected =
                                                  plantation["productId"];
                                              updatesectoridSelected =
                                                  plantation["sectorId"];
                                              updateproductidController
                                                  .text = getProductById(
                                                      plantation["productId"])[
                                                  "description"];
                                              updatedateController.text =
                                                  DateFormat('dd/MM/yyyy HH:mm')
                                                      .format(DateTime.parse(
                                                          plantation["date"]));
                                              updatequantityController.text =
                                                  plantation["quantity"]
                                                      .toString();
                                              updatesectoridController
                                                  .text = getSectorById(
                                                      plantation["sectorId"])[
                                                  "description"];
                                              updatedateharvestController
                                                  .text = DateFormat(
                                                      'dd/MM/yyyy HH:mm')
                                                  .format(DateTime.parse(
                                                      plantation[
                                                          "expectedHarvestDate"]));

                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      scrollable: true,
                                                      title: const Text(
                                                          'Atualizar Plantação'),
                                                      content:
                                                          FractionallySizedBox(
                                                        widthFactor: 1,
                                                        child: Form(
                                                          child: SizedBox(
                                                              width: 600,
                                                              child: Column(
                                                                children: <Widget>[
                                                                  TextField(
                                                                      controller:
                                                                          updatedateController,
                                                                      decoration:
                                                                          const InputDecoration(
                                                                              icon: Icon(Icons
                                                                                  .calendar_today), //icon of text field
                                                                              labelText:
                                                                                  "Data" //label text of field
                                                                              ),
                                                                      readOnly:
                                                                          true, // when true user cannot edit text
                                                                      onTap:
                                                                          () async {
                                                                        await showDatePicker(
                                                                                context: context,
                                                                                initialDate: DateTime.now(), //get today's date
                                                                                firstDate: DateTime.now(), //DateTime.now() - not to allow to choose before today.
                                                                                lastDate: DateTime(2101))
                                                                            .then((selectedDate) {
                                                                          if (selectedDate !=
                                                                              null) {
                                                                            showTimePicker(
                                                                              context: context,
                                                                              initialTime: TimeOfDay.now(),
                                                                            ).then((selectedTime) {
                                                                              if (selectedTime != null) {
                                                                                DateTime selectedDateTime = DateTime(
                                                                                  selectedDate.year,
                                                                                  selectedDate.month,
                                                                                  selectedDate.day,
                                                                                  selectedTime.hour,
                                                                                  selectedTime.minute,
                                                                                );
                                                                                updatedateController.text = DateFormat('dd/MM/yyyy HH:mm').format(selectedDateTime);
                                                                                predictDate = selectedDateTime;
                                                                                updatecalculatePredictDate();
                                                                              }
                                                                            });
                                                                          }
                                                                        });
                                                                      }),
                                                                  const SizedBox(
                                                                      height:
                                                                          10),
                                                                  DropdownMenu(
                                                                      controller:
                                                                          updateproductidController,
                                                                      onSelected:
                                                                          (value) =>
                                                                              {
                                                                                updateproductidSelected = value,
                                                                                updatecalculatePredictDate()
                                                                              },
                                                                      expandedInsets:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              0),
                                                                      leadingIcon:
                                                                          const Icon(Icons
                                                                              .shopping_bag),
                                                                      label: const Text(
                                                                          "Produto"),
                                                                      dropdownMenuEntries:
                                                                          menuProducts),
                                                                  const SizedBox(
                                                                      height:
                                                                          10),
                                                                  TextField(
                                                                    controller:
                                                                        updatequantityController,
                                                                    decoration: const InputDecoration(
                                                                        icon: Icon(Icons
                                                                            .calendar_today),
                                                                        labelText:
                                                                            "Quantidade"),
                                                                  ),
                                                                  const SizedBox(
                                                                      height:
                                                                          10),
                                                                  DropdownMenu(
                                                                      controller:
                                                                          updatesectoridController,
                                                                      onSelected:
                                                                          (value) =>
                                                                              {
                                                                                updatesectoridSelected = value
                                                                              },
                                                                      expandedInsets:
                                                                          const EdgeInsets
                                                                              .all(
                                                                              0),
                                                                      leadingIcon:
                                                                          const Icon(Icons
                                                                              .place_rounded),
                                                                      label: const Text(
                                                                          "Local"),
                                                                      dropdownMenuEntries:
                                                                          menuSectors),
                                                                  const SizedBox(
                                                                      height:
                                                                          10),
                                                                  TextField(
                                                                    controller:
                                                                        updatedateharvestController,
                                                                    decoration: const InputDecoration(
                                                                        icon: Icon(Icons
                                                                            .calendar_today),
                                                                        labelText:
                                                                            "Data prevista"),
                                                                    readOnly:
                                                                        true,
                                                                  )
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
                                                              updatePlantation({
                                                                "id":
                                                                    plantation[
                                                                        "id"],
                                                                "productId":
                                                                    updateproductidSelected,
                                                                "date": stringDateFormat(
                                                                        updatedateController
                                                                            .text)
                                                                    .toString(),
                                                                "quantity":
                                                                    updatequantityController
                                                                        .text,
                                                                "expectedHarvestDate":
                                                                    stringDateFormat(
                                                                            updatedateharvestController.text)
                                                                        .toString(),
                                                                "sectorId":
                                                                    updatesectoridSelected
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
                                              deletePlantations(
                                                  plantation["id"]);
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
