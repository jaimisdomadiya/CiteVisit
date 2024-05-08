import 'package:cityvisit/views/screens/account/view/account_screen.dart';
import 'package:cityvisit/views/screens/bottom_menu/controller/bottom_menu_controller.dart';
import 'package:cityvisit/views/screens/home/view/home_screen.dart';
import 'package:cityvisit/views/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomMenuScreen extends StatefulWidget {
  const BottomMenuScreen({Key? key}) : super(key: key);

  @override
  State<BottomMenuScreen> createState() => _BottomMenuScreenState();
}

class _BottomMenuScreenState extends State<BottomMenuScreen> {
  final ValueNotifier<int> _currentIndexNotifier = ValueNotifier(0);

  final BottomMenuController _controller = Get.find();

  @override
  void initState() {
    _controller.getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _currentIndexNotifier,
      builder: (context, index, _) {
        Widget currentChild = const SizedBox.shrink();
        switch (index) {
          case 0:
            currentChild = const HomeScreen();
            break;
          case 1:
            currentChild = const AccountScreen();
            break;
          default:
        }
        return Scaffold(
          body: currentChild,
          bottomNavigationBar: PrimaryBottomNavigationBar(
            currentIndex: index,
            onTap: (value) async {
              _currentIndexNotifier.value = value;
            },
          ),
        );
      },
    );
  }
}
