import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/screens/home.dart';
import 'package:mobile/screens/register.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<String> requestLogin() async {
      var response = await http.post(
          Uri(
              scheme: "http",
              host: "localhost",
              port: 5256,
              path: "/api/Authentication/login"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "username": usernameController.text,
            "password": passwordController.text
          }));
      return json.decode(response.body)["authorizationToken"];
    }

    return Material(
        child: Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("lib/assets/bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 200,
            child: Row(
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
          const Text(
            "Acesso",
            style: TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          FractionallySizedBox(
            widthFactor: 0.8,
            child: TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Nome de Usuário',
                filled: true,
              ),
            ),
          ),
          const SizedBox(height: 4),
          FractionallySizedBox(
              widthFactor: 0.8,
              child: TextField(
                obscureText: true,
                controller: passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Senha',
                  filled: true,
                ),
              )),
          FractionallySizedBox(
              widthFactor: 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Esqueci a senha",
                        style: TextStyle(color: Colors.white),
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const RegisterScreen()));
                      },
                      child: const Text(
                        "Criar uma conta",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              )),
          // SQLSERVER_express2024@
          const SizedBox(height: 10),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                requestLogin().then((token) => {
                      if (token != "")
                        {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  HomeScreen(authorizationToken: token)))
                        }
                      else
                        {print("falha ao logar")}
                    });
              },
              child: const Text(
                "    Entrar    ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              )),
          const Spacer(flex: 1),
        ],
      ),
    ));
  }
}
