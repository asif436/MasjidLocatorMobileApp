import 'package:salahmaskan/utils/routes.dart';
import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          titleTextStyle: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          title: const Text('Privacy Policy'),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.home, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, MyRoutes.homeRoute);
              },
            ),
            IconButton(
              icon: const Icon(Icons.login_rounded, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, MyRoutes.loginRoute);
              },
            ),
            IconButton(
              icon: const Icon(Icons.app_registration_rounded,
                  color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, MyRoutes.registrationRoute);
              },
            ),
            IconButton(
              icon: const Icon(Icons.privacy_tip, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, MyRoutes.PrivacyPolicyRoute);
              },
            ),
          ],
        ),
        body: Material(
            color: Colors.white,
            child: SingleChildScrollView(
                child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Image.asset(
                  "assets/images/favicon.png",
                  fit: BoxFit.cover,
                  height: 140,
                  width: 140,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Privacy Policy for MasjidLocator App.",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Effective Date: 17th Nov. 2024"),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("1. Introduction",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ))),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                    "Welcome to MasjidLocator Application! We value your privacy and are committed to protecting your personal information. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application."),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("2. Information We Collect",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                    "Personal Data: We may collect personal information that you provide to us, such as your name, email address, and phone number."),
                const Text(
                    "Location Data: Our app may request access to your device's location services to provide personalized content and features. We may collect precise location data (GPS) or approximate location data (network-based)."),
                const Text(
                    "Usage Data: We may collect information about your interactions with the app, including device information, IP address, operating system, and app usage patterns. "),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("3. How We Use Your Information",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "We use the information we collect for various purposes, including to:")),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("• Provide and maintain our app")),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "• Improve, personalize, and expand our services")),
                const Align(
                    alignment: Alignment.centerLeft,
                    child:
                        Text("• Understand and analyze how you use our app")),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "• Communicate with you, including sending updates and notifications")),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "• Detect, prevent, and address technical issues")),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("4. Location Services",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "When you use our app, we may access your device’s location data to:")),
                const Align(
                    alignment: Alignment.centerLeft,
                    child:
                        Text("• Offer location-based services and features")),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "• Enhance user experience by providing relevant content")),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "You can manage your location data preferences in your device settings. Note that disabling location services may affect the functionality of our app.")),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("5. Sharing Your Information",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "We do not sell your personal information. We may share your information with:")),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "• Service Providers: Third-party vendors who assist us in operating our app and providing services.")),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "• Legal Authorities: If required by law or to respond to legal requests.")),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("6. Data Security",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "We take reasonable measures to protect your information from unauthorized access, use, or disclosure. However, no method of transmission over the internet or electronic storage is 100% secure.")),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("7. Your Rights",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "Depending on your jurisdiction, you may have the right to:")),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "Access, correct, or delete your personal information")),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Withdraw consent for processing your data")),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Object to the processing of your data")),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("8. Changes to This Privacy Policy",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy in the app. You are advised to review this Privacy Policy periodically for any changes.")),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("9. Contact Us",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                        "If you have any questions or concerns about this Privacy Policy, please contact us at:")),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Email : admin@mwsolutiondevelopers.com")),
                const SizedBox(
                  height: 10,
                ),
              ],
            ))));
  }
}
