import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_assignment/data/models/network_response.dart';
import 'package:task_manager_assignment/data/network_caller/network_caller.dart';
import 'package:task_manager_assignment/ui/screens/auth/reset_password_screen.dart';
import 'package:task_manager_assignment/ui/screens/auth/sign_in_screen.dart';
import 'package:task_manager_assignment/ui/utility/app_colors.dart';
import 'package:task_manager_assignment/ui/widgets/background_widget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class PinVerificationScreen extends StatefulWidget {
  final String emailAddress;
  final String otp;
  const PinVerificationScreen({
    super.key,
    required this.emailAddress,
    required this.otp,
  });
  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final TextEditingController _pinTEController = TextEditingController();
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
                      'Pin Verification',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      'A 6 digits verification pin has been sent to your email address',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 24),
                    _buildPinCodeTextField(),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _onTapVerifyOtpButton,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Verify'),
                    ),
                    const SizedBox(height: 36),
                    _buildSignInSection()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInSection() {
    return Center(
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.black.withOpacity(0.8),
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
          text: "Have account? ",
          children: [
            TextSpan(
              text: 'Sign in',
              style: const TextStyle(color: AppColors.themeColor),
              recognizer: TapGestureRecognizer()..onTap = _onTapSignInButton,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPinCodeTextField() {
    return PinCodeTextField(
      length: 6,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(5),
        fieldHeight: 50,
        fieldWidth: 40,
        activeFillColor: Colors.white,
        selectedFillColor: Colors.white,
        inactiveFillColor: Colors.white,
        selectedColor: AppColors.themeColor,
      ),
      animationDuration: const Duration(milliseconds: 300),
      backgroundColor: Colors.transparent,
      keyboardType: TextInputType.number,
      enableActiveFill: true,
      controller: _pinTEController,
      appContext: context,
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

  void _onTapVerifyOtpButton() async {
    setState(() {
      _isLoading = true;
    });

    String otp = _pinTEController.text.trim();
    final response = await _verifyOTP(otp);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (response.isSuccess) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(
            emailAddress: widget.emailAddress,
            otp: otp,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Failed to verify OTP: ${response.errorMessage ?? 'Unknown error'}'),
        ),
      );
    }
  }

  Future<NetworkResponse> _verifyOTP(String otp) async {
    final String url = '$_baseUrl/RecoverVerifyOTP/${widget.emailAddress}/$otp';
    return NetworkCaller.getRequest(url);
  }

  @override
  void dispose() {
    _pinTEController.dispose();
    super.dispose();
  }
}










