import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:give_away/models/location_model.dart';
import 'package:give_away/models/product_model.dart';
import 'package:give_away/providers/add_product_provider.dart';
import 'package:give_away/screens/nav_bar.dart';
import 'package:give_away/services/product_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../utils/colors.dart';

class AddProduct extends StatefulWidget {
  AddProduct({super.key, required this.func});
  Function func;
  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController addressLineController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  double? latitude;
  double? longitude;
  XFile? pickedImage;
  String selectedCategoryValue = "0";
  String selectedConditionValue = "0";

  List<DropdownMenuItem<String>> get categoryItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: Text("Select", overflow: TextOverflow.ellipsis), value: "0"),
      DropdownMenuItem(
          child: Text("Furniture", overflow: TextOverflow.ellipsis),
          value: "1"),
      DropdownMenuItem(
          child: Text("Electronics", overflow: TextOverflow.ellipsis),
          value: "2"),
      DropdownMenuItem(
          child: Text(
            "Gym",
            overflow: TextOverflow.ellipsis,
          ),
          value: "3"),
      DropdownMenuItem(
          child: Text("Books", overflow: TextOverflow.ellipsis), value: "4"),
      DropdownMenuItem(
          child: Text(
            "Music",
            overflow: TextOverflow.ellipsis,
          ),
          value: "5"),
    ];
    return menuItems;
  }
  List<DropdownMenuItem<String>> get conditionItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: Text("Select", overflow: TextOverflow.ellipsis), value: "0"),
      DropdownMenuItem(
          child: Text("New", overflow: TextOverflow.ellipsis), value: "1"),
      DropdownMenuItem(
          child: Text("Poor", overflow: TextOverflow.ellipsis), value: "2"),
    ];
    return menuItems;
  }


  @override
  void dispose() {
    nameController.dispose();
     ageController.dispose();
     descController.dispose();
     addressLineController.dispose();
    cityController.dispose();
    stateController.dispose();
    pinController.dispose();
    super.dispose();
  }

  pickImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final image = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        pickedImage = XFile(image!.path);
      });
    } on Exception catch (e) {
      print(e);
      snackBar('Error getting the Image!!');
    }
  }

  void snackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  bool _isChecked = false;
  bool _isLoading = false;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    setState(() {
      _isLoading=true;
    });
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _isLoading=false;
        addressLineController.text=place.street.toString();
        cityController.text=place.locality.toString();
        stateController.text=place.administrativeArea.toString();
        pinController.text=place.postalCode.toString();
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

   _getCoordinatesFromAddress(address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        setState(() {
          latitude = locations.first.latitude;
          longitude = locations.first.longitude;
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  cleanData(){
    pickedImage=null;
    nameController.text='';
    ageController.text='';
    descController.text='';
    addressLineController.text='';
    stateController.text='';
    cityController.text='';
    pinController.text='';
    selectedCategoryValue='0';
    selectedConditionValue='0';
    _isChecked=false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "GiveAway Product",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          centerTitle: false,
        ),
        body: Consumer<AddProductProvider>(
          builder: (BuildContext context, provider, Widget? child) {
            return provider.isLoading? const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            ) :
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    //image

                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: const Text(
                              "Product Image :",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                pickImage();
                              },
                              child: Text(
                                "Select Image",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.deepPurple,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.deepPurple),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        child: pickedImage == null
                            ? const SizedBox(
                          height: 0,
                        )
                            : Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Image.file(
                            File(pickedImage!.path),
                            height: 400,
                            width: 400,
                            fit: BoxFit.cover,
                          ),
                        )),

                    _isChecked == true && pickedImage == null
                        ? Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Select Image!!",
                        style: TextStyle(
                            color: Colors.red.shade900, fontSize: 12),
                      ),
                    )
                        : SizedBox(),

                    //name
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        "Product Name",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Product Name!!';
                          } else {
                            return null;
                          }
                        },
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.withOpacity(.1),
                          filled: true,
                          hintText: " Enter Product Name",
                          hintStyle: const TextStyle(color: secondaryColor),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),

                    //age
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        "How old is the product?",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: ageController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Product Age!!';
                          } else {
                            return null;
                          }
                        },
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.withOpacity(.1),
                          filled: true,
                          hintText: "Enter Product Age",
                          hintStyle: const TextStyle(color: secondaryColor),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),

                    //description
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        "Product Description",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: TextFormField(
                        controller: descController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Product Description!!';
                          } else {
                            return null;
                          }
                        },
                        textAlignVertical: TextAlignVertical.top,
                        maxLines: 5,
                        decoration: InputDecoration(
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          fillColor: Colors.grey.withOpacity(.1),
                          filled: true,
                          hintText: " Enter Product Description",
                          hintStyle: const TextStyle(color: secondaryColor),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),

                    //category
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: const Text(
                              "Select Category :",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 14, left: 5),
                              child: DropdownButton(
                                isExpanded: true,
                                value: selectedCategoryValue,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedCategoryValue = newValue!;
                                  });
                                },
                                items: categoryItems,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _isChecked == true && selectedCategoryValue == '0'
                        ? Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Select Category!!",
                        style: TextStyle(
                            color: Colors.red.shade900, fontSize: 12),
                      ),
                    )
                        : SizedBox(),

                    //condition
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: const Text(
                              "Select Condition :",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 14, left: 5),
                              child: DropdownButton(
                                isExpanded: true,
                                value: selectedConditionValue,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedConditionValue = newValue!;
                                  });
                                },
                                items: conditionItems,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _isChecked == true && selectedConditionValue == '0'
                        ? Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Select Condition!!",
                        style: TextStyle(
                            color: Colors.red.shade900, fontSize: 12),
                      ),
                    )
                        : SizedBox(),

                    //location
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: const Text(
                              "Address :",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w400),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: _getCurrentPosition,
                              child: Text(
                                "Get Current Location",
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.deepPurple,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.deepPurple),
                              ),
                            ),
                          ),
                          _isLoading?
                          Container(
                            height: 16,
                              width: 16,
                              margin: EdgeInsets.only(right: 5,left: 5),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ))
                              :SizedBox()
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top:2),
                      child: TextFormField(
                        controller: addressLineController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter Address Line !!';
                          } else {
                            return null;
                          }
                        },
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.withOpacity(.1),
                          filled: true,
                          hintText: "Address Line ",
                          hintStyle: const TextStyle(color: secondaryColor),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: TextFormField(
                        controller: cityController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enter City!!';
                          } else {
                            return null;
                          }
                        },
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          fillColor: Colors.grey.withOpacity(.1),
                          filled: true,
                          hintText: "City ",
                          hintStyle: const TextStyle(color: secondaryColor),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5,right: 2.5),
                            child: TextFormField(
                              controller: stateController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter State!!';
                                } else {
                                  return null;
                                }
                              },
                              textAlignVertical: TextAlignVertical.center,
                              decoration: InputDecoration(
                                fillColor: Colors.grey.withOpacity(.1),
                                filled: true,
                                hintText: "State",
                                hintStyle: const TextStyle(color: secondaryColor),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5,left: 2.5),
                            child: TextFormField(
                              controller: pinController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter Pin Code!!';
                                } else {
                                  return null;
                                }
                              },
                              textAlignVertical: TextAlignVertical.center,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                fillColor: Colors.grey.withOpacity(.1),
                                filled: true,
                                hintText: "PIN Code ",
                                hintStyle: const TextStyle(color: secondaryColor),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),



                    GestureDetector(
                      onTap: () async {
                        setState(() {
                          _isChecked=true;
                        });

                        if (_formKey.currentState!.validate()&& selectedConditionValue!='0'&&selectedCategoryValue!='0'&& pickedImage!=null) {
                          String address="${addressLineController.text.toString()}, ${cityController.text.toString()}, ${stateController.text.toString()}, postal code - ${pinController.text.toString()} ";
                          await _getCoordinatesFromAddress(address);

                          //  add product !!!!!!
                          final location=LocationModel(city: cityController.text.toString(),
                              state: stateController.text.toString(),
                              lat: latitude ?? 0 ,
                              long: longitude ?? 0,
                              addressLine: addressLineController.text.toString(),
                              pinCode: int.parse(pinController.text.toString()));
                          final newProduct = ProductModel(
                              id: '',
                              title: nameController.text.toString(),
                              category: '',
                              productAge: int.parse(ageController.text.toString()),
                              imageUrl: pickedImage!.path,
                              uid: '',
                              condition: '',
                              productDescription: descController.text.toString(),
                              location: location
                          );
                          await provider.addProduct(newProduct,snackBar);

                          if(provider.isSuccess!=false&& mounted){
                            cleanData();
                            widget.func(0);
                          }

                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        height: 60,
                        width: 200,
                        decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: const Center(
                            child: Text(
                              "Add Product",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontSize: 18),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            );
            },
        ));
  }
}
