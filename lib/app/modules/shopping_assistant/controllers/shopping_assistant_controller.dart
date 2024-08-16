import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ShoppingAssistantController extends GetxController {
  final budgetController = TextEditingController();
  final productsController = TextEditingController();
  RxList<String> recommendedItems = <String>[].obs;
  RxBool isLoading = false.obs;

  Map<String, List<String>> productList = {};

  @override
  void onInit() {
    super.onInit();
    initializeProductList();
  }

  @override
  void onClose() {
    budgetController.dispose();
    productsController.dispose();
    super.onClose();
  }

  void initializeProductList() {
    productList = {
      'milk': [
        'Brand A Milk: 2.99',
        'Brand B Milk: 3.49',
        'Brand C Milk: 2.79',
        'Brand D Milk: 3.29',
        'Brand E Milk: 3.99'
      ],
      // ... (rest of the product list)
    };
  }

  Future<void> submitShoppingList() async {
    final budget = double.tryParse(budgetController.text);
    if (budget == null) {
      throw Exception('Invalid budget input');
    }

    final products =
        productsController.text.split(',').map((e) => e.trim()).toList();
    if (products.isEmpty) {
      throw Exception('No products specified');
    }

    final prompt = '''
    Budget: $budget
    Products: ${products.join(', ')}
    Product List: $productList

    Based on the given budget and product list, please select the best combination of items that fits within the budget. Provide a list of recommended items with their brands and prices.
    ''';

    final model = GenerativeModel(
        model: 'gemini-pro', apiKey: 'AIzaSyDOyF4cDtyKzuQQm94Ng_MBVcDCVoeNj2s');
    final content = [Content.text(prompt)];

    try {
      final response = await model.generateContent(content);
      final result = response.text;
      if (result == null || result.isEmpty) {
        throw Exception('No recommendations generated');
      }
      recommendedItems.value = result.split('\n');
    } catch (e) {
      throw Exception('Failed to generate recommendations: ${e.toString()}');
    }
  }
}
