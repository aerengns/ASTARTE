import 'dart:convert';
import 'dart:io';

import 'package:astarte/theme/colors.dart';
import 'package:astarte/utils/parameters.dart' as parameters;
import 'package:astarte/utils/workers_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NavBar extends StatefulWidget {
  const NavBar(BuildContext context, {Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(context) {
    final currentUser = Provider.of<parameters.CurrentUser>(context);
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(currentUser.username),
            accountEmail: Text(currentUser.email),
            currentAccountPicture: CircleAvatar(
              backgroundImage: currentUser.profilePhoto.image,
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
            ),
            onDetailsPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Profile(),
                ),
              );
            },
            arrowColor: const Color.fromRGBO(0, 0, 0, 0),
          ),
          ListTile(
            leading: const Icon(Icons.home_filled),
            title: const Text("Home"),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            onTap: () => Navigator.popUntil(context, ModalRoute.withName('/')),
          ),
          if (currentUser.userType != 'Worker')
            MyExpansionTile(
                title: const Text('Reports'),
                leading: const Icon(Icons.addchart),
                children: <Widget>[
                  ListTile(
                    title: const Text('Humidity Reports'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () =>
                        Navigator.pushNamed(context, '/humidity_report'),
                  ),
                  ListTile(
                    title: const Text('NPK Values Report'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () => Navigator.pushNamed(context, '/npk_report'),
                  ),
                  ListTile(
                    title: const Text('Temperatures Report'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () =>
                        Navigator.pushNamed(context, '/temperature_report'),
                  ),
                  ListTile(
                    title: const Text('PH Report'),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    onTap: () => Navigator.pushNamed(context, '/ph_report'),
                  ),
                ]),
          MyExpansionTile(
              title: const Text('Worker'),
              leading: const Icon(Icons.person_rounded),
              children: [
                ListTile(
                  leading: const Icon(Icons.people_alt_rounded),
                  title: const Text('Workers List'),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () => Navigator.pushNamed(context, '/workers'),
                ),
                if (currentUser.userType == 'Worker')
                  ListTile(
                    leading: const Icon(Icons.work_off_rounded),
                    title: const Text('Finish Job'),
                    trailing: const Icon(Icons.check_circle_rounded),
                    onTap: () => {
                      finishJob().then((returnVal) {
                        if (returnVal) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Successful'),
                          ));
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Unsuccessful'),
                          ));
                        }
                      })
                    },
                  ),
              ]),
          if (currentUser.userType != 'Worker')
            ListTile(
              leading: const Icon(Icons.warehouse_rounded),
              title: const Text('Farms'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () => Navigator.pushNamed(context, '/farms'),
            ),
          if (currentUser.userType != 'Worker')
            ListTile(
              leading: const Icon(Icons.attach_file),
              title: const Text('Logs'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () => Navigator.pushNamed(context, '/logs'),
            ),
          ListTile(
            leading: const Icon(Icons.calendar_month_rounded),
            title: const Text('Calendar'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            onTap: () => Navigator.pushNamed(context, '/calendar'),
          ),
          ListTile(
            leading: const Icon(Icons.pest_control),
            title: const Text('Pests and Diseases'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            onTap: () => Navigator.pushNamed(context, '/pests-and-diseases'),
          ),
          ListTile(
            leading: const Icon(Icons.help_rounded),
            title: const Text('Get Help'),
            trailing: const Icon(Icons.arrow_forward_ios_rounded),
            onTap: () => Navigator.pushNamed(context, '/posts'),
          ),
          const Divider(),
          ListTile(
            title: const Text('Sign Out'),
            leading: const Icon(Icons.logout_rounded),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              setState(() {
                parameters.TOKEN = '';
                currentUser.resetUser();
              });
              if (!mounted) return;
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.popAndPushNamed(context, '/sign_in');
            },
          ),
        ],
      ),
    );
  }
}

class AstarteAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AstarteAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: CustomColors.astarteRed,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class MyExpansionTile extends StatefulWidget {
  final Widget title;
  final Widget leading;
  final List<Widget> children;

  const MyExpansionTile(
      {super.key,
      required this.title,
      required this.leading,
      required this.children});

  @override
  MyExpansionTileState createState() => MyExpansionTileState();
}

class MyExpansionTileState extends State<MyExpansionTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: widget.title,
      leading: widget.leading,
      trailing: isExpanded
          ? const Icon(Icons.keyboard_arrow_down_rounded)
          : const Icon(Icons.arrow_forward_ios_rounded),
      onExpansionChanged: (bool expanding) =>
          setState(() => isExpanded = expanding),
      children: widget.children,
    );
  }
}

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<parameters.CurrentUser>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(currentUser.username),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const EditProfile()));
              },
              icon: const Icon(Icons.edit_rounded),
            )
          ],
        ),
        backgroundColor: CustomColors.astarteRed,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.chevron_left_rounded),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                minRadius: 75,
                maxRadius: 100,
                backgroundImage: currentUser.profilePhoto.image,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              currentUser.username,
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              currentUser.userType,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'About Me',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              currentUser.about,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {Key? key,
      required this.controller,
      required this.label,
      required this.hint,
      this.validator})
      : super(key: key);

  final TextEditingController controller;
  final String label;
  final String hint;

  String? defaultValidator(value) {
    if (value?.isEmpty == true) {
      return 'Input can not be empty';
    }
    return null;
  }

  String? Function(String? value)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator ?? defaultValidator,
      style: const TextStyle(
        color: CustomColors.astarteBlack,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: CustomColors.astarteRed,
        ),
        hintText: hint,
        prefixIcon: const Icon(
          Icons.person,
          color: CustomColors.astarteRed,
        ),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: CustomColors.astarteGrey,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: CustomColors.astarteRed),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: CustomColors.astarteLightBlue),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: CustomColors.astarteLightBlue),
        ),
      ),
    );
  }
}

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _aboutController = TextEditingController();
  final _emailController = TextEditingController();

  late Uint8List _image;

  bool init = true;

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<parameters.CurrentUser>(context);
    _nameController.text = currentUser.name;
    _surnameController.text = currentUser.surname;
    _emailController.text = currentUser.email;
    _aboutController.text = currentUser.about;
    if (init) {
      setState(() {
        _image = currentUser.profilePhotoBytes;
      });
      init = false;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.astarteRed,
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 400,
                height: 350,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      minRadius: 75,
                      maxRadius: 125,
                      backgroundImage: Image.memory(
                        _image,
                        fit: BoxFit.cover,
                      ).image,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: _takePhoto,
                          child: const Text('Take Photo'),
                        ),
                        ElevatedButton(
                          onPressed: _selectPhotoFromGallery,
                          child: const Text('Select Photo From Gallery'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _image = parameters.defaultImageBytes;
                            });
                          },
                          child: const Text('X'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              CustomTextFormField(
                controller: _nameController,
                label: 'Name',
                hint: 'Enter your name',
              ),
              CustomTextFormField(
                controller: _surnameController,
                label: 'Surname',
                hint: 'Enter your surname',
              ),
              CustomTextFormField(
                controller: _emailController,
                label: 'Email',
                hint: 'Enter your email',
                validator: (String? email) {
                  if (email == null) {
                    return null;
                  }
                  RegExp emailRegExp = RegExp(
                      r"^[a-zA-Z\d.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z\d](?:[a-zA-Z\d-]{0,253}[a-zA-Z\d])?(?:\.[a-zA-Z\d](?:[a-zA-Z\d-]{0,253}[a-zA-Z\d])?)*$");

                  if (email.isEmpty) {
                    return 'Email can\'t be empty';
                  } else if (!emailRegExp.hasMatch(email)) {
                    return 'Enter a correct email';
                  }

                  return null;
                },
              ),
              CustomTextFormField(
                controller: _aboutController,
                label: 'About',
                hint: 'Who are you?',
                validator: (value) => null,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final String response = await _saveProfile(currentUser);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(response),
                      ),
                    );
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill in necessary fields'),
                      ),
                    );
                  }
                },
                child: const Text('            Save            '),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _takePhoto() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image == null) return;

    final imageTemporary = File(image.path);
    setState(() => _image = imageTemporary.readAsBytesSync());
  }

  Future<void> _selectPhotoFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final imageTemporary = File(image.path);
    setState(() => _image = imageTemporary.readAsBytesSync());
  }

  Future<String> _saveProfile(currentUser) async {
    // Retrieve form field values
    final String name = _nameController.text;
    final String surname = _surnameController.text;
    final String email = _emailController.text;
    final String about = _aboutController.text;
    final Uint8List image = _image;

    String encodedImage = base64Encode(image);
    try {
      var headers = {
        'Authorization': parameters.TOKEN,
      };
      var request = http.MultipartRequest('POST',
          Uri.parse('${parameters.GENERAL_URL}api/v1/firebase/save_profile'))
        ..headers.addAll(headers)
        ..fields['name'] = name
        ..fields['surname'] = surname
        ..fields['email'] = email
        ..fields['about'] = about
        ..fields['profile_photo'] = encodedImage;

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String newMessage = await response.stream.bytesToString();
        final newCurrentUser =
            await parameters.requestCurrentUser(parameters.TOKEN);
        currentUser.setUser(newCurrentUser);
        return newMessage;
      } else {
        return response.reasonPhrase.toString();
      }
    } catch (e) {
      return e.toString();
    }
  }
}
