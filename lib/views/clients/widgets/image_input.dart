import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'dart:typed_data';

class ImageInputController extends GetxController {
  // Rx<XFile?> image = Rx<XFile?>(null);
  Rx<Uint8List?> imageData = Rx<Uint8List?>(null);
  
  RxBool picked = false.obs;
}

class ImageInput extends StatelessWidget {
  final double width, height;

  const ImageInput({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    final ImageInputController imageController = Get.find();
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: 20,
        ),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(width: 1, color: Colors.grey[400]!),
          shape: BoxShape.circle,
        ),
        child: Obx(() => imageController.picked.value
          ? 
          FittedBox(
            fit: BoxFit.cover,
            child: CircleAvatar(
              backgroundImage: Image.memory(
                      imageController.imageData.value!)
                  .image,
              radius: 20,
            ),
          )
          :
          const Icon(
            Icons.add_a_photo,
            size: 40,
          )
        )
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
                          imageController.picked.value = true;
                          imageController.imageData.value = await pickedImage.readAsBytes();
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
                          imageController.picked.value = true;
                          imageController.imageData.value = await pickedImage.readAsBytes();
                          if (!context.mounted) {
                            return;
                          }
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    imageController.picked.value ?
                      Material(
                        child: ListTile(
                          title: const Text(
                            'Limpar',
                          ),
                          trailing: const Icon(Icons.delete, color: Colors.red,),
                          onTap: () {
                            imageController.picked.value = false;
                            imageController.imageData.value = null;
                            Navigator.pop(context);
                          },
                        ),
                      ) : Container()
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
