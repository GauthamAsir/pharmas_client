import 'package:e_commerce/screens/login/login.dart';
import 'package:e_commerce/screens/main_screen/components/action_tool.dart';
import 'package:e_commerce/screens/main_screen/components/dashboard/dashboard.dart';
import 'package:e_commerce/screens/main_screen/components/main_screen_controller.dart';
import 'package:e_commerce/utils/auth_helper.dart';
import 'package:e_commerce/utils/constants.dart';
import 'package:e_commerce/widgets/responsive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main_screen';

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

enum ActionTools { explore, cart, contactUs, profile, login }

extension on ActionTools {
  String get label => this == ActionTools.explore
      ? 'Explore'
      : this == ActionTools.cart
          ? 'Cart'
          : this == ActionTools.contactUs
              ? 'Contact Us'
              : this == ActionTools.profile
                  ? 'Account'
                  : 'Login';
}

class _MainScreenState extends State<MainScreen> {
  static final AuthHelper authHelper = AuthHelper();

  MainScreenController mainScreenController = Get.put(MainScreenController());

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return StreamBuilder<User?>(
      stream: authHelper.userStream,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(screenSize.width, 1000),
            child: Responsive(
                mobile: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ActionToolWidget(
                              index: ActionTools.explore.index,
                              label: appName,
                              iconData: Icons.local_pharmacy_outlined,
                              mobile: true),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: Row(
                              children: [
                                ActionToolWidget(
                                    index: ActionTools.cart.index,
                                    label: ActionTools.cart.label,
                                    iconData: Icons.shopping_cart,
                                    mobile: true),
                                SizedBox(
                                  width: screenSize.width / 20,
                                ),
                                ActionToolWidget(
                                    index: ActionTools.profile.index,
                                    label: ActionTools.profile.label,
                                    iconData: Icons.account_circle_outlined,
                                    mobile: true),
                              ],
                            ),
                          )
                        ],
                      ),
                      Obx(() => AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: mainScreenController.scrolled.value
                                ? const SizedBox(
                                    height: 0,
                                    width: 0,
                                  )
                                : Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(
                                        height: screenSize.width / 20,
                                      ),
                                      _buildSearch()
                                    ],
                                  ),
                          ))
                    ],
                  ),
                ),
                desktop: Container(
                  color: Get.theme.colorScheme.primary,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          ActionToolWidget(
                              index: ActionTools.explore.index,
                              label: appName,
                              iconData: Icons.local_pharmacy_outlined),
                          SizedBox(
                            width: screenSize.width / 50,
                          ),
                          Expanded(child: _buildSearch()),
                          SizedBox(
                            width: screenSize.width / 50,
                          ),
                          ActionToolWidget(
                              index: ActionTools.cart.index,
                              label: ActionTools.cart.label,
                              iconData: Icons.shopping_cart),
                          SizedBox(
                            width: screenSize.width / 50,
                          ),
                          ActionToolWidget(
                              index: ActionTools.contactUs.index,
                              label: ActionTools.contactUs.label,
                              iconData: Icons.contact_support_outlined),
                          SizedBox(
                            width: screenSize.width / 50,
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: snapshot.hasData
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ActionToolWidget(
                                          index: ActionTools.profile.index,
                                          label: ActionTools.profile.label,
                                          iconData:
                                              Icons.account_circle_outlined),
                                      SizedBox(
                                        width: screenSize.width / 50,
                                      ),
                                    ],
                                  )
                                : Container(
                                    height: 0,
                                  ),
                          ),
                          ActionToolWidget(
                              onPressed: () {
                                authHelper.signOut();
                              },
                              index: ActionTools.login.index,
                              label: snapshot.hasData
                                  ? 'Log out'
                                  : ActionTools.login.label,
                              iconData: snapshot.hasData
                                  ? Icons.logout_outlined
                                  : Icons.login_outlined),
                        ],
                      ),
                      Obx(() => AnimatedSwitcher(
                            duration: const Duration(milliseconds: 150),
                            child: mainScreenController.scrolled.value
                                ? const SizedBox(
                                    height: 0,
                                    width: 0,
                                  )
                                : Container(
                                    margin: EdgeInsets.only(
                                        top: screenSize.height / 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: const [
                                        ActionToolWidget(
                                            index: 5,
                                            label: 'Sample 1',
                                            iconData: Icons
                                                .medical_information_outlined),
                                        ActionToolWidget(
                                            index: 6,
                                            label: 'Sample 2',
                                            iconData: Icons
                                                .medical_information_outlined),
                                        ActionToolWidget(
                                            index: 7,
                                            label: 'Sample 3',
                                            iconData: Icons
                                                .medical_information_outlined),
                                        ActionToolWidget(
                                            index: 8,
                                            label: 'Sample 4',
                                            iconData: Icons
                                                .medical_information_outlined),
                                        ActionToolWidget(
                                            index: 9,
                                            label: 'Sample 5',
                                            iconData: Icons
                                                .medical_information_outlined),
                                      ],
                                    ),
                                  ),
                          ))
                    ],
                  ),
                )),
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: snapshot.hasData ? const Dashboard() : const Login(),
          ),
        );
      },
    );
  }

  Widget _buildSearch() {
    return Responsive(
      desktop: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            InkWell(
                onTap: () {},
                onHover: (value) {},
                child: const Text('Deliver to 400017')),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              height: 20,
              width: 1,
              color: Colors.grey,
            ),
            Expanded(
                child: TextField(
              expands: false,
              controller: searchController,
              decoration: const InputDecoration(
                  hintText: 'Search for medicine & wellness products...',
                  border: InputBorder.none),
            ))
          ],
        ),
      ),
      mobile: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: 'Deliver to  ',
                      style: Get.textTheme.caption!
                          .copyWith(fontWeight: FontWeight.w500)),
                  TextSpan(
                      text: 'Taloja, Kharghar -410208',
                      style: Get.textTheme.subtitle2!
                          .copyWith(fontWeight: FontWeight.w500))
                ]),
                overflow: TextOverflow.ellipsis),
            const SizedBox(
              height: 20,
            ),
            TextField(
              expands: false,
              controller: searchController,
              decoration: const InputDecoration(
                  hintText: 'Search for medicine & wellness products...',
                  prefixIcon: Icon(Icons.search_rounded),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)))),
            )
          ],
        ),
      ),
    );
  }
}
