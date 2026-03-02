import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend_flutter/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecipesScreen extends StatefulWidget {
  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  List<_Recipe> _recipes = [];
  bool _isLoading = true;

  final _nameCtrl = TextEditingController();
  final _ingredientsCtrl = TextEditingController();
  final _instructionsCtrl = TextEditingController();
  final _caloriesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final recipesJson = prefs.getString('recipes');
    if (recipesJson != null) {
      final List<dynamic> decoded = jsonDecode(recipesJson);
      setState(() {
        _recipes = decoded.map((e) => _Recipe.fromJson(e)).toList();
        _isLoading = false;
      });
    } else {
      setState(() {
        _recipes = [
          _Recipe(name: 'Oatmeal', ingredients: 'Oats, Milk, Honey', instructions: 'Mix and heat', calories: 250),
          _Recipe(name: 'Greek Salad', ingredients: 'Tomato, Cucumber, Feta', instructions: 'Chop and mix', calories: 180),
        ];
        _isLoading = false;
      });
      await _saveRecipes();
    }
  }

  Future<void> _saveRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final recipesJson = jsonEncode(_recipes.map((e) => e.toJson()).toList());
    await prefs.setString('recipes', recipesJson);
  }

  Future<void> _addRecipe(AppLocalizations t) async {
    if (_nameCtrl.text.trim().isEmpty) return;
    final recipe = _Recipe(
      name: _nameCtrl.text.trim(),
      ingredients: _ingredientsCtrl.text.trim(),
      instructions: _instructionsCtrl.text.trim(),
      calories: int.tryParse(_caloriesCtrl.text) ?? 0,
    );
    setState(() => _recipes.add(recipe));
    await _saveRecipes();
    _nameCtrl.clear();
    _ingredientsCtrl.clear();
    _instructionsCtrl.clear();
    _caloriesCtrl.clear();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.recipeAdded)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: Text(t.recipes)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ..._recipes.map((r) => Card(
                child: ListTile(
                  title: Text(r.name),
                  subtitle: Text('${r.calories} kcal • ${r.ingredients}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text(r.name),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('${t.calories}: ${r.calories} kcal', style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 12),
                              Text(t.ingredients, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(r.ingredients),
                              const SizedBox(height: 12),
                              Text(t.instructions, style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(r.instructions),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )),
          const SizedBox(height: 16),
          Text(t.addRecipe, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(controller: _nameCtrl, decoration: InputDecoration(labelText: t.recipeName)),
          const SizedBox(height: 8),
          TextField(controller: _ingredientsCtrl, decoration: InputDecoration(labelText: t.ingredients)),
          const SizedBox(height: 8),
          TextField(
            controller: _instructionsCtrl,
            decoration: InputDecoration(labelText: t.instructions),
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _caloriesCtrl,
            decoration: InputDecoration(labelText: t.calories),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              onPressed: () => _addRecipe(t),
              icon: const Icon(Icons.add),
              label: Text(t.add),
            ),
          ),
        ],
      ),
    );
  }
}

class _Recipe {
  final String name;
  final String ingredients;
  final String instructions;
  final int calories;
  
  _Recipe({required this.name, required this.ingredients, required this.instructions, required this.calories});
  
  Map<String, dynamic> toJson() => {
    'name': name,
    'ingredients': ingredients,
    'instructions': instructions,
    'calories': calories,
  };
  
  factory _Recipe.fromJson(Map<String, dynamic> json) => _Recipe(
    name: json['name'] ?? '',
    ingredients: json['ingredients'] ?? '',
    instructions: json['instructions'] ?? '',
    calories: json['calories'] ?? 0,
  );
}
