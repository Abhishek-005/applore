import 'dart:io';
import '/providers/user_data_provider.dart';
import '/views/widgets/success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../widgets/processing_dialog.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var image;
  Map<dynamic, dynamic> productMap = {};
  String originalImageSize = '';
  String compressedImageSize = '';

  late bool isAdding;

  Future cropImage(context) async {
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    File file = File(image.path);
    originalImageSize =
        (file.readAsBytesSync().length / (1024 * 1024)).toStringAsFixed(2);
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        cropStyle: CropStyle.rectangle,
        compressFormat: ImageCompressFormat.jpg,
        maxHeight: 400,
        maxWidth: 400,
        compressQuality: 50,
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop image',
          toolbarColor: Theme.of(context).primaryColor,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          showCropGrid: false,
          lockAspectRatio: true,
          statusBarColor: Theme.of(context).primaryColor,
        ),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
          aspectRatioLockEnabled: true,
        ));

    if (croppedFile != null) {
      compressedImageSize =
          (croppedFile.readAsBytesSync().lengthInBytes / (1024 * 1024))
              .toStringAsFixed(2);
      setState(() {
        image = croppedFile;
      });
    } else {}
  }

  addProduct() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      showDialog(
          context: context,
          builder: (context) => const ProcessingDialog(
                message: 'Adding....',
              ));

      if (image != null) {
        productMap.putIfAbsent('Image', () => image);
        print(productMap);
        isAdding = true;
        context
            .read<UserDataProvider>()
            .addNewProduct(productMap)
            .then((value) {
          if (value) {
            Navigator.pop(context);
            showDialog(
                context: context,
                builder: (context) => const CustomSuccessDialog(
                      message: 'Added',
                    ));
          }
        });
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.maybeOf(context)!.size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Product Image',
                      style: GoogleFonts.poppins(
                        //color: Colors.black87,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  image != null
                      ? Center(
                          child: SizedBox(
                            width: size.width * 0.4,
                            height: size.width * 0.4,
                            child: Stack(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.file(
                                    image,
                                  ),
                                ),
                                Positioned(
                                  top: 5.0,
                                  right: 5.0,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      6.0,
                                    ),
                                    child: Material(
                                      color: Colors.red,
                                      child: InkWell(
                                        splashColor:
                                            Colors.white.withOpacity(0.4),
                                        onTap: () {
                                          //remove image
                                          setState(() {
                                            image = null;
                                          });
                                        },
                                        child: const SizedBox(
                                          width: 28.0,
                                          height: 28.0,
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 18.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 15.0,
                  ),
                  if (originalImageSize.isNotEmpty)
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: "Original Size: $originalImageSize mb",
                          style: GoogleFonts.poppins(color: Colors.red)),
                      TextSpan(
                          text: "\nCompressed Size: $compressedImageSize mb",
                          style: GoogleFonts.poppins(color: Colors.red)),
                    ])),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Container(
                    height: 45.0,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      onPressed: () {
                        //add product
                        cropImage(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(
                            Icons.add_a_photo,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            image == null ? 'Add Image' : 'Change Image',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25.0,
                  ),
                  TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return 'Product name is required';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      setState(() {
                        productMap.update(
                          'name',
                          (oldVal) => val!.trim(),
                          ifAbsent: () => val!.trim(),
                        );
                      });
                    },
                    enableInteractiveSelection: false,
                    style: GoogleFonts.poppins(
                      //color: Colors.black,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15.0),
                      helperStyle: GoogleFonts.poppins(
                        //color: Colors.black.withOpacity(0.65),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                      errorStyle: GoogleFonts.poppins(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                      hintStyle: GoogleFonts.poppins(
                        //color: Colors.black54,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                      labelText: 'Product name',
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return 'Price is required';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      setState(() {
                        productMap.update(
                          'price',
                          (oldVal) => double.parse(val!.trim()),
                          ifAbsent: () => double.parse(val!.trim()),
                        );
                      });
                    },
                    enableInteractiveSelection: false,
                    style: GoogleFonts.poppins(
                      //color: Colors.black,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15.0),
                      helperStyle: GoogleFonts.poppins(
                        //color: Colors.black.withOpacity(0.65),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                      errorStyle: GoogleFonts.poppins(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                      hintStyle: GoogleFonts.poppins(
                        //color: Colors.black54,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                      labelText: 'Price',
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    validator: (val) {
                      if (val!.trim().isEmpty) {
                        return 'Discription is required';
                      }
                      return null;
                    },
                    onSaved: (val) {
                      setState(() {
                        productMap.update(
                          'description',
                          (oldVal) => val!.trim(),
                          ifAbsent: () => val!.trim(),
                        );
                      });
                    },
                    enableInteractiveSelection: false,
                    style: GoogleFonts.poppins(
                      //color: Colors.black,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15.0),
                      helperStyle: GoogleFonts.poppins(
                        //color: Colors.black.withOpacity(0.65),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                      errorStyle: GoogleFonts.poppins(
                        fontSize: 13.0,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                      hintStyle: GoogleFonts.poppins(
                        //color: Colors.black54,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                      labelText: 'Discription',
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  SizedBox(
                    height: 45.0,
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async {
                        addProduct();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(
                            Icons.send_sharp,
                            color: Colors.white,
                            size: 20.0,
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text(
                            'Add Product',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
