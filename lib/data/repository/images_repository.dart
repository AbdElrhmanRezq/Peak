import 'package:image_cropper/image_cropper.dart';
import 'package:repx/data/services/supabase_service.dart';

class ImagesRepository {
  SupabaseService _service = SupabaseService();

  Future<String> uploadProfileImage(CroppedFile file) async {
    try {
      final imageUrl = await _service.uploadImage(file, 'profile', 'profile');
      await _service.updateProfileImage(imageUrl);
      return imageUrl;
    } catch (e) {
      print('Error uploading profile image: $e');
      return '';
    }
  }

  Future<String> uploadWorkoutImage(CroppedFile file, int workoutId) async {
    try {
      final imageUrl = await _service.uploadImage(
        file,
        'workout',
        workoutId.toString(),
      );
      await _service.updateWorkoutImage(imageUrl, workoutId);
      return imageUrl;
    } catch (e) {
      print('Error uploading workout image: $e');
      return '';
    }
  }
}
