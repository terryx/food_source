

import 'package:flutter/material.dart';
import 'package:food_source/view/add_food.dart';
import 'package:food_source/view/edit_food.dart';
import 'package:food_source/view/home.dart';

import 'view/splash.dart';

Map<String, WidgetBuilder> foodRoutes = {
  '/index': (context) => const SplashView(),
  '/home': (context) => const HomeView(),
  '/add_food': (context) => const AddFoodView(),
  '/edit_food': (context) => const EditFoodView(),
};