// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';

// class PostMedia extends StatefulWidget {
//   final String url;
//   final String type;

//   const PostMedia({super.key, required this.url, required this.type});

//   @override
//   State<PostMedia> createState() => _PostMediaState();
// }

// class _PostMediaState extends State<PostMedia> {
//   VideoPlayerController? _controller;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.type == "VIDEO") {
//       _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
//         ..initialize().then((_) => setState(() {}))
//         ..setLooping(true)
//         ..play();
//     }
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (widget.type == "IMAGE") {
//       return Image.network(widget.url, fit: BoxFit.cover);
//     }

//     if (_controller == null || !_controller!.value.isInitialized) {
//       return const AspectRatio(
//         aspectRatio: 16 / 9,
//         child: Center(child: CircularProgressIndicator()),
//       );
//     }

//     return AspectRatio(
//       aspectRatio: _controller!.value.aspectRatio,
//       child: VideoPlayer(_controller!),
//     );
//   }
// }
