import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/shopping_assistant_controller.dart';

class ShoppingAssistantView extends GetView<ShoppingAssistantController> {
  const ShoppingAssistantView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Shopping Assistant'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputCard(),
              SizedBox(height: 20),
              _buildSubmitButton(),
              SizedBox(height: 20),
              _buildRecommendationsList(),
              SizedBox(height: 20),
              _buildBudgetSummary(),
              SizedBox(height: 20),
              _buildReasoning(),
              SizedBox(height: 20),
              _buildErrorMessage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shopping Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: _handleClear,
                  child: Text('Clear'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: controller.budgetController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Budget (₹)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.currency_rupee),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: controller.productsController,
              decoration: InputDecoration(
                labelText: 'Products (comma-separated)',
                hintText: 'milk, butter, etc.',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.shopping_cart),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() => ElevatedButton(
      onPressed: controller.isLoading.value ? null : _handleSubmit,
      child: controller.isLoading.value
          ? CircularProgressIndicator(color: Colors.white)
          : Text('Get Recommendations'),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 15),
        backgroundColor: Colors.teal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ));
  }

  Widget _buildRecommendationsList() {
    return Obx(() => controller.recommendedItems.isNotEmpty
        ? Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recommended Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            ...controller.recommendedItems.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Expanded(child: Text(item)),
                ],
              ),
            )),
          ],
        ),
      ),
    )
        : SizedBox());
  }

  Widget _buildBudgetSummary() {
    return Obx(() => controller.totalCost.value > 0
        ? Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Budget Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Cost:', style: TextStyle(fontSize: 16)),
                Text(
                  '₹${controller.totalCost.value.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.budgetDifference.value >= 0
                      ? 'Amount Saved:'
                      : 'Amount Exceeded:',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '₹${controller.budgetDifference.value.abs().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: controller.budgetDifference.value >= 0
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )
        : SizedBox());
  }

  Widget _buildReasoning() {
    return Obx(() => controller.reasoning.isEmpty
        ? SizedBox()
        : Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reasoning',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(controller.reasoning.value),
          ],
        ),
      ),
    ));
  }

  Widget _buildErrorMessage() {
    return Obx(() => controller.errorMessage.isNotEmpty
        ? Card(
      elevation: 4,
      color: Colors.red[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          controller.errorMessage.value,
          style: TextStyle(color: Colors.red[900], fontSize: 16),
        ),
      ),
    )
        : SizedBox());
  }

  void _handleClear() {
    controller.clearAll();
  }

  void _handleSubmit() async {
    if (controller.budgetController.text.isEmpty ||
        controller.productsController.text.isEmpty) {
      controller.setErrorMessage('Please enter both budget and products.');
      return;
    }

    try {
      await controller.submitShoppingList();
    } catch (e) {
      controller.setErrorMessage('An error occurred: ${e.toString()}');
    }
  }
}

