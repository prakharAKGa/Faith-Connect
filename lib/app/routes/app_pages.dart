import 'package:get/get.dart';

import '../modules/BottomNav/bindings/bottom_nav_binding.dart';
import '../modules/BottomNav/views/bottom_nav_view.dart';
import '../modules/BottomNavForLeaders/bindings/bottom_nav_for_leaders_binding.dart';
import '../modules/BottomNavForLeaders/views/bottom_nav_for_leaders_view.dart';
import '../modules/Initial/bindings/initial_binding.dart';
import '../modules/Initial/views/initial_view.dart';
import '../modules/LeaderDetails/bindings/leader_details_binding.dart';
import '../modules/LeaderDetails/views/leader_details_view.dart';
import '../modules/LeadersChatDetail/bindings/leaders_chat_detail_binding.dart';
import '../modules/LeadersChatDetail/views/leaders_chat_detail_view.dart';
import '../modules/LeadersChatList/bindings/leaders_chat_list_binding.dart';
import '../modules/LeadersChatList/views/leaders_chat_list_view.dart';
import '../modules/LeadersChatView/bindings/leaders_chat_view_binding.dart';
import '../modules/LeadersChatView/views/leaders_chat_view_view.dart';
import '../modules/LeadersChatsWithWorshiper/bindings/leaders_chats_with_worshiper_binding.dart';
import '../modules/LeadersChatsWithWorshiper/views/leaders_chats_with_worshiper_view.dart';
import '../modules/LeadersHome/bindings/leaders_home_binding.dart';
import '../modules/LeadersHome/views/leaders_home_view.dart';
import '../modules/LeadersforWorshiper/bindings/leadersfor_worshiper_binding.dart';
import '../modules/LeadersforWorshiper/views/leadersfor_worshiper_view.dart';
import '../modules/Login/bindings/login_binding.dart';
import '../modules/Login/views/login_view.dart';
import '../modules/NotificationViewForLeaders/bindings/notification_view_for_leaders_binding.dart';
import '../modules/NotificationViewForLeaders/views/notification_view_for_leaders_view.dart';
import '../modules/PostDetails/bindings/post_details_binding.dart';
import '../modules/PostDetails/views/post_details_view.dart';
import '../modules/PostUpload/bindings/post_upload_binding.dart';
import '../modules/PostUpload/views/post_upload_view.dart';
import '../modules/Profile/bindings/profile_binding.dart';
import '../modules/Profile/views/profile_view.dart';
import '../modules/ReelsForWorshipers/bindings/reels_for_worshipers_binding.dart';
import '../modules/ReelsForWorshipers/views/reels_for_worshipers_view.dart';
import '../modules/ReelsUploadforLeader/bindings/reels_uploadfor_leader_binding.dart';
import '../modules/ReelsUploadforLeader/views/reels_uploadfor_leader_view.dart';
import '../modules/SignUp/bindings/sign_up_binding.dart';
import '../modules/SignUp/views/sign_up_view.dart';
import '../modules/SignUpAsWorshipper/bindings/sign_up_as_worshipper_binding.dart';
import '../modules/SignUpAsWorshipper/views/sign_up_as_worshipper_view.dart';
import '../modules/Splash/bindings/splash_binding.dart';
import '../modules/Splash/views/splash_view.dart';
import '../modules/WorshiperChatView/bindings/worshiper_chat_view_binding.dart';
import '../modules/WorshiperChatView/views/worshiper_chat_view_view.dart';
import '../modules/WorshiperChatWithLeaders/bindings/worshiper_chat_with_leaders_binding.dart';
import '../modules/WorshiperChatWithLeaders/views/worshiper_chat_with_leaders_view.dart';
import '../modules/WorshiperHome/bindings/worshiper_home_binding.dart';
import '../modules/WorshiperHome/views/worshiper_home_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // app_pages.dart
  static const INITIALPAGE = Routes.SPLASH; // ← change this

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_UP,
      page: () => const SignUpView(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: _Paths.INITIAL,
      page: () => const InitialView(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_UP_AS_WORSHIPPER,
      page: () => const SignUpAsWorshipperView(),
      binding: SignUpAsWorshipperBinding(),
    ),
    GetPage(
      name: _Paths.BOTTOM_NAV,
      page: () => const BottomNavView(),
      binding: BottomNavBinding(),
    ),
    GetPage(
      name: _Paths.WORSHIPER_HOME,
      page: () => const WorshiperHomeView(),
      binding: WorshiperHomeBinding(),
    ),
    GetPage(
      name: _Paths.LEADERSFOR_WORSHIPER,
      page: () => const LeadersforWorshiperView(),
      binding: LeadersforWorshiperBinding(),
    ),
    GetPage(
      name: _Paths.REELS_FOR_WORSHIPERS,
      page: () => const ReelsForWorshipersView(),
      binding: ReelsForWorshipersBinding(),
    ),
    GetPage(
      name: _Paths.POST_DETAILS,
      page: () => const PostDetailsView(),
      binding: PostDetailsBinding(),
    ),
    GetPage(
      name: _Paths.WORSHIPER_CHAT_VIEW,
      page: () => const WorshiperChatViewView(),
      binding: WorshiperChatViewBinding(),
    ),
    GetPage(
      name: _Paths.WORSHIPER_CHAT_WITH_LEADERS,
      page: () => const WorshiperChatWithLeadersView(),
      binding: WorshiperChatWithLeadersBinding(),
    ),
    GetPage(
      name: _Paths.BOTTOM_NAV_FOR_LEADERS,
      page: () => const BottomNavForLeadersView(),
      binding: BottomNavForLeadersBinding(),
    ),
    GetPage(
      name: _Paths.LEADERS_HOME,
      page: () => const LeadersHomeView(),
      binding: LeadersHomeBinding(),
    ),
    GetPage(
      name: _Paths.LEADERS_CHAT_VIEW,
      page: () => const LeadersChatViewView(),
      binding: LeadersChatViewBinding(),
    ),
    GetPage(
      name: _Paths.REELS_UPLOADFOR_LEADER,
      page: () => const ReelsUploadforLeaderView(),
      binding: ReelsUploadforLeaderBinding(),
    ),
    GetPage(
      name: _Paths.POST_UPLOAD,
      page: () => const PostUploadView(),
      binding: PostUploadBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATION_VIEW_FOR_LEADERS,
      page: () => const NotificationViewForLeadersView(),
      binding: NotificationViewForLeadersBinding(),
    ),
    GetPage(
      name: _Paths.LEADERS_CHATS_WITH_WORSHIPER,
      page: () => const LeadersChatsWithWorshiperView(),
      binding: LeadersChatsWithWorshiperBinding(),
    ),
    GetPage(
      name: _Paths.LEADERS_CHAT_LIST,
      page: () => const LeadersChatListView(),
      binding: LeadersChatListBinding(),
    ),
    GetPage(
      name: _Paths.LEADERS_CHAT_DETAIL,
      page: () => const LeadersChatDetailView(),
      binding: LeadersChatDetailBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.LEADER_DETAILS,
      page: () => const LeaderDetailsView(),
      binding: LeaderDetailsBinding(),
    ),
  ];
}
