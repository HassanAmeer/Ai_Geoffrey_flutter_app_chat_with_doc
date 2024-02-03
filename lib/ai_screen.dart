import 'package:ask_geoffrey/utils/app_colors.dart';
import 'package:ask_geoffrey/views/ai_assistant/ai_assistant_screen.dart';
import 'package:ask_geoffrey/views/chatpage/chat_screen.dart';
import 'package:ask_geoffrey/views/components/auth_components.dart';
import 'package:ask_geoffrey/views/history/HistoryScreen.dart';
import 'package:ask_geoffrey/views/profile/profile_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _currentIndex = 0;
  List<Widget> body = [
    const MainChatScreen(),
    const AIAssistant(),
    const HistoryScreen(),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child:
              Image.asset("assets/images/splash_logo.png", width: 20, height: 20),
        ),
        backgroundColor: Colors.black,
        elevation: 0.0,
        title: const Text(
          "AI Assistant",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: body[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
        elevation: 0.0,

          type: BottomNavigationBarType.fixed,
          selectedIconTheme: const IconThemeData(color: Colors.white),
          unselectedIconTheme: const IconThemeData(color: Colors.grey),
          backgroundColor: AppColors.textFieldColor,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                label: "Home",
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.dashboard,
                ),
                label: "AI Assistant",
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.history,
                ),
                label: "History",
                backgroundColor: AppColors.textFieldColor
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                ),
                label: "Profile",
                backgroundColor: AppColors.textFieldColor
            ),
          ]),
    );
  }
}

class MainChatScreen extends StatefulWidget {
  const MainChatScreen({super.key});

  @override
  State<MainChatScreen> createState() => _MainChatScreenState();
}

class _MainChatScreenState extends State<MainChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/splash_logo.png", width: 180, height: 160),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            const Text(
              "Welcome To\nAsk Geoffery AI",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            const Text(
              "start chatting with ghapate chat now",
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            CustomButton(
              text: "Start Chat",
              loading: false,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
