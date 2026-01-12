import 'package:faithconnect/app/core/services/api_service.dart';
import 'package:faithconnect/app/data/model/reel_comment_model.dart';

class ReelCommentRepository {
  final ApiService _api = ApiService();

  Future<List<ReelCommentModel>> getComments(int reelId) async {
    final res = await _api.get('/api/reels/$reelId/comments');
    return (res.data as List)
        .map((e) => ReelCommentModel.fromJson(e))
        .toList();
  }

  Future<void> addComment(int reelId, String text) async {
    await _api.post(
      '/api/reels/$reelId/comments',
      data: {'text': text},
    );
  }
}
