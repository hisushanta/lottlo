import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:lottlo/main.dart';
import 'contact.dart';
import 'reset_password.dart';
import 'faq_page.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String? _profileImagePath;
  bool _isEditing = false;
  late TextEditingController _usernameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
    _initializeProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _initializeProfile() {
    if (info != null && info!.userProfile[info!.uuid] != null) {
      if (info!.isLoading.value == false) {
        _profileImagePath = info!.userProfile[info!.uuid]!['profileImage'];
        File imageFile = File(_profileImagePath!);
        if (!imageFile.existsSync()) {
          _profileImagePath = "assets/mainIcon.png";
        }
        _usernameController.text = info!.userProfile[info!.uuid]!['username'] ?? '';
        _addressController.text = info!.userProfile[info!.uuid]!['address'] ?? '';
        _phoneController.text = info!.userProfile[info!.uuid]!['number'] ?? '';
        setState(() {});
      } else {
        info!.isLoading.addListener(() {
          if (info!.isLoading.value == false) {
            _profileImagePath = info!.userProfile[info!.uuid]!['profileImage'];
            File imageFile = File(_profileImagePath!);
            if (!imageFile.existsSync()) {
              _profileImagePath = "assets/mainIcon.png";
            }
            _usernameController.text = info!.userProfile[info!.uuid]!['username'] ?? '';
            _addressController.text = info!.userProfile[info!.uuid]!['address'] ?? '';
            _phoneController.text = info!.userProfile[info!.uuid]!['number'] ?? '';
            setState(() {});
          }
        });
      }
    } else {
      debugPrint('Info or user profile is null.');
    }
  }

  Future<void> _pickImage() async {
    try {
      final PermissionStatus status = await Permission.manageExternalStorage.request();
      if (status.isGranted) {
        final ImagePicker _picker = ImagePicker();
        final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

        if (pickedFile != null) {
          setState(() {
            _profileImagePath = pickedFile.path;
            info!.updateUserProfile(
              _usernameController.text,
              _profileImagePath!,
              _addressController.text,
              _phoneController.text,
            );
            imageCache.clear();
          });
        }
      } else if (status.isDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Storage permission is required to pick an image.'), duration: Duration(seconds: 1)),
        );
      } else if (status.isPermanentlyDenied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Storage permission is permanently denied. Please enable it in settings.') ,duration: Duration(seconds: 1)),
        );
        openAppSettings();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while picking the image.'), duration: Duration(seconds: 1)),
      );
      debugPrint('Error in _pickImage: $e');
    }
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveProfile() {
    if (_usernameController.text.isEmpty || _profileImagePath == null ) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required.'), duration: Duration(seconds: 1)),
      );
      return;
    }

    try {
      info!.updateUserProfile(
        _usernameController.text,
        _profileImagePath!,
        _addressController.text,
        _phoneController.text,
      );

      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully.'), duration: Duration(seconds: 1)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while saving the profile.'), duration: Duration(seconds: 1)),
      );
      debugPrint('Error in _saveProfile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: info!.isLoading,
      builder: (context, isLoading, _) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Scaffold(
            backgroundColor: const Color(0xFFF8F8F8),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                'Profile',
                style: TextStyle(
                  fontStyle: FontStyle.italic,fontWeight: FontWeight.bold,color: Colors.black
                ),
              ),
              centerTitle: true,
              actions: [
                if (_isEditing)
                  IconButton(
                    icon: const Icon(Icons.save, color: Colors.blue),
                    onPressed: _saveProfile,
                  ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _isEditing ? _pickImage : null,
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage: _profileImagePath != null
                                  ? _profileImagePath!.contains('assets')
                                      ? AssetImage(_profileImagePath!) as ImageProvider
                                      : FileImage(File(_profileImagePath!))
                                  : AssetImage("assets/mainIcon.png"),
                            ),
                          ),
                          const SizedBox(height: 8),
                          _isEditing
                              ? TextField(
                                  controller: _usernameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Username',
                                  ),
                                )
                              : Text(
                                  _usernameController.text,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          GestureDetector(
                            onTap: _toggleEdit,
                            child: const Text(
                              'Edit profile',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _isEditing
                        ? TextField(
                            controller: _addressController,
                            decoration: const InputDecoration(
                              labelText: 'Address',
                            ),
                          )
                        : _addressController.text.isEmpty ? ListTile(
                              leading: Icon(Icons.warning, color: Colors.red),
                              title: Text(
                                'address not provided',
                                style: TextStyle(color: Colors.redAccent),
                              ),)
                            : ListTile(
                            title: const Text('Address'),
                            subtitle: Text(_addressController.text),
                          ),
                    const SizedBox(height: 10),
                    _isEditing
                        ? TextField(
                            controller: _phoneController,
                            decoration: const InputDecoration(
                              labelText: 'Phone Number',
                            ),
                          )
                        : _phoneController.text.isEmpty ? ListTile(
                              leading: Icon(Icons.warning, color: Colors.red),
                              title: Text(
                                'Number not provided',
                                style: TextStyle(color: Colors.redAccent),
                              ),)
                            : ListTile(
                            title: const Text('Phone Number'),
                            subtitle: Text(_phoneController.text),
                          ),
                    const SizedBox(height: 20),
                    const Text(
                      'Account Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildMenuItem('Change Password'),
                    const SizedBox(height: 20),
                    const Text(
                      'Help Center',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildMenuItem('FAQ'),
                    buildMenuItem('Contact Us'),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget buildMenuItem(String title) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
      onTap: () {
        if (title == 'Change Password') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PasswordResetGuideWidget(),
            ),
          );
        } else if (title == 'FAQ') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FAQPage(),
            ),
          );
        } else if (title == 'Contact Us') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactUsWidget(),
            ),
          );
        }
      },
    );
  }
}
