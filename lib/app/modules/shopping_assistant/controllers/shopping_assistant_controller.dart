import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ShoppingAssistantController extends GetxController {
  final budgetController = TextEditingController();
  final productsController = TextEditingController();
  RxList<String> recommendedItems = <String>[].obs;
  RxString reasoning = ''.obs;
  RxBool isLoading = false.obs;
  RxDouble budgetDifference = 0.0.obs;
  RxDouble totalCost = 0.0.obs;
  RxString errorMessage = ''.obs;

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
        'Brand A Milk: ₹80',
        'Brand B Milk: ₹95',
        'Brand C Milk: ₹75',
        'Brand D Milk: ₹90',
        'Brand E Milk: ₹110'
      ],
      'butter': [
        'Brand A Butter: ₹110',
        'Brand B Butter: ₹125',
        'Brand C Butter: ₹105',
        'Brand D Butter: ₹120',
        'Brand E Butter: ₹140'
      ],
      'bread': [
        'Brand A Bread: ₹70',
        'Brand B Bread: ₹85',
        'Brand C Bread: ₹65',
        'Brand D Bread: ₹90',
        'Brand E Bread: ₹95'
      ],
      'eggs': [
        'Brand A Eggs: ₹90',
        'Brand B Eggs: ₹105',
        'Brand C Eggs: ₹85',
        'Brand D Eggs: ₹95',
        'Brand E Eggs: ₹120'
      ],
      'cheese': [
        'Brand A Cheese: ₹140',
        'Brand B Cheese: ₹155',
        'Brand C Cheese: ₹135',
        'Brand D Cheese: ₹150',
        'Brand E Cheese: ₹170'
      ],
      'pasta': [
        'Brand A Pasta: ₹55',
        'Brand B Pasta: ₹70',
        'Brand C Pasta: ₹50',
        'Brand D Pasta: ₹65',
        'Brand E Pasta: ₹85'
      ],
      'rice': [
        'Brand A Rice: ₹95',
        'Brand B Rice: ₹110',
        'Brand C Rice: ₹90',
        'Brand D Rice: ₹105',
        'Brand E Rice: ₹125'
      ],
      'cereal': [
        'Brand A Cereal: ₹110',
        'Brand B Cereal: ₹125',
        'Brand C Cereal: ₹105',
        'Brand D Cereal: ₹120',
        'Brand E Cereal: ₹140'
      ],
      'yogurt': [
        'Brand A Yogurt: ₹75',
        'Brand B Yogurt: ₹90',
        'Brand C Yogurt: ₹70',
        'Brand D Yogurt: ₹85',
        'Brand E Yogurt: ₹95'
      ],
      'coffee': [
        'Brand A Coffee: ₹220',
        'Brand B Coffee: ₹235',
        'Brand C Coffee: ₹215',
        'Brand D Coffee: ₹230',
        'Brand E Coffee: ₹250'
      ],
      'tea': [
        'Brand A Tea: ₹95',
        'Brand B Tea: ₹110',
        'Brand C Tea: ₹90',
        'Brand D Tea: ₹105',
        'Brand E Tea: ₹125'
      ],
      'juice': [
        'Brand A Juice: ₹80',
        'Brand B Juice: ₹95',
        'Brand C Juice: ₹75',
        'Brand D Juice: ₹90',
        'Brand E Juice: ₹110'
      ],
      'vegetables': [
        'Brand A Vegetables: ₹125',
        'Brand B Vegetables: ₹140',
        'Brand C Vegetables: ₹120',
        'Brand D Vegetables: ₹135',
        'Brand E Vegetables: ₹155'
      ],
      'fruits': [
        'Brand A Fruits: ₹155',
        'Brand B Fruits: ₹170',
        'Brand C Fruits: ₹150',
        'Brand D Fruits: ₹165',
        'Brand E Fruits: ₹185'
      ],
      'chicken': [
        'Brand A Chicken: ₹195',
        'Brand B Chicken: ₹210',
        'Brand C Chicken: ₹190',
        'Brand D Chicken: ₹205',
        'Brand E Chicken: ₹225'
      ],
    };
  }

  void clearAll() {
    budgetController.clear();
    productsController.clear();
    recommendedItems.clear();
    reasoning.value = '';
    totalCost.value = 0;
    budgetDifference.value = 0;
    errorMessage.value = '';
  }

  void setErrorMessage(String message) {
    errorMessage.value = message;
  }

  Future<void> submitShoppingList() async {
    isLoading.value = true;
    errorMessage.value = '';
    recommendedItems.clear();
    reasoning.value = '';
    totalCost.value = 0;
    budgetDifference.value = 0;

    try {
      final budget = double.tryParse(budgetController.text);
      if (budget == null) {
        throw Exception('Invalid budget input');
      }

      final products = productsController.text.split(',').map((e) => e.trim()).toList();
      if (products.isEmpty) {
        throw Exception('No products specified');
      }

      final prompt = '''
Budget: ₹$budget
Products: ${products.join(', ')}
Product List: $productList

Based on the given budget and product list, please select the best combination of items that fits within the budget. Provide a list of recommended items with their brands and prices. Also, explain your reasoning for choosing these products, including any remaining budget or exceeding amount. Present your response in the following format:

Recommendations:
- [Product Name]: [Brand] - ₹[Price]
- [Product Name]: [Brand] - ₹[Price]
...

Total Cost: ₹[Total]

Budget Difference: ₹[Difference] (saved/exceeded)

Reasoning:
[Your reasoning here]

Please ensure that you follow this format exactly, including the bullet points and the precise wording for "Total Cost" and "Budget Difference".
''';

      final model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: 'AIzaSyDOyF4cDtyKzuQQm94Ng_MBVcDCVoeNj2s',
      );
      final content = [Content.text(prompt)];

      final response = await model.generateContent(content);
      final result = response.text;
      if (result == null || result.isEmpty) {
        throw Exception('No recommendations generated');
      }

      print('AI Response: $result'); // Debug print

      final parts = result.split('Reasoning:');
      if (parts.length == 2) {
        final recommendationsPart = parts[0].trim();
        final reasoningPart = parts[1].trim();

        // Extract recommendations
        recommendedItems.value = recommendationsPart
            .split('\n')
            .where((line) => line.trim().startsWith('•') || line.trim().startsWith('-'))
            .map((line) => line.trim().substring(1).trim())
            .toList();

        print('Extracted Recommendations: ${recommendedItems.value}');

        // Extract total cost
        final totalCostMatch = RegExp(r'Total Cost: ₹(\d+(\.\d+)?)').firstMatch(recommendationsPart);
        if (totalCostMatch != null) {
          totalCost.value = double.parse(totalCostMatch.group(1)!);
        } else {
          throw Exception('Total Cost not found in the response');
        }

        // Extract budget difference
        final budgetDiffMatch = RegExp(r'Budget Difference: ₹(\d+(\.\d+)?)\s*\((saved|exceeded)\)').firstMatch(recommendationsPart);
        if (budgetDiffMatch != null) {
          final difference = double.parse(budgetDiffMatch.group(1)!);
          budgetDifference.value = budgetDiffMatch.group(3) == 'saved' ? difference : -difference;
        } else {
          throw Exception('Budget Difference not found in the response');
        }

        // Extract reasoning
        reasoning.value = reasoningPart.trim();

      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      setErrorMessage('Error: ${e.toString()}');
      print('Error occurred: ${e.toString()}'); // Debug print
    } finally {
      isLoading.value = false;
    }
  }
}