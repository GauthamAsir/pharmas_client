import 'package:e_commerce/screens/main_screen/components/main_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dashboard extends StatefulWidget {
  static const routeName = '/dashboard';

  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final ScrollController _scrollController = ScrollController();

  MainScreenController mainScreenController = Get.put(MainScreenController());

  _scrollListener() {
    mainScreenController.scrolled.value = _scrollController.position.pixels > 0;
  }

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Dashboard',
                style: Get.textTheme.headline6,
              ),
              const SizedBox(
                height: 20,
              ),
              const Placeholder(),
              const SizedBox(
                height: 20,
              ),
              const Placeholder(),
              const SizedBox(
                height: 20,
              ),
              const Placeholder(),
            ],
          ),
        ),
      ),
    );
  }
}
