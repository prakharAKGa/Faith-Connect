import 'package:faithconnect/app/core/services/api_service.dart';
import 'package:faithconnect/app/data/model/leader_details_model.dart';
import 'package:faithconnect/app/data/model/leader_model.dart';

class LeaderRepository {
  final ApiService _api = ApiService();

  /// 🔍 EXPLORE LEADERS
  /// 
  Future<LeaderDetailsModel?> getLeaderDetails(int id) async {
    final res = await _api.get('/api/users/leader/$id');
    return LeaderDetailsModel.fromJson(res.data['data']);
  }

  Future<List<LeaderModel>> getAllLeaders() async {
    final res = await _api.get('/api/users/leaders');

    return (res.data as List)
        .map((e) => LeaderModel.fromJson(e))
        .toList();
  }

  /// ⭐ MY FOLLOWING (Worshiper)
  Future<List<LeaderModel>> getMyFollowing() async {
    final res = await _api.get('/api/follow/my-following');

    return (res.data as List)
        .map((e) => LeaderModel.fromJson(e))
        .toList();
  }

  Future<void> followLeader(int leaderId) async {
    await _api.post('/api/follow/$leaderId');
  }

  Future<void> unfollowLeader(int leaderId) async {
    await _api.delete('/api/follow/$leaderId');
  }
}
