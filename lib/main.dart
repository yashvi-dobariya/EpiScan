// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:tflite/tflite.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Image Classification Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: ImageClassificationScreen(),
//     );
//   }
// }
//
// class ImageClassificationScreen extends StatefulWidget {
//   @override
//   _ImageClassificationScreenState createState() => _ImageClassificationScreenState();
// }
//
// class _ImageClassificationScreenState extends State<ImageClassificationScreen> {
//   List _output = [];
//   File? _image;
//   bool _loading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     loadModel();
//   }
//
//   // Load TFLite model
//   loadModel() async {
//     await Tflite.loadModel(
//       model: "assets/skin_model.tflite",
//       labels: "assets/labels.txt",
//     );
//   }
//
//   // Function to handle image selection from gallery
//   selectFromGallery() async {
//     final picker = ImagePicker();
//     final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//
//     setState(() {
//       if (pickedFile != null) {
//         _image = File(pickedFile.path);
//        // _loading = true;
//         // Perform inference on the selected image
//         classifyImage(_image!);
//       } else {
//         print('No image selected.');
//       }
//     });
//   }
//
//   classifyImage(File imageFile) async {
//     print("classifying");
//     String result;
//
//     var pred = await Tflite.runModelOnImage(
//       path: imageFile.path,
//       numResults: 2,
//       threshold: 0.8,
//     );
//
//     setState(() {
//       _loading = false;
//       _output = pred ?? [];
//     });
//
//     print(_output[0]);
//
//     if (_output[0] == Null) {
//       result = "Please select image";
//     } else {
//       result = _output[0]['label'].toString().substring(2);
//     }
//     print(result);
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Classification Demo'),
//       ),
//       body: Center(
//         child: _loading
//             ? CircularProgressIndicator()
//             : _image == null
//             ? Text('No image selected.')
//             : Column(
//              mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//               Image.file(_image!),
//               SizedBox(height: 20),
//                 Text('Prediction: ${_output.isNotEmpty ? _output[0]['label'] : 'No prediction'}')
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: selectFromGallery,
//         tooltip: 'Select Image',
//         child: Icon(Icons.image),
//       ),
//     );
//   }
// }

// ignore_for_file: sized_box_for_whitespace, file_names
import "dart:io";
import 'package:episcan/result.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'skin disease',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const Classification(),
    );
  }
}

class Classification extends StatefulWidget {
  const Classification({Key? key}) : super(key: key);

  @override
  State<Classification> createState() => _ClassificationState();
}

class _ClassificationState extends State<Classification> {
  List _output = [];
  File? _image;

  // ignore: non_constant_identifier_names
  detect_image(File image) async {
    String result;
    String accuracy;
    var pred = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.8,
      imageStd: 127.5,
      imageMean: 127.5,
    );

    setState(() {
      _output = pred ?? [];
    });

    print(_output[0]);

    if (_output[0] == Null) {
      result = "Please select image";
      accuracy = "0 %";
    } else {
      result = _output[0]['label'].toString().substring(2);
      accuracy = (_output[0]['confidence'] * 100).toStringAsFixed(0) + '%';
    }

    // ignore: use_build_context_synchronously
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => showResult(result:result, accuracy: accuracy,)));
  }

  @override
  void initState() {
    super.initState();
    loadmodel();
  }

  loadmodel() async {
    await Tflite.loadModel(
      model: "assets/my_model.tflite",
      labels: "assets/labels.txt",
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  final ImagePicker _imagePicker = ImagePicker();

  _gallery(BuildContext context) async {
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    } else {
      _image = File(image.path);
    }
    detect_image(_image!);
  }


  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    var w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFDA9C68),
        title: Text(
          "skin detect",
        ),
      ),
      body: Container(
        height: h,
        width: w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 25),
            SizedBox(
              height: 200,
              width: 200,
              child: Image.asset("assets/skin_disease.png"),
            ),
            const SizedBox(height: 25),
            const Text(
              "Please upload or click the photo",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),
            ),
            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              height: 70,
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () => _gallery(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFDA9C68),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Gallery",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
