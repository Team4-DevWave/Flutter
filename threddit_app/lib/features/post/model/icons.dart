import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:threddit_clone/theme/colors.dart';

List<IconData> communityIcons = [
  Icons.local_cafe,
  Icons.local_library,
  Icons.local_movies,
  Icons.local_offer,
  Icons.local_parking,
  Icons.local_pharmacy,
  Icons.local_phone,
  Icons.local_pizza,
  Icons.local_play,
  Icons.local_police,
  Icons.local_post_office,
  Icons.local_print_shop,
  Icons.local_see,
  Icons.local_shipping,
  Icons.local_taxi,
  Icons.local_activity,
  Icons.local_atm,
  Icons.local_bar,
  Icons.local_car_wash,
  Icons.local_convenience_store,
];

Random random = Random();

Icon getRandomIcon() {
  int randomIndex = random.nextInt(communityIcons.length);
  return Icon(
    communityIcons[randomIndex],
    size: 38.sp,
    color: AppColors.whiteColor,
  );
}
