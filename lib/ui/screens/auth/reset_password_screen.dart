import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_assignment/data/models/network_response.dart';
import 'package:task_manager_assignment/data/network_caller/network_caller.dart';
import 'package:task_manager_assignment/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager_assignment/ui/utility/app_colors.dart';
import 'package:task_manager_assignment/ui/widgets/background_widget.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String emailAddress;
  final String otp;
  const ResetPasswordScreen({
    super.key,
    required this.emailAddress,
    required this.otp,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _confirmPasswordTEController =
  TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
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
                      'Set Password',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'Minimum length of password should be more than 6 letters and, combination of numbers and letters',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _passwordTEController,
                      decoration: const InputDecoration(hintText: 'Password'),
                      obscureText: false,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _confirmPasswordTEController,
                      decoration:
                      const InputDecoration(hintText: 'Confirm Password'),
                      obscureText: false,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _onTapConfirmButton,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Confirm'),
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
                            )
                          ],
                        ),
                      ),
                    )
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
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      ),
          (route) => false,
    );
  }

  void _onTapConfirmButton() async {
    if (_passwordTEController.text != _confirmPasswordTEController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await _resetPassword(
      widget.emailAddress,
      widget.otp,
      _passwordTEController.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (response.isSuccess) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInScreen(),
        ),
            (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Failed to reset password: ${response.errorMessage ?? 'Unknown error'}'),
        ),
      );
    }
  }

  Future<NetworkResponse> _resetPassword(
      String email, String otp, String password) async {
    const String url = '$_baseUrl/RecoverResetPass';
    final Map<String, dynamic> body = {
      'email': email,
      'OTP': otp,
      'password': password,
    };

    debugPrint('Sending POST request to $url with body: $body');
    final response = await NetworkCaller.postRequest(url, body: body);
    debugPrint('Response: ${response.statusCode}, ${response.responseData}');
    return response;
  }

  @override
  void dispose() {
    _confirmPasswordTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}