import 'package:flutter/material.dart';
import 'package:meal_app/widgets/meal_item.dart';

import '../models/meal.dart';

class CategoryMealScreen extends StatefulWidget {
  static const String routeName = '/category-meals';

  final List<Meal> availableMeals;

  CategoryMealScreen(this.availableMeals);

  @override
  State<CategoryMealScreen> createState() => _CategoryMealScreenState();
}

class _CategoryMealScreenState extends State<CategoryMealScreen> {
  late String _categoryTitle;
  late List<Meal> _displayedMeals;
  bool _isInitDataLoaded = false;

  void _removeMeal(String mealId) {
    setState(() {
      _displayedMeals.removeWhere((element) => element.id == mealId);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitDataLoaded) {
      final routeArgs =
          ModalRoute.of(context)?.settings.arguments as Map<String, String>;
      final id = routeArgs['id'];
      _categoryTitle = routeArgs['title'] as String;
      _displayedMeals = widget.availableMeals
          .where((element) => element.categories.contains(id))
          .toList();
      _isInitDataLoaded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _categoryTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final Meal item = _displayedMeals[index];
          return MealItem(
            id: item.id,
            title: item.title,
            imageUrl: item.imageUrl,
            duration: item.duration,
            complexity: item.complexity,
            affordability: item.affordability,
          );
        },
        itemCount: _displayedMeals.length,
      ),
    );
  }
}
