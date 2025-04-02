import 'dart:io';
import 'package:salahmaskan/utils/MessageItem.dart';
import 'package:salahmaskan/utils/PrayerName.dart';
import 'package:salahmaskan/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:salahmaskan/models/SigninResponse.dart';
import 'package:http/http.dart' as http;
import 'package:salahmaskan/main.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:image/image.dart' as img;
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SecureHome extends StatefulWidget {
  final Entity entity;

  const SecureHome({Key? key, required this.entity}) : super(key: key);

  @override
  State<SecureHome> createState() => _SecureHomeState();
}

class _SecureHomeState extends State<SecureHome> {
  double lat = 51.5072;
  double long = 0.1276;
  LatLng? _initialPosition;

  int currentPageIndex = 0;
  final _messageformKey = GlobalKey<FormState>();
  final _formKey = GlobalKey<FormState>();
  final _imamFormKey = GlobalKey<FormState>();
  final _resetpasswordformKey = GlobalKey<FormState>();
  // create message fields
  final TextEditingController _mSubjectController = TextEditingController();
  final TextEditingController _mBodyController = TextEditingController();

  // Update bankAccount form fields
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _accountTitleController = TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();

  // Update Imam form fields
  final TextEditingController _imamNameController = TextEditingController();
  final TextEditingController _imamEmailController = TextEditingController();
  final TextEditingController _imamPhoneController = TextEditingController();

  // Reset password form fields
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confnewPasswordController =
      TextEditingController();
  String passwordUpdateRespMsg = '';

  SecureHomeData? shd;
  // Needed on schedule tab
  Entity? entity;
  String? advertisementImage = '';
  EntitySchedule? esm;
  late int entityId;
  late int entityScheduleId;
  String prayerNameToUpdate = '';
  late String updatedPrayerTime;
  late String updatedTime;
  String farjtimet = '00';
  late String duhurtimet;
  late String asrtimet;
  late String ishatimet;
  late String jummatimet;
  String? maghribtimet;
  String? sunsetTime;

  final TextEditingController _maghribOffsetController =
      TextEditingController();

  late String jwtToken;
  TimeOfDay fajrTime = TimeOfDay.now();
  TimeOfDay duhurTime = TimeOfDay.now();
  TimeOfDay asrTime = TimeOfDay.now();
  TimeOfDay ishaTime = TimeOfDay.now();
  TimeOfDay jummaTime = TimeOfDay.now();

  // needed on messages tab
  List<Messages>? entityMessages = [];
  bool? createMessage = false;
  bool? isEntityMessages = false;

  // for entity and entity profile pictures
  late XFile? _selectedEntityFile;
  late XFile? _selectedEntityAdminFile;

  List<MessageItem>? _data;

  @override
  void initState() {
    // Location/position permission
    determinePosition();
    // User current location on the map
    getUserCurrentPosition();
    loadSunSetTime();

    super.initState();
  }

  uploadCompressedFile(uploadedfile, entityOrAdmin) {
    var allowedExtensions = ['.jpeg', '.jpg', '.png', '.gif'];
    File file = File(uploadedfile!.path);
    final extension = p.extension(uploadedfile!.path);
    img.Image? image;

    if (allowedExtensions.contains(extension)) {
      image = img.decodeImage(file.readAsBytesSync());

      int width;
      int height;

      if (image!.width > image.height) {
        width = 400;
        height = (image.height / image.width * 400).round();
      } else {
        height = 400;
        width = (image.width / image.height * 400).round();
      }
      img.Image resizedImage =
          img.copyResize(image, width: width, height: height);

      // Compress the image with JPEG format
//      List<int> compressedBytes =
      img.encodeJpg(resizedImage, quality: 85); // Adjust quality as needed

      final png = img.encodeJpg(resizedImage);

      // Save the compressed image to a file
      File compressedFile = File(
          uploadedfile!.path.replaceFirst(extension, '_compressed$extension'));

      compressedFile.writeAsBytesSync(png);

      if (entityOrAdmin == 'Entity') {
        _selectedEntityFile = XFile(compressedFile.path);
      } else {
        _selectedEntityAdminFile = XFile(compressedFile.path);
      }
    } else {
      if (entityOrAdmin == 'Entity') {
        _selectedEntityFile = null;
      } else {
        _selectedEntityAdminFile = null;
      }
    }
  }

  Future<XFile?> getEntityFile() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
    /*
    return await ImagePicker.platform
        .getImageFromSource(source: ImageSource.gallery);
  */
  }

  Future<XFile?> getEntityAdminFile() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
    /*
    return await ImagePicker.platform
        .getImageFromSource(source: ImageSource.gallery);
  */
  }

  Future<void> _uploadEntityFile() async {
    if (_selectedEntityFile == null) {
      // Handle case when no file is selected
      return;
    }

    // Read the file as bytes
    List<int> imageBytes = await _selectedEntityFile!.readAsBytes();

    // Create the multipart request
    final request = http.MultipartRequest(
        'POST', Uri.parse('$SERVER_IP/entities/entity/upload'));
    final httpimage = http.MultipartFile.fromBytes('file', imageBytes,
        filename: _selectedEntityFile!.name);
    // Add the base64-encoded image as a field

    request.files.add(httpimage);
    request.fields['entityid'] = entityId.toString();
    request.fields['photoOf'] = "Entity";
    request.fields['token'] = await storage.read(key: "jwtToken") as String;
    // Send the request
    try {
      final response = await request.send();
      // Handle the response, e.g., print status code
      print('Server responded with ${response.statusCode}');
    } catch (error) {
      // Handle any errors that occurred during the request
      print('Error uploading file: $error');
    }
  }

  Future<void> _uploadEntityAdminFile() async {
    if (_selectedEntityAdminFile == null) {
      // Handle case when no file is selected
      return;
    }

    // Read the file as bytes
    List<int> imageBytes = await _selectedEntityAdminFile!.readAsBytes();

    // Create the multipart request
    final request = http.MultipartRequest(
        'POST', Uri.parse('$SERVER_IP/entities/entity/upload'));
    final httpimage = http.MultipartFile.fromBytes('file', imageBytes,
        filename: _selectedEntityAdminFile!.name);

    // Add the base64-encoded image as a field
    request.files.add(httpimage);
    request.fields['entityid'] = entity!.user!.profile!.profilesId.toString();
    request.fields['photoOf'] = "Admin";
    request.fields['token'] = await storage.read(key: "jwtToken") as String;
    // Send the request
    try {
      final response = await request.send();
      // Handle the response, e.g., print status code
      print('Server responded with ${response.statusCode}');
    } catch (error) {
      // Handle any errors that occurred during the request
      print('Error uploading file: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    loadSunSetTime();
    shd = ModalRoute.of(context)!.settings.arguments as SecureHomeData;
    //entity = ModalRoute.of(context)!.settings.arguments as Entity;
    entity = shd!.entity;
    advertisementImage = shd!.advertisementImage;
    if (esm != null) {
      entity!.entitySchedule = esm;
    }
    entityId = entity!.entity_Id as int;

    entityScheduleId = entity!.entitySchedule!.entity_schedule_id as int;
    int fhtime = int.parse(entity!.entitySchedule!.Fajr!.substring(0, 2));
    int fmtime = int.parse(entity!.entitySchedule!.Fajr!.substring(3, 5));
    TimeOfDay fajrTime = TimeOfDay(hour: fhtime, minute: fmtime);
    farjtimet = entity!.entitySchedule!.Fajr!.substring(0, 5);

    int dhtime = int.parse(entity!.entitySchedule!.Duhur!.substring(0, 2));
    int dmtime = int.parse(entity!.entitySchedule!.Duhur!.substring(3, 5));
    TimeOfDay duhurTime = TimeOfDay(hour: dhtime, minute: dmtime);
    duhurtimet = entity!.entitySchedule!.Duhur!.substring(0, 5);

    int ahtime = int.parse(entity!.entitySchedule!.Asr!.substring(0, 2));
    int amtime = int.parse(entity!.entitySchedule!.Asr!.substring(3, 5));
    TimeOfDay asrTime = TimeOfDay(hour: ahtime, minute: amtime);
    asrtimet = entity!.entitySchedule!.Asr!.substring(0, 5);

    int ihtime = int.parse(entity!.entitySchedule!.Isha!.substring(0, 2));
    int imtime = int.parse(entity!.entitySchedule!.Isha!.substring(3, 5));
    TimeOfDay ishaTime = TimeOfDay(hour: ihtime, minute: imtime);
    ishatimet = entity!.entitySchedule!.Isha!.substring(0, 5);

    int jhtime = int.parse(entity!.entitySchedule!.Jumma!.substring(0, 2));
    int jmtime = int.parse(entity!.entitySchedule!.Jumma!.substring(3, 5));
    TimeOfDay jummaTime = TimeOfDay(hour: jhtime, minute: jmtime);
    jummatimet = entity!.entitySchedule!.Jumma!.substring(0, 5);
/*
    var maghribTime =
        DateFormat('MM/dd/yyyyy hh:mm:ss').parse(sunsetTime as String);
    maghribTime = maghribTime.add(Duration(
        minutes: entity!.entitySchedule!.arrangement_for_Jamat as int));
    maghribtimet = '0${maghribTime.hour}:${maghribTime.minute}';
*/
    String? adminPic;
    String? entityPic;

    if (entity!.entityImageURL != null) {
      entityPic = entity!.entityImageURL;
    }

    if (entity!.user!.profile!.profilerImageURL != null) {
      adminPic = entity!.user!.profile!.profilerImageURL;
    }

    _bankNameController.text = entity!.donation!.bankName;
    _accountTitleController.text = entity!.donation!.accountHolderName;
    _accountNumberController.text = entity!.donation!.accountNumber;

    // Update bankAccount form fields
    _imamNameController.text = entity!.user!.profile!.profilerName as String;
    _imamEmailController.text = entity!.user!.profile!.profilerEmail as String;
    _imamPhoneController.text = entity!.user!.profile!.profilerPhone as String;

    //  loadEntityMessagesByEntityId(entityId);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Secure Home'),
        backgroundColor: Colors.green,
        titleTextStyle: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        actions: <Widget>[
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
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.green,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                padding: EdgeInsets.zero,
                child: UserAccountsDrawerHeader(
                  accountName:
                      Text(entity!.user!.profile!.profilerName as String),
                  accountEmail:
                      Text(entity!.user!.profile!.profilerEmail as String),
                  currentAccountPicture: adminPic == null
                      ? const CircleAvatar(
                          foregroundImage:
                              AssetImage("assets/images/default_profile.png"),
                          radius: 30)
                      : CircleAvatar(
                          foregroundImage: NetworkImage(baseURL + adminPic),
                          radius: 30),
                ),
              ),
              ListTile(
                leading: const Icon(
                  CupertinoIcons.phone,
                  color: Colors.white,
                ),
                title: const Text(
                  "Phone",
                  textScaleFactor: 1.2,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                subtitle: Text(entity!.user!.profile!.profilerPhone.toString()),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          if (index == 1) {
            loadEntityMessagesByEntityId(entityId);
//     entityMessages = loadEntityMessagesByEntityId(entity!.entity_Id);
            _data = generateMessageList();
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
            selectedIcon: Icon(Icons.schedule_rounded),
            icon: Icon(Icons.schedule_outlined),
            label: 'Schedule',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.message_rounded),
            icon: Icon(Icons.message_outlined),
            label: 'Messages',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.details),
            icon: Icon(Icons.details_outlined),
            label: 'Details',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.verified_user),
            icon: Icon(Icons.verified_outlined),
            label: 'Profile',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.delete),
            icon: Icon(Icons.delete_forever_outlined),
            label: 'Delete',
          )
        ],
      ),
      body: <Widget>[
        SingleChildScrollView(
            child: Column(children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          Image(
            image: NetworkImage(advertisementImage as String),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text('Update Prayer Timings',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          const SizedBox(
            height: 20,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                  flex: 2, // 20%
                  child: Column(children: [
                    Text(
                      "Fajr",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    )
                  ]),
                ),
                Expanded(
                    flex: 2, // 20%
                    child: Column(children: [
                      Text(
                        farjtimet,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      )
                    ])),
                Expanded(
                    flex: 2, // 20%
                    child: Column(children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white),
                          onPressed: () async {
                            await showTimePicker(
                                    context: context, initialTime: fajrTime)
                                .then((value) {
                              if (value != null) {
                                this.fajrTime = TimeOfDay(
                                    hour: value.hour, minute: value.minute);
                                updatedPrayerTime =
                                    '${value.hour}:${value.minute}:00';
                                prayerNameToUpdate = PrayerName.Fajr.name;
                                updatePrayerTimeToDB();
                              }
                            });
                          },
                          child: const Text('Update'))
                    ])),
              ]),
          const SizedBox(
            height: 10,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                    flex: 2, // 20%
                    child: Column(children: [
                      Text(
                        "Duhur",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      )
                    ])),
                Expanded(
                    flex: 2, // 20%
                    child: Column(children: [
                      Text(
                        duhurtimet,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      )
                    ])),
                Expanded(
                    flex: 2, // 20%
                    child: Column(children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white),
                          onPressed: () async {
                            await showTimePicker(
                                    context: context, initialTime: duhurTime)
                                .then((value) {
                              if (value != null) {
                                this.duhurTime = TimeOfDay(
                                    hour: value.hour, minute: value.minute);
                                updatedPrayerTime =
                                    '${value.hour}:${value.minute}:00';
                                prayerNameToUpdate = PrayerName.Duhur.name;
                                updatePrayerTimeToDB();
                              }
                            });
                          },
                          child: const Text('Update'))
                    ])),
              ]),
          const SizedBox(
            height: 10,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                    flex: 2, // 20%
                    child: Column(children: [
                      Text(
                        "Asr",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      )
                    ])),
                Expanded(
                    flex: 2, // 20%
                    child: Column(children: [
                      Text(
                        asrtimet,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      )
                    ])),
                Expanded(
                    flex: 2, // 20%
                    child: Column(children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white),
                          onPressed: () async {
                            await showTimePicker(
                                    context: context, initialTime: asrTime)
                                .then((value) {
                              if (value != null) {
                                this.asrTime = TimeOfDay(
                                    hour: value.hour, minute: value.minute);
                                updatedPrayerTime =
                                    '${value.hour}:${value.minute}:00';
                                prayerNameToUpdate = PrayerName.Asr.name;
                                updatePrayerTimeToDB();
                              }
                            });
                          },
                          child: const Text('Update'))
                    ])),
              ]),
          const SizedBox(
            height: 10,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                    flex: 2, // 20%
                    child: Column(children: [
                      Text(
                        "Isha",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      )
                    ])),
                Expanded(
                    flex: 2, // 20%
                    child: Column(children: [
                      Text(
                        ishatimet,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      )
                    ])),
                Expanded(
                    flex: 2, // 20%
                    child: Column(children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white),
                          onPressed: () async {
                            await showTimePicker(
                                    context: context, initialTime: ishaTime)
                                .then((value) {
                              if (value != null) {
                                this.ishaTime = TimeOfDay(
                                    hour: value.hour, minute: value.minute);
                                updatedPrayerTime =
                                    '${value.hour}:${value.minute}:00';
                                prayerNameToUpdate = PrayerName.Isha.name;
                                updatePrayerTimeToDB();
                              }
                            });
                          },
                          child: const Text('Update'))
                    ])),
              ]),
          const SizedBox(
            height: 10,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                    flex: 2, // 20%
                    child: Column(children: [
                      Text(
                        "Jumma",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      )
                    ])),
                Expanded(
                    flex: 2, // 20%
                    child: Column(children: [
                      Text(
                        jummatimet,
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      )
                    ])),
                Expanded(
                    flex: 2, // 20%
                    child: Column(children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white),
                          onPressed: () async {
                            await showTimePicker(
                                    context: context, initialTime: jummaTime)
                                .then((value) {
                              if (value != null) {
                                this.jummaTime = TimeOfDay(
                                    hour: value.hour, minute: value.minute);
                                updatedPrayerTime =
                                    '${value.hour}:${value.minute}:00';
                                prayerNameToUpdate = PrayerName.Jumma.name;
                                updatePrayerTimeToDB();
                              }
                            });
                          },
                          child: const Text('Update'))
                    ])),
              ]),
          const SizedBox(
            height: 30,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Sunset Time",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                ),
                FutureBuilder(
                  builder: (ctx, snapshot) {
                    // Checking if future is resolved or not
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If we got an error
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            '${snapshot.error} occurred',
                            style: const TextStyle(fontSize: 18),
                          ),
                        );

                        // if we got our data
                      } else if (snapshot.hasData) {
                        // Extracting data from snapshot object
                        final data = snapshot.data as String;

                        return Center(
                          child: Text(
                            data,
                            style: const TextStyle(fontSize: 18),
                          ),
                        );
                      }
                    }

                    // Displaying LoadingSpinner to indicate waiting state
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },

                  // Future that needs to be resolved
                  // inorder to display something on the Canvas
                  future: loadSunSetTime(),
                ),
              ]),
          const SizedBox(
            height: 20,
          ),
          const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Maghrib. Add minutes to Sunset Time",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.bold),
                )
              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Expanded(
                    flex: 2, // 20%
                    child: Column(children: [
                      Text(
                        "+ Mins",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold),
                      )
                    ])),
                Expanded(
                    flex: 2, // 20%
                    child: TextField(
                      keyboardType: TextInputType.number,
                      maxLength: 2,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      controller: _maghribOffsetController,
                      decoration:
                          const InputDecoration(labelText: "Minutes Number"),
                      onChanged: (value) {
                        setState(() {
                          _maghribOffsetController.text = value;
                        });
                      },
                    )),
                Expanded(
                    flex: 2, // 20%
                    child: Column(children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white),
                          onPressed: () async {
                            updateMaghribPrayerOffSetTimeToDB();
                          },
                          child: const Text('Update'))
                    ])),
              ]),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Column(children: [
                  Text(
                    "Maghrib Time",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  )
                ]),
                FutureBuilder(
                  builder: (ctx, snapshot) {
                    // Checking if future is resolved or not
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If we got an error
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            '${snapshot.error} occurred',
                            style: const TextStyle(fontSize: 18),
                          ),
                        );

                        // if we got our data
                      } else if (snapshot.hasData) {
                        // Extracting data from snapshot object
                        final data = snapshot.data as String;

                        return Center(
                          child: Text(
                            data,
                            style: const TextStyle(fontSize: 18),
                          ),
                        );
                      }
                    }

                    // Displaying LoadingSpinner to indicate waiting state
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },

                  // Future that needs to be resolved
                  // inorder to display something on the Canvas
                  future: loadMaghribTime(),
                ),
              ]),
          const SizedBox(
            height: 200,
          ),
        ])),
        Column(children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          const Text('Messages',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            const Text('Create'),
            Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.add),
                  color: Colors.green,
                  alignment: Alignment.topRight,
                  iconSize: 50,
                  onPressed: () {
                    _mSubjectController.text = '';
                    _mBodyController.text = '';
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Create Message"),
                            titleTextStyle: const TextStyle(
                                backgroundColor: Colors.green, fontSize: 20),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Form(
                                  key: _messageformKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                            controller: _mSubjectController,
                                            decoration: const InputDecoration(
                                                hintText:
                                                    "Enter Message Subject",
                                                labelText: "Message Subject"),
                                            validator: (String? value) {
                                              if (value != null &&
                                                  value.isEmpty) {
                                                return "Message subject can't be empty";
                                              }
                                              return null;
                                            }),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                            controller: _mBodyController,
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: null,
                                            decoration: const InputDecoration(
                                                hintText: "Enter Message Body",
                                                labelText: "Message Body"),
                                            validator: (String? value) {
                                              if (value != null &&
                                                  value.isEmpty) {
                                                return "Message Body can't be empty";
                                              }
                                              return null;
                                            }),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          child: const Text("Submit"),
                                          onPressed: () {
                                            if (_messageformKey.currentState!
                                                .validate()) {
                                              _messageformKey.currentState!
                                                  .save();
                                              saveMessageToDB();

                                              Navigator.of(context).pop();
                                            }
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                ))
          ]),
          entityMessages!.isNotEmpty
              ? SingleChildScrollView(
                  child: Container(
                    child: _buildPanel(),
                  ),
                )
              : const Center(
                  child: Padding(
                      padding:
                          EdgeInsets.all(15), //apply padding to all four sides
                      child: Text(
                        'There are no messages to display',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      )))
        ]),
        Column(children: <Widget>[
          Expanded(
              child: SingleChildScrollView(
                  child: Container(
                      padding: const EdgeInsets.all(5.0),
                      child: Column(children: <Widget>[
                        const SizedBox(height: 20), // give it height
                        const Center(
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text('Masjid Details',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20))
                            ])),
                        const SizedBox(height: 10),
                        const Row(children: [
                          SizedBox(width: 10),
                          Text(
                            'Update Masjid photo',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ]),

                        Container(
                            margin: const EdgeInsets.all(10.0),
                            padding: const EdgeInsets.all(1.0),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.green)),
                            child: Row(children: [
                              const SizedBox(width: 10),
                              entityPic == null
                                  ? const CircleAvatar(
                                      foregroundImage: AssetImage(
                                          "assets/images/favicon.png"),
                                      radius: 30)
                                  : CircleAvatar(
                                      foregroundImage:
                                          NetworkImage(baseURL + entityPic),
                                      radius: 30),
                              const SizedBox(width: 20), // give it width
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white),
                                  onPressed: () async {
                                    //upload image from local drive
                                    XFile? file;
                                    await getEntityFile()
                                        .then((value) => file = value);
                                    // compressed the file if its in correct format
                                    // _selectedEntityFile = file;
                                    uploadCompressedFile(file, 'Entity');
                                    setState(() {});
                                  },
                                  child: const Text('Select Pic')),
                              const SizedBox(width: 20), // give it width
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white),
                                  onPressed: _uploadEntityFile,
                                  child: const Text('Upload Pic'))
                            ])),

                        const SizedBox(height: 15),
                        const Row(children: [
                          SizedBox(width: 15),
                          Text(
                            'Bank Account Detail for Donation',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          )
                        ]),
                        const SizedBox(height: 10),
                        ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width - 20),
                            child: Material(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(
                                      color: Colors.green, width: 1),
                                ),
                                child: Form(
                                    key: _formKey,
                                    child: Column(children: [
                                      Container(
                                          margin: const EdgeInsets.all(10.0),
                                          padding: const EdgeInsets.all(1.0),
                                          child: Row(children: [
                                            const SizedBox(width: 5),
                                            SizedBox(
                                                width: 260,
                                                height: 35,
                                                child: TextFormField(
                                                  controller:
                                                      _bankNameController,
                                                  decoration:
                                                      const InputDecoration(
                                                    hintText: "Enter Bank Name",
                                                  ),
                                                  validator: (value) {
                                                    if (value != null &&
                                                        value.isEmpty) {
                                                      return "Bank Name can't be empty";
                                                    }
                                                    return null;
                                                  },
                                                ))
                                          ])),
                                      Container(
                                          margin: const EdgeInsets.all(10.0),
                                          padding: const EdgeInsets.all(1.0),
                                          child: Row(children: [
                                            const SizedBox(width: 10),
                                            SizedBox(
                                                width: 260,
                                                height: 35,
                                                child: TextFormField(
                                                  controller:
                                                      _accountTitleController,
                                                  decoration: const InputDecoration(
                                                      hintText:
                                                          "Enter Account Title"),
                                                  validator: (value) {
                                                    if (value != null &&
                                                        value.isEmpty) {
                                                      return "Account Title can't be empty";
                                                    }
                                                    return null;
                                                  },
                                                ))
                                          ])),
                                      Container(
                                          margin: const EdgeInsets.all(10.0),
                                          padding: const EdgeInsets.all(1.0),
                                          child: Row(children: [
                                            const SizedBox(width: 10),
                                            SizedBox(
                                                width: 260,
                                                height: 35,
                                                child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller:
                                                      _accountNumberController,
                                                  decoration: const InputDecoration(
                                                      hintText:
                                                          "Enter Account Number"),
                                                  validator: (value) {
                                                    if (value != null &&
                                                        value.isEmpty) {
                                                      return "Account Title can't be empty";
                                                    }
                                                    return null;
                                                  },
                                                ))
                                          ])),
                                      Container(
                                          margin: const EdgeInsets.all(10.0),
                                          padding: const EdgeInsets.all(1.0),
                                          child: Row(children: [
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green,
                                                    foregroundColor:
                                                        Colors.white),
                                                onPressed: () {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    _formKey.currentState!
                                                        .save();
                                                    updateBankAccountToDB();
                                                  }
                                                },
                                                child: const Text('Update'))
                                          ]))
                                    ])))),
                      ]))))
        ]),
        Column(children: <Widget>[
          Expanded(
              child: SingleChildScrollView(
                  child: Container(
            padding: const EdgeInsets.all(5.0),
            child: Column(children: <Widget>[
              const SizedBox(height: 20), // give it height
              const Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text('Imam Contact Details',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20))
                  ])),
              const SizedBox(height: 10),

              const Row(children: [
                SizedBox(width: 10),
                Text('Update Imam photo',
                    style: TextStyle(fontWeight: FontWeight.bold))
              ]),
              Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(1.0),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.green)),
                  child: Row(children: [
                    const SizedBox(width: 10),
                    adminPic == null
                        ? const CircleAvatar(
                            foregroundImage:
                                AssetImage("assets/images/default_profile.png"),
                            radius: 30)
                        : CircleAvatar(
                            foregroundImage: NetworkImage(baseURL + adminPic),
                            radius: 30),
                    const SizedBox(width: 20),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white),
                        onPressed: () async {
                          XFile? file;
                          await getEntityAdminFile()
                              .then((value) => file = value);
                          uploadCompressedFile(file, 'Admin');
                          setState(() {});
                        },
                        child: const Text('Select Pic')),
                    const SizedBox(width: 20),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white),
                        onPressed: _uploadEntityAdminFile,
                        child: const Text('Upload Pic'))
                  ])),

              const SizedBox(height: 15),
              const Row(children: [
                SizedBox(width: 15),
                Text(
                  'Imam Contact Information',
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ]),
              const SizedBox(height: 10),
              ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 20),
                  child: Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.green, width: 1),
                      ),
                      child: Form(
                          key: _imamFormKey,
                          child: Column(children: [
                            Container(
                                margin: const EdgeInsets.all(10.0),
                                padding: const EdgeInsets.all(1.0),
                                child: Row(children: [
                                  const SizedBox(width: 5),
                                  SizedBox(
                                      width: 260,
                                      height: 35,
                                      child: TextFormField(
                                        controller: _imamNameController,
                                        decoration: const InputDecoration(
                                          hintText: "Enter Imam Name",
                                        ),
                                        validator: (value) {
                                          if (value != null && value.isEmpty) {
                                            return "Imam Name can't be empty";
                                          }
                                          return null;
                                        },
                                      ))
                                ])),
                            Container(
                                margin: const EdgeInsets.all(10.0),
                                padding: const EdgeInsets.all(1.0),
                                child: Row(children: [
                                  const SizedBox(width: 10),
                                  SizedBox(
                                      width: 260,
                                      height: 35,
                                      child: TextFormField(
                                        controller: _imamEmailController,
                                        decoration: const InputDecoration(
                                            hintText: "Enter Email Address"),
                                        validator: (value) {
                                          if (value != null && value.isEmpty) {
                                            return "Email address can't be empty";
                                          }
                                          return null;
                                        },
                                      ))
                                ])),
                            Container(
                                margin: const EdgeInsets.all(10.0),
                                padding: const EdgeInsets.all(1.0),
                                child: Row(children: [
                                  const SizedBox(width: 10),
                                  SizedBox(
                                      width: 260,
                                      height: 35,
                                      child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        controller: _imamPhoneController,
                                        decoration: const InputDecoration(
                                            hintText: "Enter Phone Number"),
                                        validator: (value) {
                                          if (value != null && value.isEmpty) {
                                            return "Phone number can't be empty";
                                          }
                                          return null;
                                        },
                                      ))
                                ])),
                            Container(
                                margin: const EdgeInsets.all(10.0),
                                padding: const EdgeInsets.all(1.0),
                                child: Row(children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white),
                                      onPressed: () {
                                        if (_imamFormKey.currentState!
                                            .validate()) {
                                          _imamFormKey.currentState!.save();
                                          updateImamProfileToDB();
                                        }
                                      },
                                      child: const Text('Update'))
                                ]))
                          ])))),
              const SizedBox(height: 15),
              const SizedBox(height: 15),
              const Row(children: [
                SizedBox(width: 15),
                Text('Password reset request',
                    style: TextStyle(fontWeight: FontWeight.bold))
              ]),
              const SizedBox(height: 10),
              ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width - 20),
                  child: Material(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.green, width: 1),
                      ),
                      child: Form(
                          key: _resetpasswordformKey,
                          child: Column(children: [
                            Container(
                                margin: const EdgeInsets.all(10.0),
                                padding: const EdgeInsets.all(1.0),
                                child: Row(children: [
                                  const SizedBox(width: 5),
                                  SizedBox(
                                      width: 260,
                                      height: 35,
                                      child: TextFormField(
                                        obscureText: true,
                                        controller: _oldPasswordController,
                                        decoration: const InputDecoration(
                                          hintText: "Enter Old password",
                                        ),
                                        validator: (value) {
                                          if (value != null && value.isEmpty) {
                                            return "password value can't be empty";
                                          } else if (value!.length < 6) {
                                            return "password value must be atleast six characters long";
                                          }
                                          return null;
                                        },
                                      ))
                                ])),
                            Container(
                                margin: const EdgeInsets.all(10.0),
                                padding: const EdgeInsets.all(1.0),
                                child: Row(children: [
                                  const SizedBox(width: 10),
                                  SizedBox(
                                      width: 260,
                                      height: 35,
                                      child: TextFormField(
                                        obscureText: true,
                                        controller: _newPasswordController,
                                        decoration: const InputDecoration(
                                            hintText: "New password value"),
                                        validator: (value) {
                                          if (value != null && value.isEmpty) {
                                            return "New password value can't be empty";
                                          } else if (value!.length < 6) {
                                            return "password value must be atleast six characters long";
                                          }
                                          return null;
                                        },
                                      ))
                                ])),
                            Container(
                                margin: const EdgeInsets.all(10.0),
                                padding: const EdgeInsets.all(1.0),
                                child: Row(children: [
                                  const SizedBox(width: 10),
                                  SizedBox(
                                      width: 260,
                                      height: 35,
                                      child: TextFormField(
                                        obscureText: true,
                                        controller: _confnewPasswordController,
                                        decoration: const InputDecoration(
                                            hintText:
                                                "Confirm New password value"),
                                        validator: (value) {
                                          if (value != null && value.isEmpty) {
                                            return "New password value can't be empty";
                                          } else if (value !=
                                              _newPasswordController.text) {
                                            return "New password and confirm password must be the same";
                                          } else if (value!.length < 6) {
                                            return "password value must be atleast six characters long";
                                          }
                                          return null;
                                        },
                                      ))
                                ])),
                            Container(
                                margin: const EdgeInsets.all(10.0),
                                padding: const EdgeInsets.all(1.0),
                                child: Row(children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white),
                                      onPressed: () {
                                        passwordUpdateRespMsg = '';
                                        if (_resetpasswordformKey.currentState!
                                            .validate()) {
                                          _resetpasswordformKey.currentState!
                                              .save();
                                          resetUserPassword();
                                          //  Navigator.of(context).pop();
                                        }
                                      },
                                      child: const Text('Update Password'))
                                ])),
                            Text(passwordUpdateRespMsg),
                            const SizedBox(height: 200),
                          ]))))
            ]),
          )))
        ]),
        Column(children: <Widget>[
          Expanded(
              child: Column(children: <Widget>[
            const SizedBox(height: 20), // give it height
            const Center(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                height: 20,
              ),
              Text('Delete Your Account',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))
            ])),
            const SizedBox(height: 10),
            const SizedBox(
              height: 20,
            ),
            const Text(
                'Once your account is deleted, you wont be able to access your account again and your data will be deleted from our system',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white),
                onPressed: () {
                  deleteUserAccount();
                },
                child: const Text('Delete Account'))
          ]))
        ])
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
              subtitle:
                  const Text('To delete this panel, tap the trash can icon'),
              trailing: const Icon(Icons.delete),
              onTap: () {
                removeMsgFromDB(item.msgId);
                setState(() {
                  _data!.removeWhere(
                      (MessageItem currentItem) => item == currentItem);
                });
              }),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }

  updateBankAccountToDB() async {
    String jwtToken = await storage.read(key: "jwtToken") as String;

    String basicAuth = 'Basic $jwtToken';
    var body = {
      'bankName': _bankNameController.text,
      'accountTitle': _accountTitleController.text,
      'accountNumber': _accountNumberController.text,
      'entityid': entityId.toString(),
      'token': jwtToken
    };

    final response = await http.post(
        Uri.parse('$SERVER_IP/entities/entity/updateentitybank'),
        // Send authorization headers to the backend.
        headers: {
          HttpHeaders.authorizationHeader: basicAuth,
        },
        body: body);

    jsonDecode(response.body)['Result'];
  }

  updateImamProfileToDB() async {
    String jwtToken = await storage.read(key: "jwtToken") as String;

    String basicAuth = 'Basic $jwtToken';
    var body = {
      'imamName': _imamNameController.text,
      'imamEmail': _imamEmailController.text,
      'imamPhone': _imamPhoneController.text,
      'entityid': entity!.user!.profile!.profilesId.toString(),
      'token': jwtToken
    };

    final response = await http.post(
        Uri.parse('$SERVER_IP/entities/entity/updateimamprofile'),
        // Send authorization headers to the backend.
        headers: {
          HttpHeaders.authorizationHeader: basicAuth,
        },
        body: body);

    jsonDecode(response.body)['Result'];
  }

  updatePrayerTimeToDB() async {
    String jwtToken = await storage.read(key: "jwtToken") as String;

    String basicAuth = 'Basic $jwtToken';
    var body = {
      'prayername': prayerNameToUpdate,
      'prayertime': updatedPrayerTime,
      'entityid': entityId.toString(),
      'entityscheduleid': entityScheduleId.toString(),
      'token': jwtToken
    };
    final response = await http.post(
        Uri.parse('$SERVER_IP/entities/entity/updateentityschedule'),
        // Send authorization headers to the backend.
        headers: {
          HttpHeaders.authorizationHeader: basicAuth,
        },
        body: body);
    esm = EntitySchedule.fromJson(response.body);
    setState(() {});
  }

  updateMaghribPrayerOffSetTimeToDB() async {
    String jwtToken = await storage.read(key: "jwtToken") as String;

    String basicAuth = 'Basic $jwtToken';
    var body = {
      'token': jwtToken,
      'entityScheduleId': entityScheduleId.toString(),
      'offsetminutes': _maghribOffsetController.text
    };
    final response = await http.post(
        Uri.parse('$SERVER_IP/entities/entity/updatemaghriboffsettime'),
        // Send authorization headers to the backend.
        headers: {
          HttpHeaders.authorizationHeader: basicAuth,
        },
        body: body);
    esm = EntitySchedule.fromJson(response.body);
    setState(() {});
  }

  loadEntityMessagesByEntityId(entityId) async {
    var body = {
      'entityid': entityId.toString(),
    };
    final response = await http.post(
        Uri.parse('$SERVER_IP/entities/entity/findentitymessages'),
        // Send authorization headers to the backend.
        body: body);

    var messagesMap = jsonDecode(response.body)['EntityMessages'];

    if (messagesMap != null) {
      entityMessages = [];
      messagesMap.forEach((element) => {generateMessages(element)});
      createMessage = true;
      isEntityMessages = true;
    }
  }

  generateMessages(element) {
    Messages aMsg = Messages.fromMap(element);
    entityMessages!.add(aMsg);
  }

  saveMessageToDB() async {
    String jwtToken = await storage.read(key: "jwtToken") as String;

    String basicAuth = 'Basic $jwtToken';
    var body = {
      'msgsubject': _mSubjectController.text,
      'msgbody': _mBodyController.text,
      'entityid': entityId.toString(),
      'token': jwtToken
    };

    final response = await http.post(
        Uri.parse('$SERVER_IP/entities/entity/createentitymessage'),
        // Send authorization headers to the backend.
        headers: {
          HttpHeaders.authorizationHeader: basicAuth,
        },
        body: body);

    jsonDecode(response.body)['Result'];
  }

  List<MessageItem> generateMessageList() {
    return List<MessageItem>.generate(entityMessages!.length, (int index) {
      return MessageItem(
          headerValue: '${entityMessages![index].msgSubject}',
          expandedValue: '${entityMessages![index].msgBody}',
          msgId: entityMessages![index].msgId as int);
    });
  }

  removeMsgFromDB(int msgId) async {
    String jwtToken = await storage.read(key: "jwtToken") as String;

    // String basicAuth = 'Basic $jwtToken';
    var body = {'messageid': msgId.toString(), 'token': jwtToken};

    final response = await http.post(
        Uri.parse('$SERVER_IP/entities/entity/deleteentitymsgbymsgid'),
        body: body);

    jsonDecode(response.body)['EntityMessages'];
  }

  resetUserPassword() async {
    String jwtToken = await storage.read(key: "jwtToken") as String;
    // String basicAuth = 'Basic $jwtToken';
    var body = {
      'username': entity!.user!.getUserName,
      'oldpassword': _oldPasswordController.text,
      'newpassword': _newPasswordController.text,
      'token': jwtToken
    };

    final response = await http
        .post(Uri.parse('$SERVER_IP/users/user/resetpassword'), body: body);

    var respMsg = jsonDecode(response.body)['message'];
    passwordUpdateRespMsg = respMsg;
    setState(() {
      passwordUpdateRespMsg = respMsg;
    });
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

  Future<String> loadSunSetTime() async {
    var timezone;
    var now = DateTime.now();
    try {
      final qParameters = {
        'latitude': lat.toString(),
        'longitude': long.toString(),
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
        'lat': entity!.getLat().toString(),
        'lng': entity!.getLog().toString(),
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

      return sunsetTime as String;
    } catch (e) {
      return sunsetTime = 'Error';
    }
  }

  Future<String> loadMaghribTime() async {
    return Future.delayed(const Duration(seconds: 6), () {
      var maghribTime =
          DateFormat('MM/dd/yyyyy hh:mm:ss').parse(sunsetTime as String);
      maghribTime = maghribTime.add(Duration(
          minutes: entity!.entitySchedule!.arrangement_for_Jamat as int));
      if (maghribTime.minute < 10) {
        maghribtimet = '0${maghribTime.hour}:0${maghribTime.minute}';
      } else {
        maghribtimet = '0${maghribTime.hour}:${maghribTime.minute}';
      }

      return maghribtimet as String;
      // throw Exception("Custom Error");
    });
  }

  deleteUserAccount() async {
    String jwtToken = await storage.read(key: "jwtToken") as String;
    // String basicAuth = 'Basic $jwtToken';
    var body = {'username': entity!.user!.getUserName, 'token': jwtToken};

    final response = await http
        .post(Uri.parse('$SERVER_IP/users/user/deleteuseraccount'), body: body);

    var respMsg = jsonDecode(response.body)['message'];
    passwordUpdateRespMsg = respMsg;
    Navigator.pushNamed(context, MyRoutes.loginRoute);
    setState(() {});
  }
}
