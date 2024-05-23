import 'package:bookmaster/data/texts.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

class Initial extends StatefulWidget {
  const Initial({super.key});

  @override
  State<Initial> createState() => _InitialState();
}

class _InitialState extends State<Initial> {
  final _fileExtensionController = TextEditingController();
  String? _extension;
  bool _isLoading = false;
  String? _directoryPath;
  String? _fileName;
  String? _path;
  String? _saveAsFileName;
  bool _userAborted = false;
  bool _isSelected = false;
  File? _book;

  @override
  void initState() {
    super.initState();
    _fileExtensionController
        .addListener(() => _extension = _fileExtensionController.text);
  }

  Future getBook() async {
    _resetState();
    try {
      final pickedBook = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'doc']);

      setState(() {
        if (pickedBook != null) {
          _book = File(pickedBook.files.single.path!);
          _path = pickedBook.files.single.path;
          _fileName = basename(_path!);
          _isSelected = true;
        } else {
          print(noBookSelected);
        }
      });
    } on PlatformException catch (e) {
      print('Unsupported operation' + e.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  String? _getFileName(String path) {}

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isSelected = false;
      _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _path = null;
      _saveAsFileName = null;
      _userAborted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              welcome,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(insertBook),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: getBook, child: const Text(insertBookButton)),
            const SizedBox(
              height: 15,
            ),
            if (_isSelected) Text(_fileName!),
          ],
        )),
      ),
    );
  }
}
