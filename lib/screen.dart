import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:inec_reg/homescreen.dart';

import 'package:inec_reg/userInformation.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

class Screen extends StatefulWidget {
  Screen({Key? key}) : super(key: key);

  @override
  State<Screen> createState() => _ScreenState();
}

TextEditingController firstnameController = TextEditingController();
TextEditingController todayDateController = TextEditingController();
TextEditingController gprsCoordController = TextEditingController();
TextEditingController surnameController = TextEditingController();
TextEditingController middlenameController = TextEditingController();
TextEditingController gprsController = TextEditingController();
TextEditingController genderController = TextEditingController();

final GlobalKey<FormState> formKey = GlobalKey<FormState>();

var items = [
  "Female",
  "Male",
  "Other",
];

class _ScreenState extends State<Screen> {
  @override
  void initState() {
    checkGps();

    super.initState();
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        setState(() {
          //refresh the UI
        });

        getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {
      //refresh the UI
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();

    setState(() {
      //refresh UI
    });

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457

      long = position.longitude.toString();
      lat = position.latitude.toString();

      setState(() {
        //refresh UI on update
      });
    });
  }

  late final Position _currentPosition;
  late String _currentAddress = "";

  late final timeDate = DateFormat().format(DateTime.now());
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;

  @override
  Widget build(BuildContext context) {
    final timeDate = DateFormat().format(DateTime.now());

    final surName = TextFormField(
        autofocus: false,
        controller: surnameController,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        style: TextStyle(color: Colors.black),
        validator: (value) {
          RegExp regex = RegExp(r'^.{2,}$');
          if (value!.isEmpty) {
            return "Name cannot be empty";
          }
          if (!regex.hasMatch(value)) {
            return ("Enter a valid name(min.2 Characters)");
          }
          return null;
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: EdgeInsets.all(15),
        ),
        onSaved: (value) {
          surnameController.text = value!;
        });
    todayDate() {
      return Container(
        child: Text("$timeDate"),
      );
    }

    final gender = TextFormField(
      controller: genderController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: PopupMenuButton<String>(
          icon: const Icon(Icons.arrow_drop_down),
          onSelected: (String value) {
            genderController.text = value;
          },
          itemBuilder: (BuildContext context) {
            return items.map<PopupMenuItem<String>>((String value) {
              return new PopupMenuItem(child: new Text(value), value: value);
            }).toList();
          },
        ),
      ),
    );
    final firstName = TextFormField(
        autofocus: false,
        controller: firstnameController,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        style: TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: EdgeInsets.all(10),
        ),
        //validator: (){};
        onSaved: (value) {
          firstnameController.text = value!;
        });

    final middleName = TextFormField(
        autofocus: false,
        controller: middlenameController,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: EdgeInsets.all(10),
        ),
        //validator: (){};
        onSaved: (value) {
          firstnameController.text = value!;
        });
    final gprsCorrd = TextFormField(
        autofocus: false,
        readOnly: true,
        keyboardType: TextInputType.name,
        textInputAction: TextInputAction.next,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: "lat:$lat, long:$long",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.all(10),
        ),
        onSaved: (value) {
          firstnameController.text = value!;
        });
    final submitButton = ElevatedButton(
        onPressed: () {
          Map<String, String> dataToSave = {
            'surname': surnameController.text,
            'gender': genderController.text,
            "latitude": "$lat",
            "longitude": "$long",
            'date': "$timeDate",
            'firstname': firstnameController.text,
            'middlename': middlenameController.text
          };
          FirebaseFirestore.instance
              .collection('Adhoc_details')
              .add(dataToSave)
              .then((value) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => UserInformation()));
          }).whenComplete(() {
            firstnameController.clear();
            todayDateController.clear();
            gprsCoordController.clear();
            surnameController.clear();
            middlenameController.clear();
            gprsController.clear();
            genderController.clear();
          });
        },
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all(Color.fromARGB(255, 226, 98, 51)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            padding: MaterialStateProperty.all(const EdgeInsets.only(
                top: 20, bottom: 20, left: 40, right: 40)),
            textStyle:
                MaterialStateProperty.all(const TextStyle(fontSize: 16))),
        child: Text('Submit',
            style: Theme.of(context)
                .textTheme
                .bodyText1
                ?.copyWith(color: Colors.white)));
    final draftButton = ElevatedButton(
        child: Text(
          'Saved Draft',
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        onPressed: () {},
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(color: Colors.black)),
            ),
            padding: MaterialStateProperty.all(
                EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 30)),
            textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16))));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: ElevatedButton(
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          style: ElevatedButton.styleFrom(
            elevation: 0,
            primary: Colors.white,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 10),
        child: SingleChildScrollView(
          child: Form(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Voter's Registration",
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      fontSize: 20, color: Color.fromARGB(255, 117, 42, 20)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "What is your Surname",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              surName,
              const SizedBox(
                height: 20,
              ),
              todayDate(),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Collect GPS Coordinates of the house",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              gprsCorrd,
              const SizedBox(
                height: 20,
              ),
              Text(
                "Resident's Gender",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              gender,
              const SizedBox(
                height: 20,
              ),
              Text(
                "What is your first name",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              firstName,
              const SizedBox(
                height: 20,
              ),
              Text(
                "What is your middle name",
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    ?.copyWith(fontSize: 16),
              ),
              const SizedBox(
                height: 20,
              ),
              middleName,
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Ink(child: submitButton),
                ],
              )
            ],
          )),
        ),
      ),
    );
  }
}
