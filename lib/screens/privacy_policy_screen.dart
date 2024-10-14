import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy for RecipeMe',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Effective Date: 10/10/2024',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'At RecipeMe, your privacy is important to us. This Privacy Policy outlines how we collect, use, and protect your personal information when you use our app.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Information We Collect',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                '1. Personal Information:\n'
                '   - We may collect personal information such as your name, email address, and profile picture when you create an account.\n'
                '\n'
                '2. Usage Data:\n'
                '   - We collect data about how you use the app, including the recipes you view, search terms, and the duration of your visits.\n'
                '\n'
                '3. Device Information:\n'
                '   - We may collect information about your device, including your device type, operating system, and unique device identifiers.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'How We Use Your Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'We use the collected information for the following purposes:\n'
                '- To Provide and Maintain Our Service:\n'
                '  - We use your information to ensure the app functions properly and to improve user experience.\n'
                '\n'
                '- To Personalize User Experience:\n'
                '  - We may use your information to personalize content and recommendations based on your preferences.\n'
                '\n'
                '- To Communicate with You:\n'
                '  - We may send you updates, newsletters, and promotional materials regarding our app and services.\n'
                '\n'
                '- To Analyze Usage:\n'
                '  - We analyze usage data to improve our app, develop new features, and enhance user satisfaction.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Data Sharing and Disclosure',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'We do not sell, trade, or otherwise transfer your personal information to outside parties without your consent, except in the following circumstances:\n'
                '- With Service Providers:\n'
                '  - We may share your information with trusted third-party service providers who assist us in operating our app and conducting our business.\n'
                '\n'
                '- For Legal Compliance:\n'
                '  - We may disclose your information when required to do so by law or in response to valid requests by public authorities.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Data Security',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'We implement reasonable security measures to protect your personal information from unauthorized access, use, or disclosure. However, no method of transmission over the internet or method of electronic storage is 100% secure.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Your Rights',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'You have the right to:\n'
                '- Access and update your personal information.\n'
                '- Request deletion of your personal information.\n'
                '- Opt-out of receiving promotional communications from us.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Changes to This Privacy Policy',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page. You are advised to review this Privacy Policy periodically for any changes.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'Contact Us',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'If you have any questions about this Privacy Policy, please contact us at:\n\n'
                'Email: abhinavaneesh2@gmail.com\n'
                '''Address: Hustle Hub Tech park
                Hsr Layout Sector 2''',
                style: TextStyle(fontSize: 17),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
