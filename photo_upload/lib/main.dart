import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    ));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
  String message = "Not calculated yet";
}

class _HomeState extends State<Home> {
  List<XFile>? imageFileList = [];

  final ImagePicker picker = ImagePicker();

  // //we can upload image from camera or from gallery based on parameter
  // Future getImage(ImageSource media) async {
  //   var img = await picker.pickImage(source: media);

  //   setState(() {
  //     image = img;
  //   });
  // }
  void selectImages(ImageSource media) async {
    if (media == ImageSource.camera) {
      XFile? img = await picker.pickImage(source: media);
      imageFileList!.add(img!);
    } else {
      final List<XFile>? selectedImages = await picker.pickMultiImage();
      if (selectedImages!.isNotEmpty) {
        imageFileList!.addAll(selectedImages);
      }
    }
    print("Image List Length:" + imageFileList!.length.toString());
    setState(() {});
  }

  //show popup dialog
  void myAlert() {
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Please choose media to select'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      selectImages(ImageSource.gallery);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.image),
                        Text('From Gallery'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      selectImages(ImageSource.camera);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.camera),
                        Text('From Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                myAlert();
              },
              child: Text('Upload Photo'),
            ),
            ElevatedButton(
              child: Text('Get the percentage of growth!'),
              onPressed: () {
                print('Hello');
                uploadImage();
              },
            ),
            Text(widget.message),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                    itemCount: imageFileList!.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      return Image.file(
                        File(imageFileList![index].path),
                        fit: BoxFit.cover,
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Upload() async {
    XFile image = imageFileList![0];
    var stream = http.ByteStream(DelegatingStream.typed(image.openRead()));
    var length = await image.length();

    var uri = Uri.parse('http://127.0.0.1:8082/app/hello');

    var request = http.MultipartRequest("POST", uri);
    var multipartFile = http.MultipartFile('file', stream, length,
        filename: basename(image.path));
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    var response = await request.send();
    print(response.statusCode);
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  Future<void> uploadImage() async {
    // your token if needed
    try {
      var headers = {
        'Authorization': 'Bearer ' + "token",
      };
      // your endpoint and request method
      File selectedImage = File(imageFileList![0].path);
      var request = http.MultipartRequest(
          'POST', Uri.parse('http://127.0.0.1:8082/app/hello'));

      request.fields.addAll({
        'yourFieldNameKey1': 'yourFieldNameValue1',
        'yourFieldNameKey2': 'yourFieldNameValue2'
      });
      request.files.add(await http.MultipartFile.fromPath(
          'yourPictureKey', selectedImage.path));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String new_message = await response.stream.bytesToString();
        List<String> m_list = new_message.split(",");
        new_message = m_list.join("\n");
        setState(() {
          widget.message = new_message;
        });
        // widget.message = await response.stream.bytesToString();
        //print(widget.message);
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print(e);
    }
  }
}
