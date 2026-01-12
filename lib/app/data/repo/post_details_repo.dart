// lib/app/data/repo/post_details_repository.dart
import 'package:faithconnect/app/core/services/api_service.dart';
import 'package:faithconnect/app/data/model/post_comments_model.dart';

class PostDetailsRepository {
  final ApiService _api = ApiService();

  Future<List<PostCommentModel>> getComments(int postId) async {
    final res = await _api.get('/api/posts/$postId/comments');
    return (res.data as List)
        .map((e) => PostCommentModel.fromJson(e))
        .toList();
  }

  Future<void> addComment(int postId, String text) async {
    await _api.post(
      '/api/posts/$postId/comment',
      data: {'text': text},
    );
  }
}
