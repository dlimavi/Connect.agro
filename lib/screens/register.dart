import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/screens/login.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var errorMessage = "";
  final usernameController = TextEditingController();
  bool usernameError = false;
  final emailController = TextEditingController();
  bool emailError = false;
  final passwordController = TextEditingController();
  bool passwordError = false;
  final confirmPasswordController = TextEditingController();
  bool confirmPasswordError = false;

  @override
  Widget build(BuildContext context) {
    bool isEmailValid() {
      return RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(emailController.text);
    }

    bool isPasswordWeak() {
      if (passwordController.text.length < 8) {
        return true;
      }
      return false;
    }

    bool isPasswordsEqual() {
      if (passwordController.text == confirmPasswordController.text) {
        return true;
      }
      return false;
    }

    Future<void> requestRegister(username, email, password) async {
      var response = await http.post(
          Uri(
              scheme: "http",
              host: "localhost",
              port: 5256,
              path: "/api/Authentication/register"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(
              {"username": username, "email": email, "password": password}));
      print(response.body);
    }

    void validate() {
      if (!isEmailValid()) {
        errorMessage = "Email inválido!";
        emailError = true;
      } else if (isPasswordWeak()) {
        errorMessage = "Senha muito fraca!";
        passwordError = true;
      } else if (!isPasswordsEqual()) {
        errorMessage = "As senhas devem ser iguais!";
        passwordError = true;
        confirmPasswordError = true;
      } else if (usernameController.text == "") {
        errorMessage = "Nome de usuário é obrigatório!";
        usernameError = true;
      } else {
        requestRegister(usernameController.text, emailController.text,
            passwordController.text);
      }
      setState(() {});
      Future.delayed(const Duration(seconds: 3), () {
        usernameError = false;
        emailError = false;
        passwordError = false;
        confirmPasswordError = false;
        errorMessage = "";
        setState(() {});
      });
    }

    return Material(
        child: Container(
      //color: const Color.fromRGBO(50, 121, 168, 1),
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
            "Cadastro",
            style: TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          FractionallySizedBox(
            widthFactor: 0.8,
            child: TextField(
              controller: usernameController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2)),
                errorText: usernameError ? errorMessage : null,
                errorStyle: const TextStyle(
                  fontSize: 15,
                ),
                errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.red,
                        strokeAlign: BorderSide.strokeAlignCenter)),
                hintText: 'Nome de Usuário',
                filled: true,
              ),
            ),
          ),
          const SizedBox(height: 4),
          FractionallySizedBox(
            widthFactor: 0.8,
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2)),
                errorText: emailError ? errorMessage : null,
                errorStyle: const TextStyle(
                  fontSize: 15,
                ),
                errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.red,
                        strokeAlign: BorderSide.strokeAlignCenter)),
                hintText: 'Email',
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
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2)),
                  errorText: passwordError ? errorMessage : null,
                  errorStyle: const TextStyle(
                    fontSize: 15,
                  ),
                  errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.red,
                          strokeAlign: BorderSide.strokeAlignCenter)),
                  hintText: 'Senha',
                  filled: true,
                ),
              )),
          const SizedBox(height: 4),
          FractionallySizedBox(
              widthFactor: 0.8,
              child: TextField(
                obscureText: true,
                controller: confirmPasswordController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 2)),
                  errorText: confirmPasswordError ? errorMessage : null,
                  errorStyle: const TextStyle(
                    fontSize: 15,
                  ),
                  errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.red,
                          strokeAlign: BorderSide.strokeAlignCenter)),
                  hintText: 'Confirmar Senha',
                  filled: true,
                ),
              )),
          FractionallySizedBox(
              widthFactor: 0.8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                      },
                      child: const Text(
                        "Tenho uma conta",
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              )),
          const SizedBox(height: 10),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                if (errorMessage == "") {
                  setState(() {
                    validate();
                  });
                }
              },
              child: const Text(
                "   Criar conta   ",
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
