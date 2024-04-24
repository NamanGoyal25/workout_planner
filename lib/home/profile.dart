import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';


Future<void> _signOut(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    // Navigate to login page or any other page after signout
    Navigator.pushReplacementNamed(context, '/login');
  } catch (e) {
    print("Error signing out: $e");
  }
}

Future<void> _showSignOutConfirmationDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Color(0xff2a2b2d),
        surfaceTintColor: Color(0xff2a2b2d),
        titleTextStyle: GoogleFonts.montserrat(),
        title: Text(
          'Confirm Sign Out',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        content: SingleChildScrollView(
          padding: EdgeInsets.all(10),
          child: ListBody(
            children: const <Widget>[
              Text(
                'Are you sure you want to sign out?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Sign Out'),
            onPressed: () {
              _signOut(context); // Call signout function with context
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? _name;
  String? _email;
  int? _phoneNumber;
  int? _age;
  String? _gender;
  String? _profileImageUrl; // Added to hold profile image URL

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title:Text('Profile',
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(user!.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            var userData = snapshot.data!.data() as Map<String, dynamic>;
            _name = userData['name'];
            _email = userData['email'];
            _phoneNumber = userData['phone number'];
            _age = userData['age'];
            _gender = userData['gender'];
            _profileImageUrl = userData['profileImageUrl']; // Get profile image URL

            return SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height*0.02),

                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_profileImageUrl != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FullScreenImage(imageUrl: _profileImageUrl!),
                                ),
                              );
                            } else {
                              _selectProfilePicture();
                            }
                          },
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey,
                            child: _profileImageUrl != null
                                ? ClipOval(
                              child: Image.network(
                                _profileImageUrl!,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            )
                                : Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 65,
                            ),
                          ),
                        ),
                        Positioned(
                          top: -1,
                          right: -2,
                          child: PopupMenuButton(
                            offset: Offset(200,35),
                            elevation: 8,
                            color: Color(0xff1c1c1e),
                            surfaceTintColor: Color(0xff1c1c1e),
                            itemBuilder: (BuildContext context) => [
                              PopupMenuItem(
                                child: ListTile(
                                  leading: Icon(Icons.delete),
                                  title: Text('Remove Photo'),
                                  onTap: () {
                                    _removeProfilePhoto();
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              PopupMenuItem(
                                child: ListTile(
                                  leading: Icon(Icons.upload),
                                  title: Text('Upload Photo'),
                                  onTap: () {
                                    _selectProfilePicture();
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xff1c1c1e),
                              ),
                              padding: EdgeInsets.all(6),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height*0.05),

                    buildInfoRow(Icons.person, "Name", _name ?? 'Data not available', context, () {
                      _showStringInputBottomSheet(context, "Enter Name", (value) {
                        setState(() {
                          _name = value;
                        });
                        _updateUserData(user.uid, {'name': value});
                      });
                    }),
                    SizedBox(height: MediaQuery.of(context).size.height*0.03),
                    buildInfoRow(Icons.mail_rounded, "Email", _email ?? 'Data not available', context, () {
                      _showStringInputBottomSheet(context, "Enter Email", (value) {
                        setState(() {
                          _name = value;
                        });
                        _updateUserData(user.uid, {'name': value});
                      });
                      // No need to edit email
                    }),
                    SizedBox(height: MediaQuery.of(context).size.height*0.03),
                    buildInfoRow(Icons.perm_contact_cal, "Phone Number", _phoneNumber != null ? _phoneNumber.toString() : 'Data not available', context, () {
                      _showIntInputBottomSheet(context, "Enter Phone Number", (value) {
                        setState(() {
                          _phoneNumber = value;
                        });
                        _updateUserData(user.uid, {'phone number': value});
                      });
                    }),
                    SizedBox(height: MediaQuery.of(context).size.height*0.03),
                    buildInfoRow(Icons.cake, "Age", _age != null ? _age.toString() : 'Age not available', context, () {
                      _showIntInputBottomSheet(context, "Enter Age", (value) {
                        setState(() {
                          _age = value;
                        });
                        _updateUserData(user.uid, {'age': value});
                      });
                    }),
                    SizedBox(height: MediaQuery.of(context).size.height*0.03),
                    buildInfoRow(Icons.male, "Gender", _gender ?? 'Data not available', context, () {
                      _showRadioInputBottomSheet(context, "Select Gender", ["Male", "Female"], (value) {
                        setState(() {
                          _gender = value;
                        });
                        _updateUserData(user.uid, {'gender': value});
                      });
                    }),

                    SizedBox(height: MediaQuery.of(context).size.height*0.03),

                    Container(
                      padding: EdgeInsets.all(1.0),
                      width: MediaQuery.of(context).size.width * 0.9, // Adjust width with MediaQuery
                      // Set a fixed height or adjust with MediaQuery
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        gradient: LinearGradient(
                          colors: [
                            Colors.purple,
                            Colors.deepPurple,
                            Colors.purple,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          _showSignOutConfirmationDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent, // Set transparent color
                          elevation: 0, // Remove shadow
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          'Sign Out',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height*0.03),

                  ],
                ),
              ),

            );
          }
        },
      ),
    );
  }

  Widget buildInfoRow(IconData icon, String title, String value, BuildContext context, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15.0),
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          color: Color(0xff1c1c1e).withOpacity(0.5),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.deepPurple,
              size: 17,
            ),
            SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(color: Colors.white.withOpacity(0.5)),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.end,
              ),
            ),
            SizedBox(width: 10),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.5),
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  void _showStringInputBottomSheet(BuildContext context, String title, Function(String) onSubmit) {
    TextEditingController controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            color: Colors.black87.withOpacity(0.8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                SizedBox(height: 20),
                Text(
                  title,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 20.0),

                Container(
                  width: MediaQuery.of(context).size.width*0.9,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Color(0xff1c1c1e).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: title,
                      border: InputBorder.none, // Remove border
                      enabledBorder: InputBorder.none, // Remove border when enabled
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),

                SizedBox(height: 20.0),

                Container(
                  padding: EdgeInsets.all(1.0),
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple,
                        Colors.deepPurple,
                        Colors.purple,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent.withOpacity(0.01),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      String value = controller.text;
                      onSubmit(value);
                      Navigator.pop(context);
                    },
                  ),
                ),

                SizedBox(height: 20)

              ],
            ),
          ),
        );
      },
    );
  }

  void _showIntInputBottomSheet(BuildContext context, String title, Function(int) onSubmit) {
    TextEditingController controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            color: Colors.black87.withOpacity(0.8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  title,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.0),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Color(0xff1c1c1e).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: title,
                      border: InputBorder.none, // Remove border
                      enabledBorder: InputBorder.none, // Remove border when enabled
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),

                SizedBox(height: 20.0),
                Container(
                  padding: EdgeInsets.all(1.0),
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple,
                        Colors.deepPurple,
                        Colors.purple,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent.withOpacity(0.01),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      int value = int.tryParse(controller.text) ?? 0;
                      onSubmit(value);
                      Navigator.pop(context);
                    },
                  ),
                ),

                SizedBox(height: 20)

              ],
            ),
          ),
        );
      },
    );
  }


  void _showRadioInputBottomSheet(BuildContext context, String title, List<String> options, Function(String) onSubmit) {
    String? selectedOption;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              color: Colors.black87.withOpacity(0.8),
              // height: MediaQuery.of(context).size.height*0.4,
              padding:EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[

                  SizedBox(height: 30.0),

                  Text(
                    title,
                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 15.0),

                  Column(
                    children: options.map((option) {
                      return ListTile(
                        title: Text(option),
                        leading: Radio(
                          value: option,
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value as String?;
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            selectedOption = option;
                          });
                        },
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 20.0),

                  Container(
                    padding: EdgeInsets.all(5.0),
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.purple,
                          Colors.deepPurple,
                          Colors.purple,
                        ], // Example gradient colors
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)
                          )
                      ),
                      onPressed: () {
                        onSubmit(selectedOption ?? '');
                        Navigator.pop(context);
                      },
                      child: Text('Submit',style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),),
                    ),
                  ),

                  SizedBox(height: 20)

                ],
              ),
            );
          },
        );
      },
    );
  }

  // Function to select and upload profile picture
  void _selectProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      // Upload image file to Firebase Storage and get download URL
      String imageUrl = await uploadImageToFirebaseStorage(imageFile);
      // Update profile image URL in Firestore
      _updateUserData(FirebaseAuth.instance.currentUser!.uid, {'profileImageUrl': imageUrl});
      setState(() {
        _profileImageUrl = imageUrl; // Update UI with new profile image
      });
    }
  }

  void _removeProfilePhoto() {
    // Update the database
    _updateUserData(FirebaseAuth.instance.currentUser!.uid, {'profileImageUrl': null}); // Set profile image URL to null
    // Update the UI
    setState(() {
      _profileImageUrl = null;
    });
  }

  // Function to upload image to Firebase Storage
  Future<String> uploadImageToFirebaseStorage(File imageFile) async {
    String fileName = basename(imageFile.path);
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child('profile_images/$fileName');
    UploadTask uploadTask = firebaseStorageRef.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  void _updateUserData(String userId, Map<String, dynamic> dataToUpdate) {
    FirebaseFirestore.instance.collection('users').doc(userId).update(dataToUpdate)
        .then((_) => print('User data updated successfully'))
        .catchError((error) => print('Error updating user data: $error'));
  }
}
class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Picture',style:GoogleFonts.montserrat()),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Hero(
            tag: 'fullscreen_image',

            child: Image.network(
              imageUrl,
            ),
          ),
        ),
      ),
    );
  }
}