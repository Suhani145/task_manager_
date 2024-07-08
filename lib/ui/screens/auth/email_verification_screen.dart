import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_assignment/data/models/network_response.dart';
import 'package:task_manager_assignment/data/network_caller/network_caller.dart';
import 'package:task_manager_assignment/ui/screens/auth/pin_verification_screen.dart';
import 'package:task_manager_assignment/ui/utility/app_colors.dart';
import 'package:task_manager_assignment/ui/widgets/background_widget.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  bool _isLoading = false;
  static const String _baseUrl = 'https://task.teamrabbil.com/api/v1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Your Email Address',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'A 6 digits verification pin will be sent to your email address',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _emailTEController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: 'Email'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _onTapConfirmButton,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Icon(Icons.arrow_circle_right_outlined),
                    ),
                    const SizedBox(height: 36),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Colors.black.withOpacity(0.8),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                          ),
                          text: "Have an account? ",
                          children: [
                            TextSpan(
                              text: 'Sign in',
                              style:
                              const TextStyle(color: AppColors.themeColor),
                              recognizer: TapGestureRecognizer()
                                ..onTap = _onTapSignInButton,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignInButton() {
    Navigator.pop(context);
  }

  void _onTapConfirmButton() async {
    setState(() {
      _isLoading = true;
    });

    String email = _emailTEController.text.trim();
    final response = await _sendVerificationEmail(email);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (response.isSuccess) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PinVerificationScreen(
            emailAddress: email,
            otp: '',
          ), // Pass email address
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Failed to send verification email: ${response.errorMessage ?? 'Unknown error'}'),
        ),
      );
    }
  }

  Future<NetworkResponse> _sendVerificationEmail(String email) async {
    final String url = '$_baseUrl/RecoverVerifyEmail/$email';
    return NetworkCaller.getRequest(url);
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}

























