import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ShoppingAssistantView extends GetView<ShoppingAssistantController> {
  const ShoppingAssistantView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shopping Assistant')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.budgetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Budget'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: controller.productsController,
              decoration: InputDecoration(
                labelText: 'Products (comma-separated)',
                hintText: 'milk, butter, etc.',
              ),
            ),
            SizedBox(height: 16),
            Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : _handleSubmit,
                  child: controller.isLoading.value
                      ? CircularProgressIndicator()
                      : Text('Submit'),
                )),
            SizedBox(height: 16),
            Expanded(
              child: Obx(() => ListView.builder(
                    itemCount: controller.recommendedItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(controller.recommendedItems[index]),
                      );
                    },
                  )),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit() async {
    if (controller.budgetController.text.isEmpty ||
        controller.productsController.text.isEmpty) {
      _showErrorDialog('Please enter both budget and products.');
      return;
    }

    try {
      await controller.submitShoppingList();
    } catch (e) {
      _showErrorDialog('An error occurred: ${e.toString()}');
    }
  }

  void _showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('OK'),
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }
}

class ShoppingAssistantController extends GetxController {
  final budgetController = TextEditingController();
  final productsController = TextEditingController();
  final recommendedItems = <String>[].obs;
  final isLoading = false.obs;

  final productList = <String, List<String>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    initializeProductList();
  }

  void initializeProductList() {
    productList.value = {
      'milk': [
        'Brand A Milk: 2.99',
        'Brand B Milk: 3.49',
        'Brand C Milk: 2.79',
        'Brand D Milk: 3.29',
        'Brand E Milk: 3.99'
      ],
      'butter': [
        'Brand A Butter: 3.99',
        'Brand B Butter: 4.49',
        'Brand C Butter: 3.79',
        'Brand D Butter: 4.29',
        'Brand E Butter: 4.99'
      ],
      'bread': [
        'Brand A Bread: 2.49',
        'Brand B Bread: 2.99',
        'Brand C Bread: 2.29',
        'Brand D Bread: 3.19',
        'Brand E Bread: 3.49'
      ],
      'eggs': [
        'Brand A Eggs: 3.29',
        'Brand B Eggs: 3.79',
        'Brand C Eggs: 2.99',
        'Brand D Eggs: 3.49',
        'Brand E Eggs: 4.29'
      ],
      'cheese': [
        'Brand A Cheese: 4.99',
        'Brand B Cheese: 5.49',
        'Brand C Cheese: 4.79',
        'Brand D Cheese: 5.29',
        'Brand E Cheese: 5.99'
      ],
      'pasta': [
        'Brand A Pasta: 1.99',
        'Brand B Pasta: 2.49',
        'Brand C Pasta: 1.79',
        'Brand D Pasta: 2.29',
        'Brand E Pasta: 2.99'
      ],
      'rice': [
        'Brand A Rice: 3.49',
        'Brand B Rice: 3.99',
        'Brand C Rice: 3.29',
        'Brand D Rice: 3.79',
        'Brand E Rice: 4.49'
      ],
      'cereal': [
        'Brand A Cereal: 3.99',
        'Brand B Cereal: 4.49',
        'Brand C Cereal: 3.79',
        'Brand D Cereal: 4.29',
        'Brand E Cereal: 4.99'
      ],
      'yogurt': [
        'Brand A Yogurt: 2.79',
        'Brand B Yogurt: 3.29',
        'Brand C Yogurt: 2.59',
        'Brand D Yogurt: 2.99',
        'Brand E Yogurt: 3.49'
      ],
      'coffee': [
        'Brand A Coffee: 7.99',
        'Brand B Coffee: 8.49',
        'Brand C Coffee: 7.79',
        'Brand D Coffee: 8.29',
        'Brand E Coffee: 8.99'
      ],
      'tea': [
        'Brand A Tea: 3.49',
        'Brand B Tea: 3.99',
        'Brand C Tea: 3.29',
        'Brand D Tea: 3.79',
        'Brand E Tea: 4.49'
      ],
      'juice': [
        'Brand A Juice: 2.99',
        'Brand B Juice: 3.49',
        'Brand C Juice: 2.79',
        'Brand D Juice: 3.29',
        'Brand E Juice: 3.99'
      ],
      'vegetables': [
        'Brand A Vegetables: 4.49',
        'Brand B Vegetables: 4.99',
        'Brand C Vegetables: 4.29',
        'Brand D Vegetables: 4.79',
        'Brand E Vegetables: 5.49'
      ],
      'fruits': [
        'Brand A Fruits: 5.49',
        'Brand B Fruits: 5.99',
        'Brand C Fruits: 5.29',
        'Brand D Fruits: 5.79',
        'Brand E Fruits: 6.49'
      ],
      'chicken': [
        'Brand A Chicken: 6.99',
        'Brand B Chicken: 7.49',
        'Brand C Chicken: 6.79',
        'Brand D Chicken: 7.29',
        'Brand E Chicken: 7.99'
      ],
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

    isLoading.value = true;

    try {
      final prompt = '''
      Budget: $budget
      Products: ${products.join(', ')}
      Product List: $productList

      Based on the given budget and product list, please select the best combination of items that fits within the budget. Provide a list of recommended items with their brands and prices.
      ''';

      final model = GenerativeModel(
          model: 'gemini-pro',
          apiKey: 'AIzaSyDOyF4cDtyKzuQQm94Ng_MBVcDCVoeNj2s');
      final content = [Content.text(prompt)];

      final response = await model.generateContent(content);
      final result = response.text;
      if (result == null || result.isEmpty) {
        throw Exception('No recommendations generated');
      }
      recommendedItems.value = result.split('\n');
    } catch (e) {
      throw Exception('Failed to generate recommendations: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
