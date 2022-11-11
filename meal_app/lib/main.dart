import 'package:flutter/material.dart';
import 'package:meal_app/dummy_data.dart';
import 'package:meal_app/screens/categories_screen.dart';
import 'package:meal_app/screens/category_meal_screen.dart';
import 'package:meal_app/screens/filter_screen.dart';
import 'package:meal_app/screens/meal_detail_screen.dart';
import 'package:meal_app/screens/tabs_screen.dart';

import 'models/meal.dart';

void main() => runApp(const App());

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  List<Meal> _availableMeals = dummyMeals;
  List<Meal> _favouriteMeals = [];
  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false
  };

  void _setFilters(Map<String, bool> filterData) {
    setState(() {
      _filters = filterData;

      _availableMeals = dummyMeals.where((element) {
        if (_filters['gluten'] as bool && !element.isGlutenFree) return false;
        if (_filters['lactose'] as bool && !element.isLactoseFree) return false;
        if (_filters['vegan'] as bool && !element.isVegan) return false;
        if (_filters['vegetarian'] as bool && !element.isVegetarian) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  void _toggleFavorite(String mealId) {
    final existingIndex =
        _favouriteMeals.indexWhere((element) => mealId == element.id);
    setState(() {
      if (existingIndex >= 0) {
        _favouriteMeals.removeAt(existingIndex);
      } else {
        _favouriteMeals
            .add(dummyMeals.firstWhere((element) => mealId == element.id));
      }
    });
  }

  bool _isMealFavorite(String id) {
    return _favouriteMeals.any((element) => element.id == id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Meal',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.pink,
          accentColor: Colors.amber,
        ),
        canvasColor: const Color.fromRGBO(255, 254, 229, 1),
        textTheme: ThemeData.light().textTheme.copyWith(
              bodySmall: const TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              bodyMedium: const TextStyle(
                color: Color.fromRGBO(20, 51, 51, 1),
              ),
              titleMedium: const TextStyle(
                fontSize: 20,
                fontFamily: 'RobotoCondensed',
              ),
            ),
      ),
      initialRoute: '/',
      routes: {
        CategoriesScreen.routeName: (_) => TabsScreen(_favouriteMeals),
        CategoryMealScreen.routeName: (_) =>
            CategoryMealScreen(_availableMeals),
        MealDetailScreen.routeName: (_) =>
            MealDetailScreen(_toggleFavorite, _isMealFavorite),
        FilterScreen.routeName: (_) => FilterScreen(_filters, _setFilters),
      },
      onUnknownRoute: (_) {
        return MaterialPageRoute(builder: (_) => CategoriesScreen());
      },
    );
  }
}
