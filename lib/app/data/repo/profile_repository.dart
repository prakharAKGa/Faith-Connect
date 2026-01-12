import 'package:faithconnect/app/core/services/api_service.dart';
import 'package:faithconnect/app/data/model/profile_model.dart';

class ProfileRepository {
  final ApiService _api = ApiService();

  Future<ProfileModel> getMyProfile() async {
    final response = await _api.get('/api/users/profile');
    return ProfileModel.fromJson(response.data);
  }
}
