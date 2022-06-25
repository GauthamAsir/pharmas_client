import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'main_screen_controller.dart';

class ActionToolWidget extends GetView<MainScreenController> {
  final int index;
  final String label;
  final IconData iconData;
  final GestureTapCallback? onPressed;
  final bool mobile;

  const ActionToolWidget(
      {Key? key,
      required this.index,
      required this.label,
      required this.iconData,
      this.onPressed,
      this.mobile = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: mobile
          ? null
          : (value) {
              controller.isHovering[index] = value;
            },
      onTap: onPressed ?? () {},
      child: Obx(() => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(iconData,
                      color: !mobile && controller.isHovering[index]
                          ? Colors.white
                          : Colors.black87),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: mobile
                        ? const SizedBox(
                            height: 0,
                            width: 0,
                          )
                        : Row(
                            children: [
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                label,
                                style: TextStyle(
                                    color:
                                        !mobile && controller.isHovering[index]
                                            ? Colors.white
                                            : Colors.black87,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                  ),
                  if (mobile && index == 0)
                    Row(
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          label,
                          style: TextStyle(
                              color: !mobile && controller.isHovering[index]
                                  ? Colors.white
                                  : Colors.black87,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 5),
              // For showing an underline on hover
              Visibility(
                maintainAnimation: true,
                maintainState: true,
                maintainSize: true,
                visible: (controller.isHovering[index] && !mobile),
                child: Container(
                  height: 2,
                  width: 20,
                  color: Colors.white,
                ),
              )
            ],
          )),
    );
  }
}
