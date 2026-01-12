import 'package:faithconnect/app/core/services/api_service.dart';
import 'package:faithconnect/app/data/model/follower_model.dart';
import 'package:faithconnect/app/data/model/post_model.dart';

class LeaderHomeRepository {
  final ApiService _api = ApiService();

  /// My posts (Leader)
  Future<List<PostModel>> getMyPosts() async {
    final res = await _api.get('/api/posts/my-posts');
    return (res.data as List)
        .map((e) => PostModel.fromJson(e))
        .toList();
  }

  /// Followers list
  Future<List<FollowerModel>> getFollowers() async {
    final res = await _api.get('/api/leaders/my-followers');
    return (res.data as List)
        .map((e) => FollowerModel.fromJson(e))
        .toList();
  }
}
