import 'dart:convert';
import 'dart:io';
import 'package:astarte/network_manager/models/post.dart';
import 'package:astarte/network_manager/services/posts_service.dart';
import 'package:astarte/theme/colors.dart';
import 'package:astarte/utils/parameters.dart' as parameters;
import 'package:flutter/material.dart';
import 'package:astarte/sidebar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewPost extends StatelessWidget {
  const NewPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Create New Post'),
          backgroundColor: CustomColors.astarteRed,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )
      ),
      body: const NewPostForm(),
      drawer: NavBar(context),
    );
  }
}

class NewPostForm extends StatefulWidget {
  const NewPostForm({Key? key}) : super(key: key);

  @override
  State<NewPostForm> createState() => _NewPostFormState();
}

class _NewPostFormState extends State<NewPostForm> {
  final _formKey = GlobalKey<FormState>();

  String _postText = '';
  File? _image = null;

  Future<void> _takePhoto() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image == null) return;

    final imageTemporary = File(image.path);
    setState(() => _image = imageTemporary);
  }

  Future<void> _selectPhotoFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final imageTemporary = File(image.path);
    setState(() => _image = imageTemporary);
  }

  void _savePost() async {
    if (_formKey.currentState!.validate()) {
      String? encodedImage;
      final image = _image;
      if (image != null) {
        encodedImage = base64Encode(image.readAsBytesSync());
      }
      final response = await Provider.of<PostsService>(context, listen: false)
          .createPost(
          PostData(
                  (b) => b
                    ..image = encodedImage
                    ..message = _postText
                    ..username = Provider.of<parameters.CurrentUser>(context).username;
          )
      );

      if (response.isSuccessful) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Created a new post successfully'),
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create a new post, please try again}'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in necessary fields'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.all(30),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row (
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: _takePhoto,
                      child: const Text('Take Photo'),
                    ),
                    ElevatedButton(
                      onPressed: _selectPhotoFromGallery,
                      child: const Text('Select Photo From Gallery'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 40,
                ),
                _image == null
                    ? const Text('No image selected.')
                    : Image.file(_image!),
                TextFormField(
                  validator: (value) {
                    if (value?.isEmpty == true) {
                      return 'Please enter a value';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _postText = value;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    labelText: 'Question',
                    hintText: 'Ask a question',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        _savePost();
                      },
                      child: const Text('Create Post', style: TextStyle(fontSize: 16)),
                    ),
                  ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
