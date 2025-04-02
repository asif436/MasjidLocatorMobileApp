import 'package:flutter/material.dart';
import 'package:salahmaskan/utils/routes.dart';
import 'package:http/http.dart' as http;
import 'package:salahmaskan/main.dart';
import 'dart:convert';
import 'package:salahmaskan/models/SigninResponse.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:image/image.dart' as img;
import 'dart:io';

class SecureAdmin extends StatefulWidget {
  const SecureAdmin({super.key});

  @override
  State<SecureAdmin> createState() => _SecureAdminState();
}

class _SecureAdminState extends State<SecureAdmin> {
  int currentPageIndex = 0;

  final _formKey = GlobalKey<FormState>();

  String? entityPic;
  // Create advertisement form fields
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _contactPersonPhoneController =
      TextEditingController();
  final TextEditingController _contactDesignationController =
      TextEditingController();

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();
  final TextEditingController _linkURLController = TextEditingController();
  DateTime currentDate = DateTime.now();

  String selectedCountryValue = 'Select Country';
  List<dynamic> lstCountries = [];
  List<DropdownMenuItem<String>> menuItemsCountries = [];
  String selectedRegionValue = 'Select Region';
  List<DropdownMenuItem<String>> menuItemsRegion = [];
  List<dynamic> lstRegions = [];
  String selectedSubRegionValue = 'Select SubRegion';
  List<DropdownMenuItem<String>> menuItemsSubRegion = [];
  List<dynamic> lstSubRegions = [];

  String advertisementImage = 'http://masjidlocators.com/AdHere.jpg';

  XFile? _uploadedAdImage = null;

  List<Entity> entities = [];
  List<int> selectedEntities = [];
  int? selectedIndex;
  @override
  void initState() {
    // load country list on tab 1
    loadCountryList();
    getlstUnverifiedEntities();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Secure Admin Home'),
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
              Navigator.pushNamed(context, MyRoutes.loginRoute);
            },
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
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
            label: 'Create',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.message_rounded),
            icon: Icon(Icons.message_outlined),
            label: 'View',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.message_rounded),
            icon: Icon(Icons.message_outlined),
            label: 'Verify',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.location_city),
            icon: Icon(Icons.location_city_outlined),
            label: 'Profile',
          )
        ],
      ),
      body: <Widget>[
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
                              Text('Create advertisement',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20))
                            ])),
                        const SizedBox(height: 10),

                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              Container(
                                  margin: const EdgeInsets.all(10.0),
                                  padding: const EdgeInsets.all(1.0),
                                  child: Row(children: [
                                    const SizedBox(width: 5),
                                    SizedBox(
                                        width: 260,
                                        height: 35,
                                        child: TextFormField(
                                          controller: _companyNameController,
                                          decoration: const InputDecoration(
                                            hintText: "Enter Business Name",
                                          ),
                                          validator: (value) {
                                            if (value != null &&
                                                value.isEmpty) {
                                              return "Business Name can't be empty";
                                            }
                                            return null;
                                          },
                                        ))
                                  ])),
                              Container(
                                  margin: const EdgeInsets.all(10.0),
                                  padding: const EdgeInsets.all(1.0),
                                  child: Row(children: [
                                    const SizedBox(width: 5),
                                    SizedBox(
                                        width: 260,
                                        height: 35,
                                        child: TextFormField(
                                          controller: _contactNameController,
                                          decoration: const InputDecoration(
                                            hintText: "Enter Contact Name",
                                          ),
                                          validator: (value) {
                                            if (value != null &&
                                                value.isEmpty) {
                                              return "Contact person name can't be empty";
                                            }
                                            return null;
                                          },
                                        ))
                                  ])),
                              Container(
                                  margin: const EdgeInsets.all(10.0),
                                  padding: const EdgeInsets.all(1.0),
                                  child: Row(children: [
                                    const SizedBox(width: 5),
                                    SizedBox(
                                        width: 260,
                                        height: 35,
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller:
                                              _contactPersonPhoneController,
                                          decoration: const InputDecoration(
                                            hintText:
                                                "Enter Contact person's Phone",
                                          ),
                                          validator: (value) {
                                            if (value != null &&
                                                value.isEmpty) {
                                              return "Contact person's phone can't be empty";
                                            }
                                            return null;
                                          },
                                        ))
                                  ])),
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
                                              _contactDesignationController,
                                          decoration: const InputDecoration(
                                            hintText:
                                                "Enter Contact person's designation",
                                          ),
                                          validator: (value) {
                                            if (value != null &&
                                                value.isEmpty) {
                                              return "Contact person's designation can't be empty";
                                            }
                                            return null;
                                          },
                                        ))
                                  ])),
                              Container(
                                  margin: const EdgeInsets.all(10.0),
                                  padding: const EdgeInsets.all(1.0),
                                  child: Row(children: [
                                    const SizedBox(width: 5),
                                    SizedBox(
                                        width: 260,
                                        height: 35,
                                        child: TextFormField(
                                          controller: _frequencyController,
                                          decoration: const InputDecoration(
                                            hintText:
                                                "Enter Advertisement Fequency Limit",
                                          ),
                                          validator: (value) {
                                            if (value != null &&
                                                value.isEmpty) {
                                              return "Advertisement Frequency can't be empty";
                                            }
                                            return null;
                                          },
                                        ))
                                  ])),
                              Container(
                                  margin: const EdgeInsets.all(10.0),
                                  padding: const EdgeInsets.all(1.0),
                                  child: Row(children: [
                                    const SizedBox(width: 5),
                                    SizedBox(
                                        width: 260,
                                        height: 35,
                                        child: TextFormField(
                                          controller: _linkURLController,
                                          decoration: const InputDecoration(
                                            hintText: "Enter URL link",
                                          ),
                                          validator: (value) {
                                            if (value != null &&
                                                value.isEmpty) {
                                              return "Must be a valid http url link";
                                            }
                                            return null;
                                          },
                                        ))
                                  ])),
                              Container(
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 5),
                                  child: Row(children: [
                                    const SizedBox(width: 5),
                                    SizedBox(
                                        width: 260,
                                        height: 55,
                                        child: TextField(
                                          controller:
                                              _startDateController, //editing controller of this TextField
                                          decoration: const InputDecoration(
                                              icon: Icon(Icons
                                                  .calendar_today), //icon of text field
                                              labelText:
                                                  "Enter Start Date" //label text of field
                                              ),
                                          readOnly:
                                              true, // when true user cannot edit text
                                          onTap: () async {
                                            DateTime? pickedDate =
                                                await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime
                                                        .now(), //get today's date
                                                    firstDate: DateTime(
                                                        2000), //DateTime.now() - not to allow to choose before today.
                                                    lastDate: DateTime(2101));

                                            if (pickedDate != null) {
                                              String formattedDate = DateFormat(
                                                      'yyyy-MM-dd')
                                                  .format(
                                                      pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed

                                              setState(() {
                                                _startDateController.text =
                                                    formattedDate; //set foratted date to TextField value.
                                              });
                                            }
                                          },
                                        ))
                                  ])),
                              Container(
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 5),
                                  child: Row(children: [
                                    const SizedBox(width: 5),
                                    SizedBox(
                                        width: 260,
                                        height: 55,
                                        child: TextField(
                                          controller:
                                              _endDateController, //editing controller of this TextField
                                          decoration: const InputDecoration(
                                              icon: Icon(Icons
                                                  .calendar_today), //icon of text field
                                              labelText:
                                                  "Enter End Date" //label text of field
                                              ),
                                          readOnly:
                                              true, // when true user cannot edit text
                                          onTap: () async {
                                            DateTime? pickedDate =
                                                await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime
                                                        .now(), //get today's date
                                                    firstDate: DateTime(
                                                        2000), //DateTime.now() - not to allow to choose before today.
                                                    lastDate: DateTime(2101));

                                            if (pickedDate != null) {
                                              String formattedDate = DateFormat(
                                                      'yyyy-MM-dd')
                                                  .format(
                                                      pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed

                                              setState(() {
                                                _endDateController.text =
                                                    formattedDate; //set foratted date to TextField value.
                                              });
                                            }
                                          },
                                        ))
                                  ])),
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

                                    setState(() {
                                      //  selectedSubRegionValue = newValue!;
                                    });
                                  },
                                  items: menuItemsSubRegion),
                              const SizedBox(height: 10),
                              Container(
                                  margin: const EdgeInsets.all(10.0),
                                  padding: const EdgeInsets.all(1.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.green)),
                                  child: Row(children: [
                                    const SizedBox(width: 10),
                                    _uploadedAdImage == null
                                        ? Container(
                                            margin: const EdgeInsets.all(10),
                                            child: Image(
                                              width: 150,
                                              height: 75,
                                              image: NetworkImage(
                                                  advertisementImage),
                                            ))
                                        : Container(
                                            margin: const EdgeInsets.all(10),
                                            child: Image(
                                                image: ResizeImage(
                                                    FileImage(File(
                                                        _uploadedAdImage!
                                                            .path)),
                                                    height: 75,
                                                    width: 150))),
                                    const SizedBox(width: 20), // give it width
                                    ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green),
                                        onPressed: () async {
                                          //upload image from local drive
                                          XFile? file;
                                          await getEntityFile()
                                              .then((value) => file = value);
                                          uploadCompressedFile(file, 'Entity');
                                          setState(() {});
                                        },
                                        child: const Text('Upload Ad')),
                                    const SizedBox(width: 20)
                                  ])),
                              Center(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .center, //Center Row contents horizontally,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center, //Center Row contents vertically,
                                    children: [
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green),
                                        onPressed: () async {
                                          loadAdvertisement();
                                        },
                                        label: const Text('Upload',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                        icon: const Icon(Icons.upload_rounded),
                                      ),
                                    ]),
                              )
                            ],
                          ),
                        )
                      ]))))
        ]),
        const Column(children: <Widget>[]),
        Column(children: <Widget>[
          Expanded(
              child: ListView.builder(
            itemCount: entities.length,
            itemBuilder: (context, index) {
              return Card(
                  color: Colors.green,
                  child: ListTile(
                    title: Text('${entities[index].entity_name}',
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        '${entities[index].user!.profile!.profilerName} - ${entities[index].user!.profile!.profilerPhone} - ${entities[index].region}',
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    tileColor: selectedIndex == index ? Colors.blue : null,
                    onTap: () {
                      selectedEntities.add(entities[index].entity_Id as int);
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ));
            },
          )),
          ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                updateEntitiesStatusToVerified();
              },
              child: const Text('Verify Entities')),
        ]),
        const Column(children: <Widget>[])
      ][currentPageIndex],
    );
  }

  loadAdvertisement() async {
    String? jwtToken = await storage.read(key: "jwtToken") as String;
    //  String basicAuth = 'Basic $jwtToken';
    // Read the file as bytes
    List<int> imageBytes = await _uploadedAdImage!.readAsBytes();
    // Create the multipart request
    final request = http.MultipartRequest('POST',
        Uri.parse('$SERVER_IP/entities/entity/createcompanyadvertisement'));
    final httpimage = http.MultipartFile.fromBytes('file', imageBytes,
        filename: _uploadedAdImage!.name);
    // Add the base64-encoded image as a field

    request.files.add(httpimage);
    request.fields['companyname'] = _companyNameController.text;
    request.fields['contactname'] = _contactNameController.text;
    request.fields['contactphone'] = _contactPersonPhoneController.text;
    request.fields['contactdesignation'] = _contactDesignationController.text;
    request.fields['linkurl'] = _linkURLController.text;
    request.fields['startdate'] = _startDateController.text;
    request.fields['enddate'] = _endDateController.text;
    request.fields['frequency'] = _frequencyController.text;
    request.fields['country'] = selectedCountryValue;
    request.fields['region'] = selectedRegionValue;
    request.fields['subregion'] = selectedSubRegionValue;
    request.fields['token'] = jwtToken;

    // Send the request
    try {
      final response = await request.send();
      //  final respStr = await response.stream.bytesToString();
      // Handle the response, e.g., print status code
      print('Server responded with ${response.statusCode}');
    } catch (error) {
      // Handle any errors that occurred during the request
      print('Error uploading file: $error');
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

      menuItemsCountries.add(DropdownMenuItem(
          value: selectedCountryValue, child: Text(selectedCountryValue)));
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

      menuItemsRegion.add(DropdownMenuItem(
          value: selectedRegionValue, child: Text(selectedRegionValue)));
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

  Future<XFile?> getEntityFile() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
    /*
    return await ImagePicker.platform
        .getImageFromSource(source: ImageSource.gallery);
  */
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
      width = 350;
      height = 90;

      img.Image resizedImage =
          img.copyResize(image!, width: width, height: height);

      img.encodeJpg(resizedImage, quality: 85); // Adjust quality as needed

      final png = img.encodeJpg(resizedImage);

      // Save the compressed image to a file
      File compressedFile = File(
          uploadedfile!.path.replaceFirst(extension, '_compressed$extension'));

      compressedFile.writeAsBytesSync(png);

      _uploadedAdImage = XFile(compressedFile.path);
    }
  }

  Future<void> _uploadEntityFile() async {
    if (_uploadedAdImage == null) {
      // Handle case when no file is selected
      return;
    }

    // Read the file as bytes
    List<int> imageBytes = await _uploadedAdImage!.readAsBytes();

    // Create the multipart request
    final request = http.MultipartRequest(
        'POST', Uri.parse('$SERVER_IP/entities/entity/upload'));
    final httpimage = http.MultipartFile.fromBytes('file', imageBytes,
        filename: _uploadedAdImage!.name);
    // Add the base64-encoded image as a field

    request.files.add(httpimage);
    //  request.fields['entityid'] = entityId.toString();
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

  Future<void> _verifyEntitiesStatus() async {
    // Create the multipart request
    final request = http.MultipartRequest('POST',
        Uri.parse('$SERVER_IP/entities//entity/updateentitiesactivestatus'));

    request.fields['entities'] = "Entity";
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

  getlstUnverifiedEntities() async {
    String jwtToken = await storage.read(key: "jwtToken") as String;
    var body = {'token': jwtToken};

    final response = await http.post(
        Uri.parse('$SERVER_IP/entities/entity/findinactiveentities'),
        body: body);

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      if (responseJson["UnverifiedEntities"] != null) {
        entities = [];
        responseJson["UnverifiedEntities"]
            .forEach((element) => {entities.add(Entity.fromMap(element))});
        print(entities.length);
      }
    }
  }

  updateEntitiesStatusToVerified() async {
    String jwtToken = await storage.read(key: "jwtToken") as String;
    var body = {'token': jwtToken, 'listKey': json.encode(selectedEntities)};

    final response = await http.post(
        Uri.parse('$SERVER_IP/entities/entity/updateentitiesactivestatus'),
        body: body);

    if (response.statusCode == 200) {
      selectedEntities = [];
    }
  }
}
