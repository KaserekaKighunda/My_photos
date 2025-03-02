import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Mes photos'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<File> _images = [];
  int _index = 0;
  Future<void> _pickImage({required ImageSource source}) async {
    ImagePicker picker = ImagePicker();
    XFile? xFile = await picker.pickImage(source: source);
    if (xFile != null) {
      setState(() {
        String path = xFile.path;
        File? file = File(path);
        if (file != null) {
          _images.add(file);
        }
      });
    }
  }

  void _removePicture(File file) {
    setState(() {
      _images.remove(file);
    });
  }

  void _updateIndex(File file) {
    setState(() {
      _index = _images.indexOf(file);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: (() => _pickImage(source: ImageSource.gallery)),
            icon: Icon(Icons.photo_album),
          ),
          IconButton(
            onPressed: (() => _pickImage(source: ImageSource.camera)),
            icon: Icon(Icons.camera_alt),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 128,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _images.map((img) {
                    return InkWell(
                      onTap: (() => _updateIndex(img)),
                      onLongPress: (() => _removePicture(img)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: CircleAvatar(
                          radius: 54,
                          backgroundImage: FileImage(img),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Divider(),
            Card(
              clipBehavior: Clip.antiAlias,
              //color: Theme.of(context).colorScheme.onPrimary,
              margin: EdgeInsets.all(16),
              child: Container(
                  height: size.width * 0.7,
                  width: size.width * 0.7,
                  child: (_images.isNotEmpty && _images.length > _index)
                      ? Image.file(_images[_index], fit: BoxFit.cover)
                      : SizedBox(
                          height: size.width * 0.7,
                        )),
            )
          ],
        ),
      ),
    );
  }
}
