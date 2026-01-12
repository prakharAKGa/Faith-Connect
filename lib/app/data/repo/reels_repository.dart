import 'package:faithconnect/app/core/services/api_service.dart';
import 'package:faithconnect/app/data/model/reel_model.dart';

class ReelsRepository {
  final ApiService _api = ApiService();

  Future<List<ReelModel>> getReels() async {
    final res = await _api.get('/api/reels');
    return (res.data as List)
        .map((e) => ReelModel.fromJson(e))
        .toList();
  }

  Future<void> like(int reelId) async {
    await _api.post('/api/reels/$reelId/like');
  }
 Future<void> followLeader(int leaderId) async {
    await _api.post('/api/follow/$leaderId');
  }
  Future<void> share(int reelId) async {
    await _api.post('/api/reels/$reelId/share');
  }

  Future<void> save(int reelId) async {
    await _api.post('/api/reels/$reelId/save');
  }

  Future<void> comment(int reelId, String text) async {
    await _api.post(
      '/api/reels/$reelId/comment',
      data: {"text": text},
    );
  }
}
