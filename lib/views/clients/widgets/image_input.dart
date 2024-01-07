import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final double width, height;
  final XFile? image;

  const ImageInput(
      {Key? key, required this.width, required this.height, this.image})
      : super(key: key);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  XFile? image;

  @override
  void initState() {
    super.initState();
    image = widget.image;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 20,
        ),
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(width: 1, color: Colors.grey[400]!),
          shape: BoxShape.circle,
        ),
        child: image == null
            ? const Icon(
                Icons.add_a_photo,
                size: 40,
              )
            : ClipOval(
                child: Image.file(
                  File(
                    image!.path,
                  ),
                ),
              ),
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            final imagePicker = ImagePicker();
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Material(
                      child: ListTile(
                        title: const Text(
                          'Galeria',
                        ),
                        trailing: const Icon(Icons.image),
                        onTap: () async {
                          final pickedImage = await imagePicker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (pickedImage == null) {
                            return;
                          }
                          setState(() => image = pickedImage);
                          if (!context.mounted) {
                            return;
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    Material(
                      child: ListTile(
                        title: const Text(
                          'Câmera',
                        ),
                        trailing: const Icon(Icons.camera_alt),
                        onTap: () async {
                          final pickedImage = await imagePicker.pickImage(
                            source: ImageSource.camera,
                            preferredCameraDevice: CameraDevice.front,
                          );
                          if (pickedImage == null) {
                            return;
                          }
                          setState(() => image = pickedImage);
                          if (!context.mounted) {
                            return;
                          }
                          Navigator.pop(context);
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          backgroundColor: Colors.white,
        );
      },
    );
  }
}
