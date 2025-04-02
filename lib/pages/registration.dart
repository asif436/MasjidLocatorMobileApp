import 'dart:io';
import 'package:salahmaskan/models/SigninResponse.dart';
import 'package:salahmaskan/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:salahmaskan/main.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:geocoding/geocoding.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration>
    with TickerProviderStateMixin {
  // Used after successful submission of registration form
  late String dialogueTitle;
  late String dialogueText;

  var _isLoading = false;
  bool changeButton = false;
  List<dynamic> lstSects = [];
  List<DropdownMenuItem<String>> menuItems = [];
  String selectedValue = "Select Sect";

  final _formKey = GlobalKey<FormState>();
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  final TextEditingController _entitynameController = TextEditingController();
  final TextEditingController _imamnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late String subAdminArea;
  late String adminArea;
  late String region;
  late String country;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  LatLng? _initialPosition;
  double lat = 51.5072;
  double lng = 0.1276;
  /* 
  static CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(33.716595, 73.039838),
    zoom: 19,
    tilt: 59.440717697143555,
  );
*/
  late AnimationController controller;
  bool? updatingPrayerTimings = false;
  bool? privacyTerms = false;

  void displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );
  moveToHome(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        changeButton = true;
      });

      await Future.delayed(const Duration(seconds: 5));
      // ignore: use_build_context_synchronously
      await Navigator.pushNamed(context, MyRoutes.homeRoute);
      setState(() {
        changeButton = false;
      });
    }
  }

  moveToLogin(BuildContext context) async {
    Navigator.pushNamed(context, MyRoutes.loginRoute);
    setState(() {
      changeButton = false;
    });
  }

  Future<RegistrationRespose?> attemptSignUp() async {
    RegistrationRespose regResp = RegistrationRespose();
    String uname = _usernameController.text;
    String pwd = _passwordController.text;
    String basicAuth = 'Basic ${base64.encode(utf8.encode('$uname:$pwd'))}';

    var body = {
      'entity_name': _entitynameController.text,
      'sect_id': selectedValue,
      'imam_name': _imamnameController.text,
      'email': _emailController.text,
      'lat': lat.toString(),
      'log': lng.toString(),
      'country': country,
      'subadminarea': subAdminArea,
      'adminarea': adminArea,
      'region': region,
      'updatingprayertimings': updatingPrayerTimings == true ? "1" : "0",
      'unamepwd': base64.encode(utf8.encode('$uname:$pwd'))
    };

    var res = await http.post(Uri.parse('$SERVER_IP/users/user/signup'),
        headers: {
          HttpHeaders.authorizationHeader: basicAuth,
        },
        body: body);

    final responseJson = jsonDecode(res.body);

    if (res.statusCode == 200) {
      if (responseJson["Entity"] != null) {
        responseJson["Entity"];
        // var entity = responseJson["Entity"];
        regResp.title = "Mosque Registration Successful";
        regResp.content =
            "Please signin and update your mosque prayer times. Your account will be verified shortly";
      }
    } else {
      var message = responseJson["message"];
      regResp.title = "Error:Mosque Registration";
      regResp.content = "See Error Below:\n $message";
    }
    return regResp;
  }

  loadSectsList() async {
    var res =
        await http.post(Uri.parse('$SERVER_IP/entities/entity/loadsects'));

    if (res.statusCode == 200) {
      final responseJson = jsonDecode(res.body);
      //lstSects = Sects.fromMap(responseJson["result"]["EntitySects"]);
      List<dynamic> inlstSects = responseJson["EntitySects"];
      for (var element in inlstSects) {
        lstSects.add(Sects.fromMap(element));
      }

      menuItems
          .add(const DropdownMenuItem(value: "0", child: Text("SELECT SECT")));
      for (var element in lstSects) {
        menuItems.add(DropdownMenuItem(
            value: element.sectId.toString(), child: Text(element.sectName)));
      }
      setState(() {
        selectedValue = menuItems.first.value as String;
      });
    }
  }

/*
  loadCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);

    _kGooglePlex = CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 19,
      tilt: 59.440717697143555,
    );
  }
*/
  _launchURL() async {
    Navigator.pushNamed(context, MyRoutes.PrivacyPolicyRoute);
  }

  @override
  void initState() {
    // loadCurrentLocation();
    getUserCurrentPosition();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);

    menuItems.clear();
    loadSectsList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          titleTextStyle: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          title: const Text('Registration'),
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
                  Image.asset(
                    "assets/images/login.png",
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Mosque Registration Form",
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
                          decoration: const InputDecoration(
                              hintText: "Enter Masjid Name",
                              labelText: "Masjid Name",
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                          controller: _entitynameController,
                          onChanged: (value) {
                            // name = value;
                            setState(() {});
                          },
                          validator: (String? value) {
                            if (value != null && value.isEmpty) {
                              return "Masjid name can't be empty";
                            } else if (value!.length < 3) {
                              return "Masjid name can't be less than 3 characters";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        DropdownButtonFormField(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.green, width: 2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.green, width: 2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                            dropdownColor: Colors.white,
                            value: selectedValue,
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedValue = newValue!;
                              });
                            },
                            items: menuItems),
                        TextFormField(
                          decoration: const InputDecoration(
                              hintText: "Enter Imam Name",
                              labelText: "Imam Name",
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                          controller: _imamnameController,
                          onChanged: (value) {
                            //  name = value;
                            setState(() {});
                          },
                          validator: (String? value) {
                            if (value != null && value.isEmpty) {
                              return "Imam name can't be empty";
                            } else if (value!.length < 3) {
                              return "Imam name can't be less than 3 characters long";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                              hintText: "Enter email address",
                              labelText: "Email address",
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                          controller: _emailController,
                          onChanged: (value) {
                            //  name = value;
                            setState(() {});
                          },
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !value.contains('@') ||
                                !value.contains('.')) {
                              return 'Invalid Email';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              hintText:
                                  "Enter User Name (Phone Number) xxx-xxx-xxx-xxxx",
                              labelText: "User Name (Phone Number)",
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                          controller: _usernameController,
                          onChanged: (value) {
                            //  name = value;
                            setState(() {});
                          },
                          validator: (String? value) {
                            if (value != null && value.isEmpty) {
                              return "Username(Phone Number) can't be empty";
                            } else if (value!.length < 12) {
                              return "Username(Phone Number) must be 12 or 13 digit long";
                            } else if (value.length > 13) {
                              return "Username(Phone Number) must be 12 or 13 digit long";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                              hintText: "Enter Password",
                              labelText: "Password",
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green))),
                          controller: _passwordController,
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
                          height: 40,
                        ),
                        CheckboxListTile(
                            value: updatingPrayerTimings,
                            title: const Text(
                                "Using this app to update prayer timings ?",
                                style: TextStyle(color: Colors.green)),
                            onChanged: (value) {
                              updatingPrayerTimings = value;
                            }),
                        const SizedBox(
                          height: 40,
                        ),
                        const Text(
                          "Click on the map to show correct mosque location",
                        ),
                        SafeArea(
                          child: SizedBox(
                            width: MediaQuery.of(context)
                                .size
                                .width, // or use fixed size like 200
                            height: 400,
                            // on below line creating google maps
                            child: GoogleMap(
                              // on below line setting camera position
                              initialCameraPosition: CameraPosition(
                                target: _initialPosition as LatLng,
                                zoom: 14.4746,
                              ),
                              // on below line specifying map type.
                              mapType: MapType.normal,
                              gestureRecognizers: {
                                Factory<OneSequenceGestureRecognizer>(
                                    () => EagerGestureRecognizer())
                              },
                              onTap: (LatLng latLng) async {
                                lat = latLng.latitude;
                                lng = latLng.longitude;
                                BitmapDescriptor markerbitmap =
                                    await BitmapDescriptor.fromAssetImage(
                                  const ImageConfiguration(),
                                  "assets/images/gmapmarker.png",
                                );
                                final List<Placemark> placemarks =
                                    await placemarkFromCoordinates(lat, lng);
                                country = placemarks.first.country as String;
                                region =
                                    '${placemarks.first.street}, ${placemarks.first.subAdministrativeArea} , ${placemarks.first.administrativeArea}';
                                adminArea = placemarks.first.administrativeArea
                                    as String;
                                subAdminArea = placemarks
                                    .first.subAdministrativeArea as String;
                                var marker = Marker(
                                  markerId: const MarkerId('selected'),
                                  icon: markerbitmap,
                                  position: latLng,
                                  infoWindow: InfoWindow(
                                    title: _entitynameController.text == ''
                                        ? 'Masjid Name'
                                        : _entitynameController.text,
                                    snippet: '$region , $country',
                                  ),
                                );
                                setState(() {
                                  markers[const MarkerId('selected')] = marker;
                                });
                              },
                              // on below line setting user location enabled.
                              myLocationEnabled: true,
                              // on below line setting compass enabled.
                              compassEnabled: true,
                              // on below line specifying controller on map complete.
                              onMapCreated: (GoogleMapController controller) {
                                if (!_controller.isCompleted) {
                                  //first calling is false
                                  //call "completer()"
                                  _controller.complete(controller);
                                } else {
                                  //other calling, later is true,
                                  //don't call again completer()
                                }
                                setState(() {});
                              },
                              onLongPress: (LatLng latLng) async {
                                lat = latLng.latitude;
                                lng = latLng.longitude;
                                BitmapDescriptor markerbitmap =
                                    await BitmapDescriptor.fromAssetImage(
                                  const ImageConfiguration(),
                                  "assets/images/gmapmarker.png",
                                );
                                final List<Placemark> placemarks =
                                    await placemarkFromCoordinates(lat, lng);
                                country = placemarks.first.country as String;
                                region =
                                    '${placemarks.first.street}, ${placemarks.first.subAdministrativeArea} , ${placemarks.first.administrativeArea}';
                                adminArea = placemarks.first.administrativeArea
                                    as String;
                                subAdminArea = placemarks
                                    .first.subAdministrativeArea as String;
                                var marker = Marker(
                                  markerId: const MarkerId('selected'),
                                  position: latLng,
                                  icon: markerbitmap,
                                  infoWindow: InfoWindow(
                                    // ignore: unrelated_type_equality_checks
                                    title: _entitynameController.text == ''
                                        ? 'Mosque Name'
                                        : _entitynameController.text,
                                    snippet: '$region , $country',
                                  ),
                                );
                                setState(() {
                                  markers[const MarkerId('selected')] = marker;
                                });
                              },
                              markers: markers.values.toSet(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        CheckboxListTile(
                            value: privacyTerms,
                            title: const Text(
                                "Agree to MasjidLocator Privacy policy?",
                                style: TextStyle(color: Colors.green)),
                            onChanged: (value) {
                              privacyTerms = value;
                              setState(() {
                                privacyTerms = value;
                              });
                            }),
                        privacyTerms!
                            ? const Text('')
                            : const Text(
                                'Please accept the privacy policy to proceed...',
                                style: TextStyle(color: Colors.red)),
                        Container(
                            child: InkWell(
                                onTap: _launchURL,
                                child: const Text("Privacy Policy",
                                    style: TextStyle(color: Colors.blue)))),
                        const SizedBox(
                          height: 40,
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed: (_isLoading && privacyTerms!)
                              ? null
                              : () async {
                                  if (!_formKey.currentState!.validate()) {
                                    setState(() {});
                                  } else {
                                    if (privacyTerms!) {
                                      setState(() => _isLoading = true);
                                      Future.delayed(
                                        const Duration(seconds: 2),
                                        () =>
                                            setState(() => _isLoading = false),
                                      );

                                      var regResp = await attemptSignUp();

                                      displayDialog(context, regResp!.title,
                                          regResp.content);
                                    }
                                  }
                                },
                          label: const Text('SignUp',
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
                              : const Icon(Icons.app_registration_outlined),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  // created method for getting user current location
  getUserCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    lat = position.latitude;
    lng = position.longitude;
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    });
  }

  CameraPosition getUserCurrentLocation() {
    return CameraPosition(
      target: LatLng(lat, lng),
      zoom: 16,
      tilt: 59.440717697143555,
    );
  }
}
