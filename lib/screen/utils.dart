import 'package:url_launcher/url_launcher.dart';

Future<void> callRestaurant(String phoneNumber) async {
  final Uri phoneUri = Uri.parse("tel:$phoneNumber");
  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
  } else {
    print("⚠️ لا يمكن إجراء الاتصال");
  }
}
