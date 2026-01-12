import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/leaders_chat_view_controller.dart';

class LeadersChatViewView extends GetView<LeadersChatViewController> {
  const  LeadersChatViewView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LeadersChatViewView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'LeadersChatViewView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
