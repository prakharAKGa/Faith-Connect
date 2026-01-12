import 'package:faithconnect/app/core/services/api_service.dart';
import 'package:faithconnect/app/data/model/post_model.dart';

class PostRepository {
  final ApiService _api = ApiService();

  Future<List<PostModel>> getExplorePosts() async {
    final res = await _api.get('/api/posts/explore');
    return (res.data as List)
        .map((e) => PostModel.fromJson(e))
        .toList();
  }

  Future<List<PostModel>> getFollowingPosts() async {
    final res = await _api.get('/api/posts/following');
    return (res.data as List)
        .map((e) => PostModel.fromJson(e))
        .toList();
  }
}
