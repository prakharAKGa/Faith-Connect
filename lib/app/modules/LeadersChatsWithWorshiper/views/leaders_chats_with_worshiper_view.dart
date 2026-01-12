import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/leaders_chats_with_worshiper_controller.dart';

class LeadersChatsWithWorshiperView
    extends GetView<LeadersChatsWithWorshiperController> {
  const LeadersChatsWithWorshiperView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LeadersChatsWithWorshiperView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'LeadersChatsWithWorshiperView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
