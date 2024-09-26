import 'dart:math';

import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:lottie/lottie.dart';
import 'package:location/location.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';

import 'package:safenest/core/common/widgets/custom_button.dart';
import 'package:safenest/core/common/widgets/custom_form_field.dart';
import 'package:safenest/core/common/widgets/custom_profile_pic.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:safenest/core/utils/constants.dart';
import 'package:safenest/features/profile/domain/entity/child.dart';

import 'package:safenest/features/location/presentation/views/custom_map_marker.dart';
import 'package:safenest/features/location/presentation/views/location_selector_page.dart';
import 'dart:io';

class AddChildForm extends StatefulWidget {
  final Function(Child) onChildAdded;

  const AddChildForm({super.key, required this.onChildAdded});

  @override
  State<AddChildForm> createState() => _AddChildFormState();
}

class _AddChildFormState extends State<AddChildForm> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final genderController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailAddressController = TextEditingController();
  final schoolNameController = TextEditingController();
  String? profilePicture;
  File? _imageFile;

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    genderController.dispose();
    phoneNumberController.dispose();
    emailAddressController.dispose();
    schoolNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        profilePicture = pickedFile.path;
      });
    }
  }

  Future<void> _selectLocation() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LocationSelectorPage(
          initialLocation: LatLng(_locationData.latitude!, _locationData.longitude!),
          onLocationSelected: (latLng, placeName) {
            setState(() {
              schoolNameController.text = placeName;
            });
          },
        ),
      ),
    );
  }



  void _saveChild() {
    if (formKey.currentState!.validate()) {
      final childId = _generateChildId();

      final child = Child(
        id: childId,
        name: nameController.text,
        age: int.parse(ageController.text),
        gender: genderController.text,
        profilePicture: profilePicture,
        phoneNumber: phoneNumberController.text,
        emailAddress: emailAddressController.text,
        schoolName: schoolNameController.text,
      );

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: context.theme.canvasColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('assets/lottie/success.json', width: 150, height: 150),
                const SizedBox(height: 16),
                Text(
                  'Child information added successfully!',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Make sure to copy Child ID:\n',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  childId,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,

                  ),
                ),
                IconButton(onPressed: () {
                  Clipboard.setData(ClipboardData(text: childId));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Child ID copied to clipboard!'),
                    ),
                  );
                }, icon: const Icon(FontAwesomeIcons.copy)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                widget.onChildAdded(child);
                Navigator.of(context).pop();
                context.pop(); 
              },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Child Information',
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _imageFile == null
                    ? CachedNetworkImage(
                  placeholder: (context, url) => CustomProfilePic(
                    imageProvider: const NetworkImage(
                      kDefaultAvatar,
                    ),
                    onClicked: _pickImage,
                    radius: 120,
                    isEdit: true,
                  ),
                  errorWidget: (context, url, error) => CustomProfilePic(
                    imageProvider: const NetworkImage(
                      kDefaultAvatar,
                    ),
                    onClicked: _pickImage,
                    radius: 120,
                    isEdit: true,
                  ),
                  fit: BoxFit.cover,
                  imageUrl: kDefaultAvatar,
                  imageBuilder: (context, imageProvider) {
                    return CustomProfilePic(
                        imageProvider: imageProvider,
                        onClicked: _pickImage,
                        radius: 120,
                        isEdit: true);
                  },
                )
                    : CustomProfilePic(
                  imageProvider: FileImage(_imageFile!),
                  onClicked: _pickImage,
                  radius: 120,
                  isEdit: true,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                textInputType: TextInputType.name,
                hintText: 'Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the name';
                  }
                  return null;
                },
                controller: nameController,
                maxLength: 32,
                borderRadius: 10,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      textInputType: TextInputType.number,
                      hintText: 'Age',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the age';
                        }
                        final age = int.tryParse(value);
                        if (age == null || age < 3 || age > 16) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Age must be between 3 and 16',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return 'Age not supported';
                        }
                        return null;
                      },
                      controller: ageController,
                      maxLength: 2,
                      borderRadius: 10,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextFormField(
                      textInputType: TextInputType.text,
                      hintText: 'Gender',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the gender';
                        }
                        return null;
                      },
                      controller: genderController,
                      maxLength: 10,
                      borderRadius: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                textInputType: TextInputType.phone,
                hintText: 'Phone Number',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the phone number';
                  }
                  return null;
                },
                controller: phoneNumberController,
                maxLength: 15,
                borderRadius: 10,
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                textInputType: TextInputType.emailAddress,
                hintText: 'Email Address',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the email address';
                  }
                  return null;
                },
                controller: emailAddressController,
                maxLength: 32,
                borderRadius: 10,
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                textInputType: TextInputType.text,
                hintText: 'School Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the school name';
                  }
                  return null;
                },
                controller: schoolNameController,
                maxLength: 50,
                borderRadius: 10,
                suffixIcon: IconButton(
                  icon: Icon(IconlyLight.location),
                  onPressed: _selectLocation,
                ),
              ),
              const SizedBox(height: 32),
              FFCustomButton(
                text: 'Save',
                options: FFButtonOptions(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 18,
                  ),
                  width: context.width * .9,
                  color: context.theme.primaryColor,
                  elevation: .05,
                  iconPadding: EdgeInsetsDirectional.zero,
                  textStyle: GoogleFonts.plusJakartaSans(
                    color: context.theme.canvasColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                onPressed: _saveChild,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _generateChildId() {
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final Random random = Random();
    return String.fromCharCodes(Iterable.generate(
        8, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }
}