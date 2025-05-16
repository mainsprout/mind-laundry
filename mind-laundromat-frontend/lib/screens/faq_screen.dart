import 'package:flutter/material.dart';
import 'package:mind_laundromat/widgets/custom_app_bar.dart';
import 'package:mind_laundromat/widgets/coming_soon_widget.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'FAQ'),
      backgroundColor: Colors.white,
      body: ComingSoonWidget(),
    );
  }
}
