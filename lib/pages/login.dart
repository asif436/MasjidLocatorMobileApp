import 'dart:io';
import 'package:salahmaskan/models/SigninResponse.dart';
import 'package:salahmaskan/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:salahmaskan/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  @override
  void initState() {
    controller = AnimationController(
      /// [AnimationController]s can be created with `vsync: this` because of
      /// [TickerProviderStateMixin].
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
    super.initState();
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );
  late AnimationController controller;
  var _isLoading = false;
  var roleId;

  final _formKey = GlobalKey<FormState>();
  final url = '';
  Entity entity = Entity();
  String advertisementImage = '';

  moveToHome(BuildContext context) {
    // ignore: use_build_context_synchronously
    Navigator.pushNamed(context, MyRoutes.homeRoute);
  }

  moveToRegistration(BuildContext context) async {
    Navigator.pushNamed(context, MyRoutes.registrationRoute);
    setState(() {});
  }

  Future<String?> attemptLogIn(String username, String password) async {
    String basicAuth =
        'Basic ${base64.encode(utf8.encode('$username:$password'))}';

    var res =
        await http.post(Uri.parse('$SERVER_IP/users/user/signin'), headers: {
      HttpHeaders.authorizationHeader: basicAuth,
    });
    if (res.statusCode == 200) {
      final responseJson = jsonDecode(res.body);

      if (responseJson["result"]["Advertisement"] == null) {
        advertisementImage = 'http://masjidlocators.com/DillySolutions.png';
      } else {
        var advertisement = responseJson["result"]["Advertisement"];
        advertisementImage = advertisement['image_url'];
      }
      entity = Entity.fromMap(responseJson["result"]["entity"]);
      var token = responseJson["result"]["token"];
      roleId = responseJson["result"]["role"];
      return token;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          titleTextStyle: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          title: const Text('Sign in'),
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
            IconButton(
              icon: const Icon(Icons.privacy_tip, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, MyRoutes.PrivacyPolicyRoute);
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
                    const Text(
                      "Welcome",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
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
                            keyboardType: TextInputType.number,
                            controller: _usernameController,
                            decoration: const InputDecoration(
                                hintText: "Phone no. without spaces",
                                labelText: "UserName/Phone No. "),
                            validator: (String? value) {
                              if (value != null && value.isEmpty) {
                                return "Username can't be empty";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                                hintText: "Enter Password",
                                labelText: "Password"),
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return "Password can't be empty";
                              } else if (value != null && value.length < 6) {
                                return "Password must be atleast 6 character long";
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
                                      if (!_formKey.currentState!.validate()) {
                                        setState(() {});
                                      } else {
                                        setState(() => _isLoading = true);
                                        Future.delayed(
                                          const Duration(seconds: 8),
                                          () => setState(
                                              () => _isLoading = false),
                                        );

                                        var username = _usernameController.text;
                                        var password = _passwordController.text;
                                        var jwt = await attemptLogIn(
                                            username, password);

                                        if (jwt != null && roleId == 1) {
                                          var shd = SecureHomeData(
                                              entity, advertisementImage);
                                          shd.entity = entity;
                                          shd.advertisementImage =
                                              advertisementImage;
                                          await storage.write(
                                              key: "jwtToken", value: jwt);
                                          Navigator.pushNamed(
                                            context,
                                            MyRoutes.secureHomeRoute,
                                            arguments: shd,
                                          );
                                        } else if (roleId == 2) {
                                          await storage.write(
                                              key: "jwtToken", value: jwt);
                                          Navigator.pushNamed(
                                            context,
                                            MyRoutes.secureAdminHomeRoute,
                                            arguments: entity,
                                          );
                                        } else {
                                          displayDialog(
                                              context,
                                              "An Error Occurred",
                                              "No account was found matching that username and password");
                                        }
                                      }
                                    },
                              label: const Text('SignIn',
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
                            const SizedBox(
                              width: 40,
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              onPressed: _isLoading
                                  ? null
                                  : () async {
                                      moveToHome(context);
                                    },
                              label: const Text('Home',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              icon: const Icon(Icons.home),
                            ),
                          ]),
                          const SizedBox(
                            height: 20,
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 20),
                              foregroundColor: Colors.green,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                MyRoutes.forgotpasswordRoute,
                              );
                            },
                            child: const Text('Forgot Password'),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}
