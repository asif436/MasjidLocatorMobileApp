import 'dart:io';

import 'package:salahmaskan/main.dart';
import 'package:salahmaskan/utils/MessageItem.dart';
import 'package:salahmaskan/models/SigninResponse.dart';
import 'package:salahmaskan/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;
  List<Entity> entities = [];
  late Entity? selectedEntity;
  bool isEntitySelected = false;
  LatLng? _initialPosition;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Set<Marker> markerz = {};

  double lat = 51.5072;
  double long = 0.1276;
  String entityImageURL = '';
  String profilerImageURL = '';
  String advertisementImage = '';

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  String selectedCountryValue = 'Select Country';
  List<dynamic> lstCountries = [];
  List<DropdownMenuItem<String>> menuItemsCountries = [];
  String selectedRegionValue = 'Select Region';
  List<DropdownMenuItem<String>> menuItemsRegion = [];
  List<dynamic> lstRegions = [];
  String selectedSubRegionValue = 'Select SubRegion';
  List<DropdownMenuItem<String>> menuItemsSubRegion = [];
  List<dynamic> lstSubRegions = [];
  String entityListings = "Nearby Mosque Listings";

  late int entityId;
  late int entityScheduleId;
  String prayerNameToUpdate = '';
  late String updatedPrayerTime;
  late String updatedTime;
  String farjtimet = '00';
  late String duhurtimet;
  late String asrtimet;
  late String maghribtimet;
  late String ishatimet;
  late String jummatimet;
  late String sunsetTime;

  List<Messages>? entityMessages = [];
  List<MessageItem>? _data;
  String? adminPic;
  String? entityPic;

  @override
  void initState() {
    // Load country list on tab 1
    loadCountryList();
    // Location/position permission
    determinePosition();
    // User current location on the map
    getUserCurrentPosition();
    // Loading entity data for creating markers on the map
    loadEntityDataForMarkers();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.green,
        titleTextStyle: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
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
            icon:
                const Icon(Icons.app_registration_rounded, color: Colors.white),
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
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          if (index == 1) {
            // loadCountryList();
          }
          setState(() {
            currentPageIndex = index;
          });
        },
        backgroundColor: Colors.green,
        indicatorColor: Colors.white,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.directions_car),
            icon: Icon(Icons.directions_car_filled_outlined),
            label: 'Direction',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.list_alt),
            icon: Icon(Icons.list_alt_outlined),
            label: 'List',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.details),
            icon: Icon(Icons.details_outlined),
            label: 'Details',
          ),
        ],
      ),
      body: <Widget>[
        _initialPosition == null
            ? Center(
                child: Text(
                  'loading map..',
                  style: TextStyle(
                      fontFamily: 'Avenir-Medium', color: Colors.grey[400]),
                ),
              )
            : SafeArea(
                // on below line creating google maps
                child: GoogleMap(
                  // on below line setting camera position
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition as LatLng,
                    zoom: 14.4746,
                  ),
                  // on below line specifying map type.
                  mapType: MapType.normal,
                  // on below line setting user location enabled.
                  myLocationEnabled: true,
                  // on below line setting compass enabled.
                  compassEnabled: true,
                  // on below line specifying controller on map complete.
                  onMapCreated: (GoogleMapController controller) {
                    _initialPosition = LatLng(lat, long);
                    if (!_controller.isCompleted) {
                      //first calling is false
                      //call "completer()"
                      _controller.complete(controller);
                    } else {
                      //other calling, later is true,
                      //don't call again completer()
                    }
                    setState(() {
                      _initialPosition = LatLng(lat, long);
                      markers.values.toSet();
                    });
                  },
                  onLongPress: (LatLng latLng) {
                    setState(() {});
                  },
                  markers: markerz,
                ),
              ),
        entities.isEmpty
            ? Column(children: <Widget>[
                Image.asset(
                  "assets/images/favicon.png",
                  fit: BoxFit.cover,
                  height: 140,
                  width: 140,
                ),
                const Center(
                    child: Padding(
                        padding: EdgeInsets.all(
                            15), //apply padding to all four sides
                        child: Text(
                          '\n\nNo mosque data is available for your area. Request your local mosque to download this Mobile App and signup free to display salah timings for public',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ))),
                Container(
                    margin: const EdgeInsets.all(10),
                    child: Image(
                      image: NetworkImage(advertisementImage),
                    ))
              ])
            : Column(children: <Widget>[
                ExpansionTile(
                    title: const Text("Mosque Search Criteria"), //header title
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 10),
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
                              value: selectedCountryValue,
                              onChanged: (String? newValue) {
                                loadAdministrativeList(newValue);
                                selectedCountryValue = newValue!;
                                setState(() {
                                  selectedCountryValue = newValue;
                                });
                              },
                              items: menuItemsCountries),
                          const SizedBox(height: 10),
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
                              value: selectedRegionValue,
                              onChanged: (String? newValue) {
                                selectedRegionValue = newValue!;
                                loadSubAdministrativeList();
                                setState(() {
                                  selectedRegionValue = newValue;
                                });
                              },
                              items: menuItemsRegion),
                          const SizedBox(height: 10),
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
                              value: selectedSubRegionValue,
                              onChanged: (String? newValue) {
                                selectedSubRegionValue = newValue!;
                                loadEntityListing();
                                setState(() {
                                  //  selectedSubRegionValue = newValue!;
                                });
                              },
                              items: menuItemsSubRegion),
                          const SizedBox(height: 10),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green),
                              onPressed: () {
                                entityListings = "Mosques Search Result";
                                entities = [];
                                markers = <MarkerId, Marker>{};
                                loadEntityDataForMarkers();
                              },
                              child: const Text('Search Mosques')),
                          const SizedBox(height: 10)
                        ],
                      )
                    ]),
                Text(entityListings,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                        fontWeight: FontWeight.bold)),
                Expanded(
                  //        <-- Use Expanded
                  child: ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: markerz.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          height: 50,
                          color: Colors.green[300],
                          child: RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16),
                                    text:
                                        '${entities[index].entity_Id.toString()} '),
                                TextSpan(
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 16),
                                    text:
                                        '- ${entities[index].entity_name.toString()} - ${entities[index].sect!.sectName}',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        // set selectedEntity selectedEntityData operation
                                        selectedEntityData(entities[index]
                                            .entity_Id
                                            .toString());
                                      }),
                              ],
                            ),
                          ));
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  ),
                ),
                Container(
                    margin: const EdgeInsets.all(10),
                    child: Image(
                      image: NetworkImage(advertisementImage),
                    ))
              ]),
        !isEntitySelected
            ? Column(children: <Widget>[
                Container(
                    margin: const EdgeInsets.all(10),
                    child: const Image(
                      image: NetworkImage(
                          'http://masjidlocators.com/DillySolutions.png'),
                    )),
                Image.asset(
                  "assets/images/favicon.png",
                  fit: BoxFit.cover,
                  height: 140,
                  width: 140,
                ),
                const Center(
                    child: Padding(
                        padding: EdgeInsets.all(
                            15), //apply padding to all four sides
                        child: Text(
                          '\n\nPlease select a mosque from the list tab at the bottom to see details. \n\nIf no mosque data is available for your area, request your local mosque to download this Mobile App and signup free to display salah timings for public',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )))
              ])
            : SingleChildScrollView(
                child: Column(children: <Widget>[
                Container(
                    margin: const EdgeInsets.all(10),
                    child: Image(
                      image: NetworkImage(advertisementImage),
                    )),
                const SizedBox(
                  height: 10,
                ),
                Row(children: <Widget>[
                  const SizedBox(width: 10),
                  entityImageURL == '' || entityImageURL == 'undefined'
                      ? const CircleAvatar(
                          foregroundImage:
                              AssetImage("assets/images/favicon.png"),
                          radius: 30)
                      : CircleAvatar(
                          foregroundImage:
                              NetworkImage(baseURL + entityImageURL),
                          radius: 30),
                  const SizedBox(width: 20),
                  Text('${selectedEntity!.entity_name}')
                ]),
                const SizedBox(
                  height: 10,
                ),
                Row(children: <Widget>[
                  const SizedBox(width: 10),
                  profilerImageURL == '' || profilerImageURL == 'undefined'
                      ? const CircleAvatar(
                          foregroundImage:
                              AssetImage("assets/images/default_profile.png"),
                          radius: 30)
                      : CircleAvatar(
                          foregroundImage:
                              NetworkImage(baseURL + profilerImageURL),
                          radius: 30),
                  const SizedBox(width: 20),
                  Text('${selectedEntity!.user!.profile!.profilerName}'),
                ]),
                const SizedBox(
                  height: 20,
                ),
                Row(children: <Widget>[
                  const SizedBox(width: 20),
                  const Text('Are Prayer Timings Accurate ?',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  selectedEntity!.entitySchedule!.arrangment_for_ittikaf == 1
                      ? const Text(' Yes',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18))
                      : const Text(' No',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                ]),
                const SizedBox(
                  height: 20,
                ),
                const Center(
                    child: Column(children: [
                  Text('Prayer Timings',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ])),
                const SizedBox(
                  height: 20,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 80,
                      ),
                      const Expanded(
                          flex: 2, // 20%
                          child: Text(
                            "Fajr",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      Expanded(
                          child: Text(
                        farjtimet,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      )),
                      const SizedBox(
                        width: 60,
                      )
                    ]),
                const SizedBox(
                  height: 10,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 80,
                      ),
                      const Expanded(
                        flex: 2, // 20%
                        child: Text(
                          "Duhur",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                          child: Text(
                        duhurtimet,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      )),
                      const SizedBox(
                        width: 60,
                      )
                    ]),
                const SizedBox(
                  height: 10,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 80,
                      ),
                      const Expanded(
                        flex: 2, // 20%
                        child: Text(
                          "Asr",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                          child: Text(
                        asrtimet,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      )),
                      const SizedBox(
                        width: 60,
                      )
                    ]),
                const SizedBox(
                  height: 10,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 80,
                      ),
                      const Expanded(
                        flex: 2, // 20%
                        child: Text(
                          "Maghrib",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                          child: Text(
                        maghribtimet,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      )),
                      const SizedBox(
                        width: 60,
                      )
                    ]),
                const SizedBox(
                  height: 10,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 80,
                      ),
                      const Expanded(
                        flex: 2, // 20%
                        child: Text(
                          "Isha",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                          child: Text(
                        ishatimet,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      )),
                      const SizedBox(
                        width: 60,
                      )
                    ]),
                const SizedBox(
                  height: 10,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 80,
                      ),
                      const Expanded(
                        flex: 2, // 20%
                        child: Text(
                          "Jumma",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.green,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                          child: Text(
                        jummatimet,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      )),
                      const SizedBox(
                        width: 60,
                      )
                    ]),
                entityMessages!.isNotEmpty
                    ? Container(
                        child: _buildPanel(),
                      )
                    : const Center(
                        child: Padding(
                            padding: EdgeInsets.all(
                                15), //apply padding to all four sides
                            child: Text(
                              'There are no messages to display',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            )))
              ]))
      ][currentPageIndex],
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data![index].isExpanded = isExpanded;
        });
      },
      children: _data!.map<ExpansionPanel>((MessageItem item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: ListTile(
            title: Text(item.expandedValue),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }

  Future<Position> determinePosition() async {
    LocationPermission permission;
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);

//    Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    });

    getUserCurrentLocation();
    // loading entity data for creating markers on the map
    loadEntityDataForMarkers();

    return await Geolocator.getCurrentPosition();
  }

  // created method for getting user current location
  getUserCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    lat = position.latitude;
    long = position.longitude;
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    });
  }

  CameraPosition getUserCurrentLocation() {
    return CameraPosition(
      target: LatLng(lat, long),
      zoom: 16,
      tilt: 59.440717697143555,
    );
  }

  loadMaghribPrayerTime() async {
    var timezone;
    var now = DateTime.now();
    try {
      final qParameters = {
        'latitude': entities[0].getLat().toString(),
        'longitude': entities[0].getLog().toString(),
      };
      final url =
          Uri.https('api.geotimezone.com', '/public/timezone', qParameters);
      final resp = await http.get(url, headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      });
      final respJson = jsonDecode(resp.body);
      timezone = respJson["iana_timezone"];

      // final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formatted = formatter.format(now);

      final queryParameters = {
        'lat': entities[0].getLat().toString(),
        'lng': entities[0].getLog().toString(),
        'tzid': timezone,
        'date': formatted
      };

      final uri = Uri.https('api.sunrise-sunset.org', '/json', queryParameters);
      final response = await http.get(uri, headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      });
      final responseJson = jsonDecode(response.body);
      var timewithoutdate = responseJson["results"]["sunset"];

      sunsetTime =
          '${DateFormat.yMd().format(now).toString()} $timewithoutdate';
    } catch (e) {
      sunsetTime = 'Error';
    }
  }

  loadEntityDataForMarkers() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low);

    var body = {
      'latitude': '${position.latitude}',
      'longitude': '${position.longitude}',
      'distance': '0.05'
    };
    final response = await http.post(
      Uri.parse('$SERVER_IP/entities/entity/homepagedate'),
      body: body,
    );

    final responseJson = jsonDecode(response.body);
    if (responseJson["Advertisement"] == null) {
      advertisementImage = 'http://masjidlocators.com/DillySolutions.png';
    } else {
      advertisementImage = responseJson["Advertisement"]['image_url'];
    }

    if (responseJson["Entities"] != null) {
      responseJson["Entities"]
          .forEach((element) => {generateEntities(element)});
      addmarks();
    }
    // Load sunset maghrib time
    loadMaghribPrayerTime();

    setState(() {
      markers.values.toSet();
    });
  }

  generateEntities(e) {
    var entity = Entity.fromMap(e);
    entities.add(entity);
  }

  addmarks() async {
    BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(),
      "assets/images/gmapmarker.png",
    );
    for (int i = 0; i < entities.length; i++) {
      var markerz2 = Marker(
        markerId: MarkerId(entities[i].entity_Id.toString()),
        position: LatLng(entities[i].lat ?? 0.0, entities[i].log ?? 0.0),
        icon: markerbitmap,
        infoWindow: InfoWindow(
          title:
              '${entities[i].entity_Id.toString()} -  ${entities[i].entity_name.toString()}',
          snippet:
              'Fajr ${entities[i].entitySchedule!.Fajr!.substring(0, 5)} ; Duhr ${entities[i].entitySchedule!.Duhur!.substring(0, 5)} ; Asr ${entities[i].entitySchedule!.Asr!.substring(0, 5)}  ; Isha: ${entities[i].entitySchedule!.Isha!.substring(0, 5)}',
        ),
      );

      markers[MarkerId('$i h')] = markerz2;
    }
    markers.values.toSet();
    setState(() {
      markerz = markers.values.toSet();
    });
  }

  Future<void> selectedEntityData(String entityId) async {
    var body = {'entityid': entityId.toString()};

    var res = await http.post(
        Uri.parse('$SERVER_IP/entities/entity/findentitydetails'),
        body: body);

    if (res.statusCode == 200) {
      final responseJson = jsonDecode(res.body);
      selectedEntity = Entity.fromMap(responseJson["Entity"][0]);
      var messagesMap = jsonDecode(res.body)['Messages'];

      if (messagesMap != null) {
        entityMessages = [];
        messagesMap.forEach((element) => {generateMessages(element)});
      }
      _data = await generateMessageList();
      setState(() {
        if (selectedEntity!.entityImageURL != null) {
          entityImageURL = selectedEntity!.entityImageURL as String;
        } else {
          entityImageURL = '';
        }

        if (selectedEntity!.user!.profile!.profilerImageURL != null) {
          profilerImageURL =
              selectedEntity!.user!.profile!.profilerImageURL as String;
        } else {
          profilerImageURL = '';
        }

        isEntitySelected = true;
        currentPageIndex = 2;
        farjtimet = selectedEntity!.entitySchedule!.Fajr!.substring(0, 5);
        duhurtimet = selectedEntity!.entitySchedule!.Duhur!.substring(0, 5);
        asrtimet = selectedEntity!.entitySchedule!.Asr!.substring(0, 5);
        ishatimet = selectedEntity!.entitySchedule!.Isha!.substring(0, 5);
        jummatimet = selectedEntity!.entitySchedule!.Jumma!.substring(0, 5);

        if (sunsetTime == 'Error') {
          loadMaghribPrayerTime();
        }
        var maghribTime = DateFormat('MM/dd/yyyyy hh:mm:ss').parse(sunsetTime);

        maghribTime = maghribTime.add(Duration(
            minutes:
                selectedEntity!.entitySchedule!.arrangement_for_Jamat as int));
        if (maghribTime.minute < 10) {
          maghribtimet = '0${maghribTime.hour}:0${maghribTime.minute}';
        } else {
          maghribtimet = '0${maghribTime.hour}:${maghribTime.minute}';
        }
      });
    }
  }

  loadCountryList() async {
    var res = await http
        .post(Uri.parse('$SERVER_IP/entities/entity/loaddistinctcountrylist'));

    if (res.statusCode == 200) {
      final responseJson = jsonDecode(res.body);

      List<dynamic> inlstCountries = responseJson["Entities"];
      for (var element in inlstCountries) {
        lstCountries.add(Entity.fromMap(element));
      }

      menuItemsCountries.add(const DropdownMenuItem(
          value: "SELECT SECT", child: Text("SELECT SECT")));
      for (var element in lstCountries) {
        menuItemsCountries.add(DropdownMenuItem(
            value: element.country, child: Text(element.country)));
      }
      setState(() {
        selectedCountryValue = menuItemsCountries.first.value as String;
      });
    }
  }

  loadAdministrativeList(inCountry) async {
    var body = {'country': inCountry};
    var res = await http.post(
        Uri.parse(
            '$SERVER_IP/entities/entity/loaddistinctadministrativeareabycountryname'),
        body: body);

    if (res.statusCode == 200) {
      final responseJson = jsonDecode(res.body);
      // Reinitialize area dropdown
      lstRegions = [];
      menuItemsRegion = [];

      // Reload area dropdown with updated values
      List<dynamic> inlstRegions = responseJson["Entities"];
      for (var element in inlstRegions) {
        lstRegions.add(Entity.fromMap(element));
      }

      menuItemsRegion.add(const DropdownMenuItem(
          value: "SELECT REGION", child: Text("SELECT REGION")));
      for (var element in lstRegions) {
        menuItemsRegion.add(DropdownMenuItem(
            value: element.adminArea, child: Text(element.adminArea)));
      }
      setState(() {
        selectedRegionValue = menuItemsRegion.first.value as String;
        menuItemsRegion;
      });
    }
  }

  loadSubAdministrativeList() async {
    var body = {
      'country': selectedCountryValue,
      'adminarea': selectedRegionValue
    };
    var res = await http.post(
        Uri.parse(
            '$SERVER_IP/entities/entity/loadsubadminiareabycountrynameandadminarea'),
        body: body);

    if (res.statusCode == 200) {
      final responseJson = jsonDecode(res.body);

      // Reinitialize sub area dropdowns
      lstSubRegions = [];
      menuItemsSubRegion = [];

      // Reload sub area dropdown with updated values.
      List<dynamic> inlstRegions = responseJson["Entities"];
      for (var element in inlstRegions) {
        lstSubRegions.add(Entity.fromMap(element));
      }

      menuItemsSubRegion.add(const DropdownMenuItem(
          value: "SELECT CITY", child: Text("SELECT CITY")));
      for (var element in lstSubRegions) {
        menuItemsSubRegion.add(DropdownMenuItem(
            value: element.subAdminArea, child: Text(element.subAdminArea)));
      }
      setState(() {
        selectedSubRegionValue = menuItemsSubRegion.first.value as String;
        menuItemsSubRegion;
      });
    }
  }

  loadEntityListing() async {
    var body = {
      'country': selectedCountryValue,
      'adminarea': selectedRegionValue,
      'subadminarea': selectedSubRegionValue
    };
    var res = await http.post(
        Uri.parse(
            '$SERVER_IP/entities/entity/entitiesbycountryregionsubregion'),
        body: body);

    if (res.statusCode == 200) {
      final responseJson = jsonDecode(res.body);

      entities = [];
      markers = <MarkerId, Marker>{};
      entityListings = "Mosque Listings From Above Selection";

      if (responseJson["Advertisement"] == null) {
        advertisementImage = 'http://masjidlocators.com/DillySolutions.png';
      } else {
        var advertisement = responseJson["Advertisement"];
        advertisementImage = advertisement['image_url'];
      }

//      advertisementImage = responseJson["Advertisement"].image_url;
      if (responseJson["Entities"] != null) {
        responseJson["Entities"]
            .forEach((element) => {generateEntities(element)});
        addmarks();
        sunsetTime = '';
        loadMaghribPrayerTime();
      }
      setState(() {});
    }
  }

  generateMessages(element) {
    Messages aMsg = Messages.fromMap(element);
    entityMessages!.add(aMsg);
  }

  Future<List<MessageItem>> generateMessageList() async {
    return List<MessageItem>.generate(entityMessages!.length, (int index) {
      var dateTime = DateTime.parse(entityMessages![index].msgDate as String);
      var formate1 = "${dateTime.day}-${dateTime.month}-${dateTime.year}";
      return MessageItem(
          headerValue: '${entityMessages![index].msgSubject} , Date: $formate1',
          expandedValue: '${entityMessages![index].msgBody}',
          msgId: entityMessages![index].msgId as int);
    });
  }
}
