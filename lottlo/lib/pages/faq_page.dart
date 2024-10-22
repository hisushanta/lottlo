import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 69, 91, 102),
        title: const Text(
          'Frequently Asked Questions',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold,fontSize: 18.0),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: const Color.fromARGB(255, 255, 255, 255)), // Customize this icon
          onPressed: () {
            Navigator.pop(context); // Navigate back when the button is pressed
          }),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'How can we help you today?',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildFAQItem(
              question: 'What is the Lottlo app?',
              answer:
                  'Kachra Wala is a waste management app that helps you stay informed about waste collection schedules, recycling tips, and other waste-related services in your area.',
            ),
            
            _buildFAQItem(
              question: 'How can I contact customer support?',
              answer:
                  'You can reach customer support by calling +917596912157 or emailing us at askkachrawala@gmail.com. We’re here to help!',
            ),
            _buildFAQItem(
              question: 'How do I update my profile?',
              answer:
                  'To update your profile, go to the User Profile section in the app. From there, you can edit your name, and profile picture.',
            ),
            _buildFAQItem(
              question: 'What should I do if I forget my password?',
              answer:
                  'If you forget your password, you can reset it by clicking on "Forgot Password" on the login screen. Follow the instructions to reset your password.',
            ),
            const SizedBox(height: 30),
            Center(
              child: Text(
                'Still have questions? Contact us at askkachrawala@gmail.com.',
                style: TextStyle(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Card(
      elevation: 3,
      color:  Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ExpansionTile(
        collapsedIconColor: const Color.fromARGB(255, 246, 181, 40),
        iconColor: const Color.fromARGB(255, 246, 181, 40),
        title: Text(
          question,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              answer,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
