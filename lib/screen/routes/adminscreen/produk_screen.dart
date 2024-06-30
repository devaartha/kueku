// ignore_for_file: library_private_types_in_public_api

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kueku/endpoints/kue.dart';
import 'package:kueku/screen/routes/adminscreen/home_admin_screen.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  final _namaController = TextEditingController();
  final _kategoriIdController = TextEditingController();
  final _hargaController = TextEditingController();
  final _stokController = TextEditingController();
  String _nama = "";
  int _kategoriId = 0;
  int _harga = 0;
  int _stok = 0;
  File? galleryFile;
  final picker = ImagePicker();

  _showPicker({
    required BuildContext context,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future getImage(
    ImageSource img,
  ) async {
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    setState(
      () {
        if (xfilePick != null) {
          galleryFile = File(pickedFile!.path);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(// is this context <<<
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }

  @override
  void dispose() {
    _namaController.dispose(); // Dispose of controller when widget is removed
    _kategoriIdController
        .dispose(); // Dispose of controller when widget is removed
    _hargaController.dispose(); // Dispose of controller when widget is removed
    _stokController.dispose(); // Dispose of controller when widget is removed
    super.dispose();
  }

  saveData() {
    debugPrint(_nama);
    debugPrint(_harga.toString());
    debugPrint(_kategoriId.toString());
    debugPrint(_stok.toString());
  }

  Future<void> _postDataWithImage(BuildContext context) async {
    String? token =  await _secureStorage.read(key: 'jwt_token');
    if (galleryFile == null) {
      return; // Handle case where no image is selected
    }

    var request = MultipartRequest('POST', Uri.parse(Endpoints.kue));
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.fields['nama_kue'] = _namaController.text; // Add other data fields
    request.fields['id_kategori'] =
        _kategoriIdController.text; // Add other data fields
    request.fields['stok'] = _stokController.text; // Add other data fields
    request.fields['harga'] = _hargaController.text; // Add other data fields

    var multipartFile = await MultipartFile.fromPath(
      'kue_image',
      galleryFile!.path,
    );
    request.files.add(multipartFile);

    request.send().then((response) async{
      // Handle response (success or error)
      if (response.statusCode == 201) {
        debugPrint('Data and image posted successfully!');
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AdminScreen()));
      } else {
        print( await response.stream.bytesToString());
        debugPrint('Error posting data: ${response.statusCode}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        title: null,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white), // recolor the icon
      ),
      // ignore: sized_box_for_whitespace
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Create kue",
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    "Fill the form below, make sure you upload the images",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showPicker(context: context);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200))),
                              width: double.infinity, // Fill available space
                              height: 150, // Adjust height as needed
                              // color: Colors.grey[200], // Placeholder color
                              child: galleryFile == null
                                  ? Center(
                                      child: Text('Pick your Image here',
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: const Color.fromARGB(
                                                255, 124, 122, 122),
                                            fontWeight: FontWeight.w500,
                                          )))
                                  : Center(
                                      child: Image.file(galleryFile!),
                                    ), // Placeholder text
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey.shade200))),
                            child: TextField(
                              controller: _namaController,
                              decoration: const InputDecoration(
                                  hintText: "Nama Kue",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none),
                              onChanged: (value) {
                                // Update state on text change
                                setState(() {
                                  _nama =
                                      value; // Update the _title state variable
                                });
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey.shade200))),
                            child: TextField(
                              controller: _kategoriIdController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintText: "Kategori ID",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none),
                              onChanged: (value) {
                                // Update state on text change
                                setState(() {
                                  _kategoriId =
                                      int.parse(value); // Update the _title state variable
                                });
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey.shade200))),
                            child: TextField(
                              controller: _stokController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintText: "Stok",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none),
                              onChanged: (value) {
                                // Update state on text change
                                setState(() {
                                  _stok =
                                      int.parse(value); // Update the _title state variable
                                });
                              },
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey.shade200))),
                            child: TextField(
                              controller: _hargaController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintText: "Harga",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  border: InputBorder.none),
                              onChanged: (value) {
                                // Update state on text change
                                setState(() {
                                  _harga =
                                      int.parse(value); // Update the _title state variable
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
        tooltip: 'Increment',
        onPressed: () {
          _postDataWithImage(context);
        },
        child: const Icon(Icons.save, color: Colors.white, size: 28),
      ),
    );
  }
}
