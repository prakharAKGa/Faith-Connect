
---

# FaithConnect – Flutter Mobile Application

FaithConnect is a cross-platform Flutter application designed to connect worshipers with verified spiritual leaders across different faiths.  
The app focuses on community, inspiration, and real-time engagement through posts, reels, chat, and notifications.

---

## 📱 Platform
- **Flutter (Android & iOS)**
- **State Management:** GetX
- **Backend:** Node.js + Express (API-based)
- **Database:** MySQL
- **Media Storage:** Cloudinary
- **Push Notifications:** Firebase Cloud Messaging (FCM)
- **Hosting:** Railway

---

## ✨ Core Features

### 🔐 Authentication
- Secure login & signup
- JWT-based authentication
- Role-based access:
  - **Leader**
  - **Worshiper**

---

### 🏠 Home Feed
- Explore posts from verified leaders
- Media support:
  - Images
  - Videos
- Like, comment, and share posts
- Infinite scrolling feed

---

### 🎥 Reels (Instagram-like Experience)
- Vertical, full-screen video reels
- Auto-play & auto-pause based on tab visibility
- Smooth page-by-page vertical scrolling
- Actions:
  - Like ❤️
  - Comment 💬
  - Share 🔁
  - Save 🔖
- Leader profile display with follow/unfollow
- Looping videos for seamless experience

---

### 👥 Follow System
- Worshipers can follow/unfollow leaders
- Followers-only content feed
- Follow notifications sent to leaders
- Leader follower count management

---

### 💬 Real-time Chat
- One-to-one chat between worshiper and leader
- Online / offline status
- Typing indicators
- Message delivery states:
  - Sent
  - Delivered
  - Seen
- Socket-based real-time communication

---

### 🔔 Notifications System
- Push notifications using FCM
- Stored notification history
- Notifications triggered for:
  - New follower
  - New post by followed leader
  - New reel by followed leader
  - Likes on posts/reels
  - Comments on posts/reels
  - New chat messages

---

### 📝 Posts & Comments
- Leaders can create posts (image/video)
- Worshipers can:
  - Like posts
  - Comment on posts
  - Reply to comments (nested comments)
- Real-time count updates

---

### 📤 Media Upload
- Image & video upload via Cloudinary
- Upload progress indicator
- Preview before posting

---

### 🧭 Navigation
- Custom floating bottom navigation bar
- Auto-hide on scroll down
- Auto-show on scroll up
- SafeArea-aware layout
- Smooth animations

---

### 🎨 UI / UX
- Modern Material 3 design
- Dark mode support
- Responsive layouts
- Custom reusable widgets
- Clean animations & transitions

---

## 🧱 Project Structure

lib/ ├── app/ │   ├── core/ │   │   ├── services/ │   │   ├── widgets/ │   │   └── config/ │   ├── modules/ │   │   ├── Auth/ │   │   ├── BottomNav/ │   │   ├── Posts/ │   │   ├── ReelsForWorshipers/ │   │   ├── Chat/ │   │   └── Profile/ │   ├── data/ │   │   ├── models/ │   │   └── repo/ │   └── routes/ └── main.dart

---

## 🔑 Demo Credentials

### 👤 Worshiper
- **Email:** worshiper@demo.com  
- **Password:** 123456

### 🧘 Leader
- **Email:** leader@demo.com  
- **Password:** 123456

---

## 🚀 How to Run

```bash
# Get dependencies
flutter pub get

# Run on Android
flutter run

# Build APK
flutter build apk

# Build iOS (Mac only)
flutter build ios


---

🛠 Key Packages Used

get

dio

better_player_plus

firebase_messaging

cloudinary

socket_io_client

iconsax



---

📌 Highlights

Clean architecture

Scalable backend integration

Real-time features

Production-ready code

Recruiter-friendly project



---

👨‍💻 Author

Prakhar Srivastava
Flutter Developer


---

📜 License

This project is for educational and demonstration purposes.


- Add **architecture diagram**

Just tell me 👍
