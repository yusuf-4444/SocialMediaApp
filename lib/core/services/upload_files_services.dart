import 'package:image_picker/image_picker.dart';

abstract class UploadFilesServices {
  Future<XFile?> uploadImageFromGallery();
  Future<XFile?> uploadImageFromCamera();
  Future<XFile?> uploadVideoFromGallery();
}

class UploadFilesServicesImpl implements UploadFilesServices {
  final ImagePicker _picker = ImagePicker();
  @override
  Future<XFile?> uploadImageFromGallery() async {
    return await _picker.pickImage(source: ImageSource.gallery);
  }

  @override
  Future<XFile?> uploadImageFromCamera() async {
    return await _picker.pickImage(source: ImageSource.camera);
  }

  @override
  Future<XFile?> uploadVideoFromGallery() async {
    return await _picker.pickVideo(source: ImageSource.gallery);
  }
}
