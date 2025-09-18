import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../api_service/api_Meals.dart';

class MealDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> meal;

  MealDetailsScreen({required this.meal});

  @override
  State<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  final MealController mealController = Get.put(MealController());
  double selectedRating = 0.0;

  @override
  Widget build(BuildContext context) {
    final meal = widget.meal;
    final bool hasDiscount = meal['price_reductions'] == "yes";
    final double price = (meal['price'] as num?)?.toDouble() ?? 0.0;
    final int discountRate = (meal['discount_rate'] as num?)?.toInt() ?? 0;
    final String? originalPrice = hasDiscount
        ? (price / (1 - (discountRate / 100))).toStringAsFixed(1)
        : null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          meal['name'] ?? 'Meal Details',
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 235, 200, 190),
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/food.png', // ✅ صورة محلية ثابتة
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildSectionTitle("Description:"),
                  Text(
                    meal['describe'] ?? 'No description available',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  _buildSectionTitle("Price:"),
                  hasDiscount
                      ? Column(
                          children: [
                            Text(
                              "Before Discount: $originalPrice SYP",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Now: ${price.toStringAsFixed(1)} SYP",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Discount: $discountRate%",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.orangeAccent,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      : Text(
                          "$price SYP",
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                  const SizedBox(height: 10),

                  _buildSectionTitle("Available Quantity:"),
                  Text(
                    "${meal['amounts']}",
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  _buildSectionTitle("Rate this meal:"),
                  const SizedBox(height: 8),
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    itemCount: 5,
                    itemSize: 35,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    unratedColor: Colors.grey.shade300,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Color.fromARGB(255, 235, 200, 190),
                    ),
                    onRatingUpdate: (rating) {
                      selectedRating = rating;
                    },
                  ),
                  const SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: () {
                      if (selectedRating == 0) {
                        Get.snackbar(
                          "Rating Required",
                          "Please select at least one star.",
                          backgroundColor: Colors.orange,
                        );
                      } else {
                        mealController.submitRating(
                          meal['id'],
                          selectedRating.toInt().toString(),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 235, 200, 190),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Submit Rating",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 235, 200, 190),
      ),
    );
  }
}
