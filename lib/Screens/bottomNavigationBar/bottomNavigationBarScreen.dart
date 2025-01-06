import 'package:lisit_mobile_app/Controller/Providers/data/GetChatMessages.dart';
import 'package:lisit_mobile_app/Controller/Providers/data/authDataProvider/getUserProfile.dart';
import 'package:lisit_mobile_app/Screens/AuthScreens/loginScreen/loginScreen.dart';
import 'package:lisit_mobile_app/Screens/favourite/favouriteScreen.dart';
import 'package:lisit_mobile_app/Screens/home.dart/home.dart';
import 'package:lisit_mobile_app/Screens/selectCityScreen/selectCityScreen.dart';
import 'package:lisit_mobile_app/Screens/verifyNumber/enterNumber.dart';
import 'package:lisit_mobile_app/const/lib_all.dart';

import '../chat/chatScreen.dart';
import '../home.dart/homeScreen.dart';
import '../menu/menuScreen.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  const BottomNavigationBarScreen({super.key});

  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int _selectedIndex = 0;
  List<Widget> screen = [
    // HomeScreen1(),
    HomeScreen(),
    FavouriteScreen(),
    ChatScreen(),
    MenuScreen(),
  ];
  // @override
  // void initState() {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     getData();
  //   });
  //   // TODO: implement initState
  //   super.initState();
  // }

  // getData() async {
  //   await context.read<GetUserProfile>().getUserProfile();
  // }

  @override
  void initState() {
    // context.read<GetChatMessages>().initializeSocketFromProvider();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: kbackgrounColor,
              surfaceTintColor: kbackgrounColor,
              title: H2Regular(text: Controller.getTag('exit')),
              content: H3Regular(
                  text: Controller.getTag('do_you_want_to_exit_the_app')),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: H3Regular(
                    text: Controller.getTag('yes'),
                    color: kredColor,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: H3Regular(text: Controller.getTag('no')),
                ),
              ],
            );
          },
        );
        return shouldPop!;
      },
      child: Container(
        color: kbackgrounColor,
        child: SizedBox(
          height: 1.sh,
          width: 1.sw,
          child: Scaffold(
            // resizeToAvoidBottomInset: false,
            body: screen[_selectedIndex],
            bottomNavigationBar: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  buildIconButton(Icons.home, 0),
                  buildIconButton(Icons.favorite, 1),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          shape: const BeveledRectangleBorder(),
                          barrierColor: kbackgrounColor,
                          backgroundColor: kbackgrounColor,
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return Controller.getLogin() == true
                                ? Controller.isUserVerified == true
                                    ? SizedBox(
                                        height: 1.sh, child: SelectCityScreen())
                                    : EnterNumber()
                                : LoginScreen();
                          });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 44.h,
                      width: 44.w,
                      decoration: BoxDecoration(
                        color: kprimaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add,
                        color: kbackgrounColor,
                      ),
                    ),
                  ),
                  buildIconButton(Icons.chat_bubble_outlined, 2),
                  buildIconButton(Icons.menu, 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconButton buildIconButton(IconData icon, int index) {
    return IconButton(
      icon: Icon(
        icon,
        size: 30.sp,
      ),
      onPressed: () {
        _onItemTapped(index);
      },
      color: _selectedIndex == index ? kprimaryColor : khelperTextColor,
    );
  }

  goToFav() {
    setState(() {
      _selectedIndex = 1;
    });
  }

  goToChat() {
    setState(() {
      _selectedIndex = 2;
    });
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      if (Controller.getLogin() != true) {
        showModalBottomSheet(
            shape: const BeveledRectangleBorder(),
            barrierColor: kbackgrounColor,
            backgroundColor: kbackgrounColor,
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return LoginScreen(
                data: ['favouriteScreen', goToFav],
              );
            });
      } else {
        setState(() {
          _selectedIndex = index;
        });
      }
    } else if (index == 2) {
      if (Controller.getLogin() != true) {
        DisplayMessage(
            context: context,
            isTrue: false,
            message: Controller.getTag('login_to_continue'));
        showModalBottomSheet(
            shape: const BeveledRectangleBorder(),
            barrierColor: kbackgrounColor,
            backgroundColor: kbackgrounColor,
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return LoginScreen(
                data: ['chatScreen', goToChat],
              );
            });
      } else {
        setState(() {
          _selectedIndex = index;
        });
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }
}
