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
        backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
        title: Text(widget.title, style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            color: Colors.white60,
            onPressed: (() => _pickImage(source: ImageSource.gallery)),
            icon: Icon(Icons.photo_album),
          ),
          IconButton(
            color: Colors.white60,
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
            Text(
              "Photo dans ma galerie",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryFixed,
                fontSize: 22,
              ),
            ),
            Card(
              clipBehavior: Clip.antiAlias,
              color: Theme.of(context).colorScheme.onPrimaryFixed,
              margin: EdgeInsets.all(16),
              child: Container(
                height: size.width * 1.3,
                width: size.width * 0.9,
                child: (_images.isNotEmpty && _images.length > _index)
                    ? Image.file(_images[_index], fit: BoxFit.cover)
                    : SizedBox(
                        height: size.width * 0.7,
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
