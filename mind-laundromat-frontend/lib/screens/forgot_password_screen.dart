import 'package:flutter/material.dart';
import 'package:mind_laundromat/widgets/custom_app_bar.dart';
import 'package:mind_laundromat/widgets/coming_soon_widget.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '',),
      backgroundColor: Colors.white,
      body: ComingSoonWidget(),
    );
  }
}
