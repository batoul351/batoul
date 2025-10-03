import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../Controller/meal_controller.dart';

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
    final theme = Theme.of(context);
    final accentColor = theme.primaryColor;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black;
    final subtitleColor = theme.textTheme.bodySmall?.color ?? Colors.grey;
    final cardColor = theme.cardColor;

    final meal = widget.meal;
    final bool hasDiscount = meal['price_reductions'] == "yes";
    final double price = (meal['price'] as num?)?.toDouble() ?? 0.0;
    final int discountRate = (meal['discount_rate'] as num?)?.toInt() ?? 0;
    final String? originalPrice = hasDiscount
        ? (price / (1 - (discountRate / 100))).toStringAsFixed(1)
        : null;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: accentColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          meal['name'] ?? 'Meal Details',
          style: theme.textTheme.titleLarge?.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: meal['image'] != null
                ? Image.network(
                    meal['image'],
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Container(
                    height: 250,
                    color: cardColor,
                    child: Center(
                      child: Icon(Icons.fastfood, size: 80, color: accentColor),
                    ),
                  ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildSectionTitle(context, "Description:"),
                  Text(
                    meal['describe'] ?? 'No description available',
                    style: TextStyle(fontSize: 16, color: subtitleColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),

                  _buildSectionTitle(context, "Price:"),
                  hasDiscount
                      ? Column(
                          children: [
                            Text(
                              "Before Discount: $originalPrice SYP",
                              style: TextStyle(
                                fontSize: 16,
                                color: subtitleColor,
                                decoration: TextDecoration.lineThrough,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Now: ${price.toStringAsFixed(1)} SYP",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Discount: $discountRate%",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.orangeAccent,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )
                      : Text(
                          "$price SYP",
                          style: TextStyle(fontSize: 16, color: subtitleColor),
                          textAlign: TextAlign.center,
                        ),
                  const SizedBox(height: 10),

                  _buildSectionTitle(context, "Available Quantity:"),
                  Text(
                    "${meal['amounts']}",
                    style: TextStyle(fontSize: 16, color: subtitleColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  _buildSectionTitle(context, "Rate this meal:"),
                  const SizedBox(height: 8),
                  RatingBar.builder(
                    initialRating: 0,
                    minRating: 1,
                    itemCount: 5,
                    itemSize: 35,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    unratedColor: cardColor,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(Icons.star, color: accentColor),
                    onRatingUpdate: (rating) {
                      selectedRating = rating;
                    },
                  ),
                  const SizedBox(height: 15),

                  ElevatedButton(
                    onPressed: () {
                      if (selectedRating == 0) {
                        Get.snackbar("Rating Required", "Please select at least one star.",
                            backgroundColor: Colors.orange);
                      } else {
                        mealController.submitRating(
                          meal['id'],
                          selectedRating.toInt().toString(),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Submit Rating",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

  Widget _buildSectionTitle(BuildContext context, String title) {
    final accentColor = Theme.of(context).primaryColor;
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: accentColor,
      ),
    );
  }
}
