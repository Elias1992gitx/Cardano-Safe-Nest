import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safenest/core/common/app/providers/user_provider.dart';
import 'package:safenest/core/common/widgets/custom_button.dart';
import 'package:safenest/core/common/widgets/custom_profile_pic.dart';
import 'package:safenest/core/enum/user/update_user.dart';
import 'package:safenest/core/extensions/context_extensions.dart';
import 'package:safenest/core/utils/constants.dart';
import 'package:safenest/features/auth/data/models/user_model.dart';
import 'package:safenest/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:safenest/core/common/widgets/custom_form_field.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AccountSettingScreen extends StatefulWidget {
  const AccountSettingScreen({super.key});

  @override
  State<AccountSettingScreen> createState() => _AccountSettingScreenState();
}

class _AccountSettingScreenState extends State<AccountSettingScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  File? _imageFile;
  String? profilePicture;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        profilePicture = pickedFile.path;
      });
    }
  }

  void _saveUser() {
    if (formKey.currentState!.validate()) {
      final userProvider = context.read<UserProvider>();
      final updatedUser = LocalUserModel(
        uid: userProvider.user!.uid,
        email: userProvider.user!.email,
        username: _nameController.text,
        profilePic: profilePicture ?? userProvider.user!.profilePic,
      );

      context.read<AuthBloc>().add(UpdateUserEvent(
        action: UpdateUserAction.displayName,
        userData: updatedUser.username,
      ));

      context.read<AuthBloc>().add(UpdateUserEvent(
        action: UpdateUserAction.photoURL,
        userData: updatedUser.profilePic,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.cardColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: context.theme.cardColor,
        centerTitle: true,
        toolbarHeight: 70,
        title: Text(
          'Account Settings',
          style: GoogleFonts.montserrat(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.arrowLeft,
          ),
          onPressed: () => context.go('/profile-screen'),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Consumer<UserProvider>(
                builder: (context, ref, child) {
                  final userProvider = ref.user;
                  if (userProvider != null) {
                    final user = userProvider;
                    _nameController.text = user.username ?? '';
                    _phoneController.text = user.phoneNumber ?? '';
                    _addressController.text = user.address ?? '';
                    return Align(
                      alignment: AlignmentDirectional.topCenter,
                      child: SizedBox(
                        width: context.width * .9,
                        child: Align(
                          alignment: AlignmentDirectional.topCenter,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    12, 20, 12, 32),
                                child: Align(
                                  alignment: AlignmentDirectional.center,
                                  child: GestureDetector(
                                    onTap: _pickImage,
                                    child: _imageFile == null
                                        ? CachedNetworkImage(
                                      placeholder: (context, url) =>
                                          CustomProfilePic(
                                            imageProvider: const NetworkImage(
                                              kDefaultAvatar,
                                            ),
                                            onClicked: _pickImage,
                                            radius: 120,
                                            isEdit: true,
                                          ),
                                      errorWidget: (context, url, error) =>
                                          CustomProfilePic(
                                            imageProvider: const NetworkImage(
                                              kDefaultAvatar,
                                            ),
                                            onClicked: _pickImage,
                                            radius: 120,
                                            isEdit: true,
                                          ),
                                      fit: BoxFit.cover,
                                      imageUrl: user.profilePic ?? kDefaultAvatar,
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
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomTextFormField(
                                      textInputType: TextInputType.name,
                                      hintText: 'Name',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter the name';
                                        }
                                        if (value.length < 3) {
                                          return 'Name must be at least 3 characters long';
                                        }
                                        return null;
                                      },
                                      controller: _nameController,
                                      maxLength: 32,
                                      borderRadius: 10,
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextFormField(
                                      textInputType: TextInputType.phone,
                                      hintText: 'Phone Number',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter the phone number';
                                        }
                                        if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                                          return 'Please enter a valid phone number';
                                        }
                                        return null;
                                      },
                                      controller: _phoneController,
                                      maxLength: 15,
                                      borderRadius: 10,
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextFormField(
                                      textInputType: TextInputType.text,
                                      hintText: 'Address',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter the address';
                                        }
                                        if (value.length < 5) {
                                          return 'Address must be at least 5 characters long';
                                        }
                                        return null;
                                      },
                                      controller: _addressController,
                                      maxLength: 50,
                                      borderRadius: 10,
                                    ),
                                    const SizedBox(height: 16),
                                    CustomTextFormField(
                                      initialValue: user.email,
                                      readOnly: true,
                                      hintText: 'Email',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter the email';
                                        }
                                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                                          return 'Please enter a valid email address';
                                        }
                                        return null;
                                      },
                                      borderRadius: 10,
                                    ),
                                    const SizedBox(height: 32),
                                    FFCustomButton(
                                      text: 'Update Profile',
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
                                      onPressed: _saveUser,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        color: context.theme.colorScheme.secondary,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}