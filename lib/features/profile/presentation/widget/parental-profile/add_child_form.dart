import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:location/location.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:safenest/core/common/widgets/custom_csc.dart';

import 'package:safenest/core/common/widgets/custom_button.dart';
import 'package:safenest/core/common/widgets/custom_form_field.dart';
import 'package:safenest/core/common/widgets/custom_profile_pic.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:safenest/core/utils/constants.dart';
import 'package:safenest/features/profile/domain/entity/child.dart';

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
  final PhoneController _phoneController = PhoneController();
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
  bool serviceEnabled;
  PermissionStatus permissionGranted;
  LocationData locationData;

  serviceEnabled = await location.serviceEnabled();
  if (!serviceEnabled) {
    serviceEnabled = await location.requestService();
    if (!serviceEnabled) {
      return;
    }
  }

  permissionGranted = await location.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await location.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  locationData = await location.getLocation();

  final result = await Navigator.of(context).push<Map<String, dynamic>>(
    MaterialPageRoute(
      builder: (context) => LocationSelectorPage(
        initialLocation: LatLng(locationData.latitude!, locationData.longitude!),
        onLocationSelected: (LatLng latLng, String placeName) {
          Navigator.of(context).pop({
            'latitude': latLng.latitude,
            'longitude': latLng.longitude,
            'name': placeName,
          });
        },
      ),
    ),
  );

  if (result != null) {
    setState(() {
      schoolNameController.text = result['name'];
    });
  }
}
  Future<Map<String, dynamic>?> _searchSchools(
      Map<String, double?> params) async {
    final latitude = params['latitude'] ?? 0.0;
    final longitude = params['longitude'] ?? 0.0;

    // Simulated API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Simulated school data
    final schools = [
      {
        'name': 'Springfield Elementary School',
        'latitude': latitude + 0.01,
        'longitude': longitude - 0.01
      },
      {
        'name': 'Central High School',
        'latitude': latitude - 0.005,
        'longitude': longitude + 0.005
      },
      {
        'name': 'Oakwood Academy',
        'latitude': latitude + 0.008,
        'longitude': longitude + 0.003
      },
    ];

    // In a real scenario, you would display these options to the user and let them choose
    // For this example, we'll just return the first result
    return schools.isNotEmpty ? schools.first : null;
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
                Lottie.asset('assets/lottie/success.json',
                    width: 150, height: 150),
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
                IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: childId));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Child ID copied to clipboard!'),
                        ),
                      );
                    },
                    icon: const Icon(FontAwesomeIcons.copy)),
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
                      controller: genderController,
                      readOnly: true,
                      borderRadius: 10,
                      suffixIcon: PopupMenuButton<String>(
                        icon: const Icon(Icons.arrow_drop_down),
                        onSelected: (String value) {
                          setState(() {
                            genderController.text = value;
                          });
                        },
                        itemBuilder: (BuildContext context) {
                          return ['Male', 'Female'].map((String value) {
                            return PopupMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList();
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a gender';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              PhoneFormField(
                isCountryButtonPersistent: true,
                controller: _phoneController,
                countryButtonStyle: const CountryButtonStyle(
                  showIsoCode: true,
                  flagSize: 15,
                ),
                validator: (value) {
                  if (value == null || !value.isValid()) {
                    return 'Please enter your phone number';
                  }
                  // if (!_selectedCountryCode.isEmpty && !value.startsWith(_selectedCountryCode)) {
                  //   return 'Phone number must match the country code ($_selectedCountryCode)';
                  // }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Phone Number',
                  filled: true,
                  prefixStyle: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: context.theme.textTheme.bodyMedium!.color,
                    ),
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 0,
                      color: Colors.transparent,
                    ),
                  ),
                  counterText: '',
                  labelStyle: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16,
                    ),
                  ),
                  hintStyle: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 0,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: context.theme.colorScheme.tertiaryContainer
                      .withOpacity(.5),
                  contentPadding:
                      const EdgeInsetsDirectional.fromSTEB(20, 18, 0, 18),
                ),
                countrySelectorNavigator:
                    CountrySelectorNavigator.modalBottomSheet(
                  favorites: [IsoCode.ET, IsoCode.US, IsoCode.GB],
                  height: 500,
                  titleStyle: GoogleFonts.plusJakartaSans(
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitleStyle: GoogleFonts.plusJakartaSans(
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  searchBoxDecoration: InputDecoration(
                    hintText: 'Search Country',
                    filled: true,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        color: Colors.transparent,
                      ),
                    ),
                    counterText: '',
                    prefixIcon: const Icon(
                      IconlyLight.search,
                    ),
                    hintStyle: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: 16,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fillColor: context.theme.colorScheme.tertiaryContainer
                        .withOpacity(.5),
                    contentPadding:
                        const EdgeInsetsDirectional.fromSTEB(20, 18, 0, 18),
                  ),
                  searchBoxTextStyle: GoogleFonts.plusJakartaSans(
                    textStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: 16,
                    ),
                  ),
                ),
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
                hintText: 'Search for School',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a school';
                  }
                  return null;
                },
                controller: schoolNameController,
                maxLength: 50,
                borderRadius: 10,
                suffixIcon: IconButton(
                  icon: const Icon(IconlyLight.search),
                  onPressed: _selectLocation,
                ),
                readOnly: true, // Make the field read-only
                onTap: _selectLocation, // Open the search when tapped
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
