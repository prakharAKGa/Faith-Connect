import 'package:faithconnect/app/core/services/api_service.dart';

class PostActionRepository {
  final ApiService _api = ApiService();

  Future<void> likePost(int postId) async {
    await _api.post('/api/posts/$postId/like');
  }

  Future<void> sharePost(int postId) async {
    await _api.post('/api/posts/$postId/share');
  }

  Future<void> commentPost(int postId, String text) async {
    await _api.post(
      '/api/posts/$postId/comment',
      data: {'text': text},
    );
  }
}
