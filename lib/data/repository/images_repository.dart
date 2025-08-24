import 'package:image_cropper/image_cropper.dart';
import 'package:repx/data/services/supabase_service.dart';

class ImagesRepository {
  SupabaseService _service = SupabaseService();

  Future<String> uploadProfileImage(CroppedFile file) async {
    try {
      final imageUrl = await _service.uploadImage(file);
      await _service.updateProfileImage(imageUrl);
      return imageUrl;
    } catch (e) {
      print('Error uploading profile image: $e');
      return '';
    }
  }
}
