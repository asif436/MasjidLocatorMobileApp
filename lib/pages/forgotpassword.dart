import 'package:flutter/material.dart';
import 'package:salahmaskan/utils/routes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:salahmaskan/main.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailAddrController = TextEditingController();
  var _isLoading = false;
  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );
  late AnimationController controller;
  var respResult = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          titleTextStyle: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          title: const Text('Forgot Password'),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, MyRoutes.homeRoute);
              },
            ),
            IconButton(
              icon: const Icon(Icons.login_rounded, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, MyRoutes.loginRoute);
              },
            ),
            IconButton(
              icon: const Icon(Icons.app_registration_rounded,
                  color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, MyRoutes.registrationRoute);
              },
            ),
          ],
        ),
        body: Material(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Image.asset(
                      "assets/images/favicon.png",
                      fit: BoxFit.cover,
                      height: 140,
                      width: 140,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 32.0),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailAddrController,
                            decoration: const InputDecoration(
                                hintText: "Email adsress provide at signup",
                                labelText: "Email address "),
                            validator: (String? value) {
                              if (value != null && value.isEmpty) {
                                return "Email address can't be empty";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(children: [
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              onPressed: _isLoading
                                  ? null
                                  : () async {
                                      setState(() => _isLoading = true);
                                      Future.delayed(
                                        const Duration(seconds: 10),
                                        () =>
                                            setState(() => _isLoading = false),
                                      );

                                      var email = _emailAddrController.text;
                                      var body = {'email': email};
                                      var res = await http.post(
                                          Uri.parse(
                                              '$SERVER_IP/users/user/forgotpassword'),
                                          body: body);
                                      if (res.statusCode == 200) {
                                        final responseJson =
                                            jsonDecode(res.body);
                                        respResult = responseJson["message"];
                                        setState(() {});
                                      }
                                    },
                              label: const Text('Email Password',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              icon: _isLoading
                                  ? Container(
                                      width: 24,
                                      height: 24,
                                      padding: const EdgeInsets.all(2.0),
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 3,
                                      ),
                                    )
                                  : const Icon(Icons.login),
                            ),
                          ]),
                          Row(
                            children: [
                              const SizedBox(
                                width: 40,
                              ),
                              Text(respResult),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}
